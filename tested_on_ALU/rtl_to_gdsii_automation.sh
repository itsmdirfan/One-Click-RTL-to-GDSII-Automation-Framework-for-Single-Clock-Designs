#!/usr/bin/env bash
# rtl_to_gdsii_automation.sh
# Full automation: Runs Genus Synthesis, waits for completion, and then runs Innovus PD.

set -euo pipefail
IFS=$'\n\t'


# ===================================================================
#                          VLSI PC DETECTION
# ===================================================================


DEFAULT_VLSI_PC=12
if [ $# -ge 1 ] && [[ "$1" =~ ^[0-9]+$ ]]; then
  VLSI_PC="$1"
elif [[ "$PWD" =~ /home/vlsi([0-9]+)(/|$) ]]; then
  VLSI_PC="${BASH_REMATCH[1]}"
else
  VLSI_PC="$DEFAULT_VLSI_PC"
fi


# ===================================================================
#                  SCL PDK and CADENCE CSH PATHS
# ===================================================================


PDK_BASE="/home/vlsi${VLSI_PC}/Downloads/scl_pdk"
CADENCE_CSH="/home/vlsi${VLSI_PC}/c2s/cadence/install/cshrc"


# ===================================================================
#                      GLOBAL CONFIGURATION
# ===================================================================


GENUS_CMD="genus"
INNOVUS_CMD="innovus"
PROJECT_ROOT="$PWD"
SYN_DIR="$PROJECT_ROOT/1_synthesis"
FLOOR_DIR="$PROJECT_ROOT/2_floorplan"
SYNTHESIS_CHECKPOINT="$SYN_DIR/.synthesis_done"


echo "=== FULL RTL to GDSII AUTOMATION START ==="
echo "Project Root: $PROJECT_ROOT"
echo "Cadence cshrc: $CADENCE_CSH"
echo "Using vlsi PC number: $VLSI_PC"
echo


# ===================================================================
#                      SYNTHESIS STAGE (GENUS) 
# ===================================================================


echo "--- Starting Genus Synthesis ---"
mkdir -p "$SYN_DIR"
cp source.v "$SYN_DIR/source.v"
export PDK_BASE # Export variable for Genus TCL access


# ===================================================================
#                      WRITE GENUS TCL SCRIPT
# ===================================================================


cat > "$SYN_DIR/synth_script.tcl" <<'TCL_EOF'
#!/usr/bin/tclsh

set_attribute init_lib_search_path $env(PDK_BASE)/stdlib/fs120/liberty/lib_flow_ss
set_attribute library tsl18fs120_scl_ss.lib
set_attribute init_hdl_search_path ../$env(PWD)
set_attribute information_level 6

set myfiles "source.v"
set basename "source"
set myClk "clk"
set myPeriod_ps 5000
set myInDelay_ns 1
set myOutDelay_ns 1
set runname "synth_report"

read_hdl -sv $myfiles
elaborate $basename

define_clock -name $myClk -period $myPeriod_ps [get_ports $myClk]
set_clock_transition 0.1 [get_clocks $myClk]
set_input_delay $myInDelay_ns -clock $myClk [remove_from_collection [all_inputs] [get_ports $myClk]]
set_output_delay $myOutDelay_ns -clock $myClk [all_outputs]

set_attribute syn_generic_effort high
set_attribute syn_map_effort high
set_attribute syn_opt_effort high

check_design -unresolved
report timing -lint
syn_gen
syn_map
syn_opt

write_hdl -mapped > ${basename}_netlist.v
write_sdc > ${basename}.sdc

report_timing > ${runname}_timing.rpt
report_gates > ${runname}_area.rpt
report_power > ${runname}_power.rpt
report_clock > ${runname}_clock.rpt
puts "Synthesis finished";

exit

TCL_EOF


# ===================================================================
#                       EXECUTE GENUS & WAIT
# ===================================================================


echo "Executing Genus... This command will wait until synthesis is complete."
csh -c "cd \"$SYN_DIR\"; source \"$CADENCE_CSH\"; $GENUS_CMD -legacy_ui -f synth_script.tcl"

touch "$SYNTHESIS_CHECKPOINT"
echo "Genus completed. Checkpoint created: $SYNTHESIS_CHECKPOINT"

rm 1_synthesis/synth_script.tcl


# ===================================================================
#                            PD STAGES INNOVUS
# ===================================================================


echo "--- Starting Innovus Physical Design ---"

PROJECT_ROOT="$PWD"
SYN_DIR="$PROJECT_ROOT/1_synthesis"
FLOOR_DIR="$PROJECT_ROOT/2_floorplan"

mkdir -p "$FLOOR_DIR"

# copy RTL and synthesized netlist
cp -f "$PROJECT_ROOT/source.v" "$FLOOR_DIR/source.v"
cp -f "$SYN_DIR/source_netlist.v" "$FLOOR_DIR/source_netlist.v"
cp -f "$SYN_DIR/source.sdc" "$FLOOR_DIR/source.sdc"


# ===================================================================
#                          PADFRAME GENERATOR
# ===================================================================


cat > "$FLOOR_DIR/padframe_generator.sh" <<'BASHPAD'
#!/usr/bin/env bash
# padframe_generator.sh
# Usage:
#   ./padframe_generator.sh [verilog_file]
# Default verilog_file = source_netlist.v

set -euo pipefail
IFS=$'\n\t'

VERILOG="${1:-source_netlist.v}"
OUT="padframe.io"

if [[ ! -f "$VERILOG" ]]; then
  echo "ERROR: Verilog file '$VERILOG' not found."
  echo "Usage: $0 [verilog_file]"
  exit 1
fi

pow_pins=(VDD VDDO VSSO VSS)

# 1) Extract input/output declarations (remove comments first)
file_text=$(sed -E 's/\/\/.*$//g; s/\/\*.*\*\///g' "$VERILOG" | tr '\n' ' ')
IFS=';' read -r -a stmts <<< "$file_text"

orig_inputs=()
orig_outputs=()

for stmt in "${stmts[@]}"; do
  stmt_trim=$(echo "$stmt" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')
  if [[ "$stmt_trim" =~ ^input[[:space:]] ]]; then
    body=$(echo "$stmt_trim" | sed -E 's/^input[[:space:]]+//')
    if [[ "$body" =~ \[([0-9]+)[[:space:]]*:[[:space:]]*([0-9]+)\] ]]; then
      msb=${BASH_REMATCH[1]}; lsb=${BASH_REMATCH[2]}
      body=$(echo "$body" | sed -E "s/\[[0-9]+:[0-9]+\]//")
      IFS=',' read -r -a names <<< "$body"
      for nm in "${names[@]}"; do
        name=$(echo "$nm" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//; s/[,:]$//')
        if (( msb >= lsb )); then
          for ((b=msb;b>=lsb;b--)); do
            orig_inputs+=("${name}[${b}]")
          done
        else
          for ((b=msb;b<=lsb;b++)); do
            orig_inputs+=("${name}[${b}]")
          done
        fi
      done
    else
      IFS=',' read -r -a names <<< "$body"
      for nm in "${names[@]}"; do
        name=$(echo "$nm" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//; s/[,:]$//')
        if [[ -n "$name" ]]; then
          orig_inputs+=("$name")
        fi
      done
    fi

  elif [[ "$stmt_trim" =~ ^output[[:space:]] ]]; then
    body=$(echo "$stmt_trim" | sed -E 's/^output[[:space:]]+//')
    body=$(echo "$body" | sed -E 's/^(reg|wire)[[:space:]]+//')
    if [[ "$body" =~ \[([0-9]+)[[:space:]]*:[[:space:]]*([0-9]+)\] ]]; then
      msb=${BASH_REMATCH[1]}; lsb=${BASH_REMATCH[2]}
      body=$(echo "$body" | sed -E "s/\[[0-9]+:[0-9]+\]//")
      IFS=',' read -r -a names <<< "$body"
      for nm in "${names[@]}"; do
        name=$(echo "$nm" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//; s/[,:]$//')
        if (( msb >= lsb )); then
          for ((b=msb;b>=lsb;b--)); do
            orig_outputs+=("${name}[${b}]")
          done
        else
          for ((b=msb;b<=lsb;b++)); do
            orig_outputs+=("${name}[${b}]")
          done
        fi
      done
    else
      IFS=',' read -r -a names <<< "$body"
      for nm in "${names[@]}"; do
        name=$(echo "$nm" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//; s/[,:]$//')
        if [[ -n "$name" ]]; then
          orig_outputs+=("$name")
        fi
      done
    fi
  fi
done

# Build orig_padlist (inputs then outputs) and append power pins unchanged
orig_padlist=()
for s in "${orig_inputs[@]}"; do orig_padlist+=("$s"); done
for s in "${orig_outputs[@]}"; do orig_padlist+=("$s"); done
for p in "${pow_pins[@]}"; do orig_padlist+=("$p"); done

# 2) Create transformed pad names: prefix p for inputs and outputs, keep power names unchanged
pad_names=()
for orig in "${orig_padlist[@]}"; do
  # If this orig is one of the power pins (exact match), keep unchanged
  is_power=0
  for pp in "${pow_pins[@]}"; do
    if [[ "$orig" == "$pp" ]]; then is_power=1; break; fi
  done
  if [[ $is_power -eq 1 ]]; then
    pad_names+=("$orig")
    continue
  fi

  # If vector like name[idx], convert to p<name>_<idx>
  if [[ "$orig" =~ ^([a-zA-Z_][a-zA-Z0-9_]*)\[([0-9]+)\]$ ]]; then
    base="${BASH_REMATCH[1]}"
    idx="${BASH_REMATCH[2]}"
    newname="p${base}_${idx}"
    pad_names+=("$newname")
  else
    # scalar: remove unwanted chars and prefix p
    clean=$(echo "$orig" | sed -E 's/[^a-zA-Z0-9_]/_/g')
    newname="p${clean}"
    pad_names+=("$newname")
  fi
done

# 3) Pad count adjust (round up to multiple of 4)
total=${#pad_names[@]}
rounded=$(( ( (total + 3) / 4 ) * 4 ))
dummies=$(( rounded - total ))
per_side=$(( rounded / 4 ))

for ((i=1;i<=dummies;i++)); do
  orig_padlist+=("DUMMY_${i}")
  pad_names+=("pDUMMY_${i}")
done

# 4) Distribute pad_names across sides sequentially
left=(); top=(); right=(); bottom=()
idx=0
for pn in "${pad_names[@]}"; do
  side=$(( idx / per_side ))
  case $side in
    0) left+=("$pn") ;;
    1) top+=("$pn") ;;
    2) right+=("$pn") ;;
    3) bottom+=("$pn") ;;
  esac
  idx=$((idx+1))
done

# Build lookup of original outputs (for pad cell selection)
declare -A is_output
for o in "${orig_outputs[@]}"; do
  is_output["$o"]=1
done

# function to choose cell: uses pad name -> map back to original where possible, and checks power list
cell_for() {
  local padname="$1"
  # power pins exact match
  for pp in "${pow_pins[@]}"; do
    if [[ "$padname" == "$pp" ]]; then
      case "$pp" in
        VDD) echo "pvdi"; return ;;
        VDDO) echo "pvda"; return ;;
        VSSO) echo "pv0a"; return ;;
        VSS) echo "pv0i"; return ;;
      esac
    fi
  done
  # dummy
  if [[ "$padname" == pDUMMY_* ]]; then
    echo "pc3d01"; return
  fi
  # map padname back to orig form to check if it's an output
  if [[ "$padname" =~ ^p([a-zA-Z_][a-zA-Z0-9_]*)_([0-9]+)$ ]]; then
    base="${BASH_REMATCH[1]}"
    idx="${BASH_REMATCH[2]}"
    orig="${base}[${idx}]"
  else
    base="${padname#p}"
    orig="$base"
  fi
  if [[ -n "${is_output[$orig]:-}" ]]; then
    echo "pc3o01"; return
  else
    echo "pc3d01"; return
  fi
}

# 5) Write padframe.io
cat > "$OUT" <<EOF
(globals
version = 3
io_order = clockwise
space = 20 #Spacing between 2 IO pads
total_edge = ${per_side}
)

(iopad
(topleft
(inst name="CornerCell1" cell=pfrelr offset=0 orientation=R180 place_status=fixed )
)
(left
EOF

for s in "${left[@]}"; do
  c=$(cell_for "$s")
  printf "\t\t( inst name=\"%s\" cell=%s place_status=fixed)\n" "$s" "$c" >> "$OUT"
done

cat >> "$OUT" <<EOF
)
(topright
(inst name="CornerCell2" cell=pfrelr offset=0 orientation=R90 place_status=fixed )
)
( top
EOF

for s in "${top[@]}"; do
  c=$(cell_for "$s")
  printf "\t\t( inst name=\"%s\" cell=%s place_status=fixed)\n" "$s" "$c" >> "$OUT"
done

cat >> "$OUT" <<EOF
)
(bottomright
(inst name="CornerCell3" cell=pfrelr offset=0 orientation=R0 place_status=fixed )
)
( right
EOF

for s in "${right[@]}"; do
  c=$(cell_for "$s")
  printf "\t\t( inst name=\"%s\" cell=%s place_status=fixed)\n" "$s" "$c" >> "$OUT"
done

cat >> "$OUT" <<EOF
)
(bottomleft
(inst name="CornerCell4" cell=pfrelr offset=0 orientation=R270 place_status=fixed )
)
(bottom
EOF

for s in "${bottom[@]}"; do
  c=$(cell_for "$s")
  printf "\t\t( inst name=\"%s\" cell=%s place_status=fixed)\n" "$s" "$c" >> "$OUT"
done

cat >> "$OUT" <<EOF
)
)
EOF

# 6) Print summary
echo "Generated $OUT"
echo "Original ports: inputs=${#orig_inputs[@]} outputs=${#orig_outputs[@]}"
echo "Total pads (incl power) = $total -> rounded to $rounded"
echo "Dummies added = $dummies"
echo "Pads per side = $per_side"
echo "Left:${#left[@]} Top:${#top[@]} Right:${#right[@]} Bottom:${#bottom[@]}"

BASHPAD

chmod +x "$FLOOR_DIR/padframe_generator.sh"

# run padframe generator and capture output (padframe.io will be created)
pushd "$FLOOR_DIR" >/dev/null
./padframe_generator.sh source_netlist.v

# per-side detection for floorplan spacing---
PADFILE="padframe.io"
DEFAULT_WIDTH=780
WIDTH=$DEFAULT_WIDTH
per_side_detect=0

if [ -f "$PADFILE" ]; then
  # Prefer reading total_edge from globals
  tot=$(grep -E '^[[:space:]]*total_edge' "$PADFILE" 2>/dev/null | sed -E 's/[^0-9]*([0-9]+).*/\1/' || true)
  if [ -n "$tot" ]; then
    per_side_detect="$tot"
  else
    # fallback: count total inst name= occurrences (includes corners) then compute per-side
    total_inst=$(grep -c 'inst name=' "$PADFILE" || true)
    if [ -n "$total_inst" ] && [ "$total_inst" -gt 4 ]; then
      pads_total=$(( total_inst - 4 ))   # remove 4 corner cells
      # pads_total should be multiple of 4 (your generator ensures this)
      per_side_detect=$(( pads_total / 4 ))
    else
      per_side_detect=3
    fi
  fi

  # compute WIDTH for Floorplan
  WIDTH=$(( 780 + (per_side_detect - 3) * 90 ))
  if [ "$WIDTH" -le 0 ]; then WIDTH=$DEFAULT_WIDTH; fi
else
  echo "Warning: $PADFILE not found; using default width $DEFAULT_WIDTH"
  per_side_detect=3
  WIDTH=$DEFAULT_WIDTH
fi

echo "Pad count per side detected: $per_side_detect  -> computed floorplan width: $WIDTH"
popd >/dev/null


# ===================================================================
#                       MODIFIED NETLIST GENERATOR        
# ===================================================================


cat > "$FLOOR_DIR/modified_netlist_generator.sh" <<'BASHPAD'
#!/usr/bin/env bash
# modified_netlist_generator.sh
# Usage: bash modified_netlist_generator.sh <synth_netlist.v>
# Output: <synth_netlist>_modified.v

set -euo pipefail
IFS=$'\n\t'

if [ $# -ne 1 ]; then
  echo "Usage: $0 <synth_netlist.v>"
  exit 1
fi

NETLIST="$1"
if [ ! -f "$NETLIST" ]; then
  echo "Netlist not found: $NETLIST"
  exit 1
fi

OUT="${NETLIST%.*}_modified.v"
TMP="${NETLIST%.*}_tmp.v"

# Power pins to ignore (exact names)
pow_pins=(VDD VDDO VSSO VSS)

trim() { printf "%s" "$1" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//'; }
is_power() {
  local n="$1"
  for p in "${pow_pins[@]}"; do [ "$n" = "$p" ] && return 0; done
  return 1
}
is_clock() {
  local s="$1"
  s="${s%%[*}"   # strip possible [idx]
  # heuristic: contains 'clk' (case-insensitive)
  if printf "%s" "$s" | grep -qi "clk"; then return 0; fi
  return 1
}

# Read entire netlist into one-line text for body-style parsing
net_one_line=$(sed -E 's/\/\/.*$//g; :a; s:/\*[^*]*\*+([^/*][^*]*\*+)*/::; ta' "$NETLIST" | tr '\n' ' ')

# 1) Try to extract module header ports (between first "(" after module and ");")
header_raw=""
found=0
accum=""
while IFS= read -r line; do
  line="${line%$'\r'}"
  ln="$(printf "%s" "$line" | sed -E 's/\/\/.*$//g')"
  if [ $found -eq 0 ]; then
    echo "$ln" | grep -qE 'module[[:space:]]+[A-Za-z0-9_]*[[:space:]]*\(' && { found=1; accum="$ln "; echo "$ln" | grep -q '\);' && break; }
  else
    accum="$accum$ln "
    echo "$ln" | grep -q '\);' && break
  fi
done < "$NETLIST"

if [ -n "$accum" ]; then
  accum="${accum#*\(}"
  accum="${accum%%);*}"
  header_raw="$(trim "$accum")"
fi

orig_inputs=()
orig_outputs=()

# parse header if it has explicit input/output declarations (ANSI style)
if [ -n "$header_raw" ]; then
  IFS=',' read -r -a parts <<< "$header_raw"
  for p in "${parts[@]}"; do
    p="$(trim "$p")"
    if printf "%s" "$p" | grep -qE '^(input|output)[[:space:]]+'; then
      p_norm=$(printf "%s" "$p" | sed -E 's/[[:space:]]+/ /g')
      dir=$(printf "%s" "$p_norm" | cut -d' ' -f1)
      rest=$(printf "%s" "$p_norm" | sed -E "s/^${dir}[[:space:]]+//")
      rest=$(printf "%s" "$rest" | sed -E 's/^(wire|reg|logic)[[:space:]]+//')
      if printf "%s" "$rest" | grep -qE '^\[[[:space:]]*[0-9]+[[:space:]]*:[[:space:]]*[0-9]+[[:space:]]*\]'; then
        msb=$(printf "%s" "$rest" | sed -E 's/^\[[[:space:]]*([0-9]+)[[:space:]]*:[[:space:]]*([0-9]+)\].*$/\1/')
        lsb=$(printf "%s" "$rest" | sed -E 's/^\[[[:space:]]*([0-9]+)[[:space:]]*:[[:space:]]*([0-9]+)\].*$/\2/')
        names_part=$(printf "%s" "$rest" | sed -E 's/^\[[^]]*\][[:space:]]*//')
        IFS=' ' read -r -a hdr_names <<< "$names_part"
        for nm in "${hdr_names[@]}"; do
          nm_clean=$(trim "$nm" | sed -E 's/,$//')
          [ -z "$nm_clean" ] && continue
          if [ "$msb" -ge "$lsb" ]; then
            b="$msb"
            while [ "$b" -ge "$lsb" ]; do
              if [ "$dir" = "input" ]; then orig_inputs+=("${nm_clean}[${b}]"); else orig_outputs+=("${nm_clean}[${b}]"); fi
              b=$((b-1))
            done
          else
            b="$msb"
            while [ "$b" -le "$lsb" ]; do
              if [ "$dir" = "input" ]; then orig_inputs+=("${nm_clean}[${b}]"); else orig_outputs+=("${nm_clean}[${b}]"); fi
              b=$((b+1))
            done
          fi
        done
      else
        IFS=' ' read -r -a names <<< "$rest"
        for nm in "${names[@]}"; do
          nm_clean=$(trim "$nm" | sed -E 's/,$//')
          [ -z "$nm_clean" ] && continue
          if [ "$dir" = "input" ]; then orig_inputs+=("$nm_clean"); else orig_outputs+=("$nm_clean"); fi
        done
      fi
    fi
  done
fi

# 2) Parse body style (input ... ;  output ... ;) from the one-line version
IFS=';' read -r -a stmts <<< "$net_one_line"
for stmt in "${stmts[@]}"; do
  stmt_trim=$(trim "$stmt")
  if printf "%s" "$stmt_trim" | grep -qE '^input[[:space:]]+'; then
    body=$(printf "%s" "$stmt_trim" | sed -E 's/^input[[:space:]]+//')
    if printf "%s" "$body" | grep -qE '\[[[:space:]]*[0-9]+[[:space:]]*:[[:space:]]*[0-9]+[[:space:]]*\]'; then
      msb=$(printf "%s" "$body" | sed -E 's/^\[[[:space:]]*([0-9]+)[[:space:]]*:[[:space:]]*([0-9]+)\].*$/\1/')
      lsb=$(printf "%s" "$body" | sed -E 's/^\[[[:space:]]*([0-9]+)[[:space:]]*:[[:space:]]*([0-9]+)\].*$/\2/')
      body2=$(printf "%s" "$body" | sed -E 's/^\[[^]]*\]//')
      IFS=',' read -r -a names <<< "$body2"
      for nm in "${names[@]}"; do
        name=$(trim "$nm" | sed -E 's/[,:]$//')
        [ -z "$name" ] && continue
        if [ "$msb" -ge "$lsb" ]; then
          b="$msb"
          while [ "$b" -ge "$lsb" ]; do orig_inputs+=("${name}[${b}]"); b=$((b-1)); done
        else
          b="$msb"
          while [ "$b" -le "$lsb" ]; do orig_inputs+=("${name}[${b}]"); b=$((b+1)); done
        fi
      done
    else
      IFS=',' read -r -a names <<< "$body"
      for nm in "${names[@]}"; do
        name=$(trim "$nm" | sed -E 's/[,:]$//')
        [ -n "$name" ] && orig_inputs+=("$name")
      done
    fi

  elif printf "%s" "$stmt_trim" | grep -qE '^output[[:space:]]+'; then
    body=$(printf "%s" "$stmt_trim" | sed -E 's/^output[[:space:]]+//')
    body=$(printf "%s" "$body" | sed -E 's/^(reg|wire)[[:space:]]+//')
    if printf "%s" "$body" | grep -qE '\[[[:space:]]*[0-9]+[[:space:]]*:[[:space:]]*[0-9]+[[:space:]]*\]'; then
      msb=$(printf "%s" "$body" | sed -E 's/^\[[[:space:]]*([0-9]+)[[:space:]]*:[[:space:]]*([0-9]+)\].*$/\1/')
      lsb=$(printf "%s" "$body" | sed -E 's/^\[[[:space:]]*([0-9]+)[[:space:]]*:[[:space:]]*([0-9]+)\].*$/\2/')
      body2=$(printf "%s" "$body" | sed -E 's/^\[[^]]*\]//')
      IFS=',' read -r -a names <<< "$body2"
      for nm in "${names[@]}"; do
        name=$(trim "$nm" | sed -E 's/[,:]$//')
        [ -z "$name" ] && continue
        if [ "$msb" -ge "$lsb" ]; then
          b="$msb"
          while [ "$b" -ge "$lsb" ]; do orig_outputs+=("${name}[${b}]"); b=$((b-1)); done
        else
          b="$msb"
          while [ "$b" -le "$lsb" ]; do orig_outputs+=("${name}[${b}]"); b=$((b+1)); done
        fi
      done
    else
      IFS=',' read -r -a names <<< "$body"
      for nm in "${names[@]}"; do
        name=$(trim "$nm" | sed -E 's/[,:]$//')
        [ -n "$name" ] && orig_outputs+=("$name")
      done
    fi
  fi
done

# Ensure uniqueness preserving order
dedup_preserve_order() {
  declare -n arr=$1
  declare -A seen
  new=()
  for x in "${arr[@]}"; do
    if [ -z "${seen[$x]:-}" ]; then seen[$x]=1; new+=("$x"); fi
  done
  arr=("${new[@]}")
}
dedup_preserve_order orig_inputs
dedup_preserve_order orig_outputs

# Build unified ports list (inputs then outputs)
ports=()
for x in "${orig_inputs[@]}"; do ports+=("$x"); done
for x in "${orig_outputs[@]}"; do ports+=("$x"); done

# Build pad instantiation lines
inst_lines=()
declare -A alias_count
for port in "${ports[@]}"; do
  if is_power "$port"; then
    continue
  fi

  if [[ "$port" =~ ^([A-Za-z_][A-Za-z0-9_]*)\[([0-9]+)\]$ ]]; then
    base="${BASH_REMATCH[1]}"
    idx="${BASH_REMATCH[2]}"
    sig="${base}[${idx}]"
    inst_name="p${base}_${idx}"
    alias_name="${base}${idx}"
  else
    base="$port"
    sig="$port"
    inst_name="p${base}"
    count=${alias_count["$base"]:-0}
    count=$((count+1))
    alias_count["$base"]=$count
    alias_name="${base}${count}"
  fi

  if is_clock "$sig"; then
    inst_lines+=("  pc3c01 ${inst_name}(.CCLK(${sig}),.CP(${alias_name}));")
  else
    inst_lines+=("  pc3d01 ${inst_name}(.PAD(${sig}),.CIN(${alias_name}));")
  fi
done

# Insert inst_lines before final 'endmodule'
cp "$NETLIST" "$TMP"
end_ln=$(nl -ba "$TMP" | grep -nE '^[[:space:]]*[0-9]+[[:space:]]+endmodule' | tail -n1 | cut -d: -f1 || true)
if [ -z "$end_ln" ]; then
  echo "Cannot find 'endmodule' in $NETLIST"
  rm -f "$TMP"
  exit 1
fi

head -n $((end_ln-1)) "$TMP" > "$OUT"
{
  printf "\n  // --- Padframe instances inserted by script ---\n"
  for L in "${inst_lines[@]}"; do printf "%s\n" "$L"; done
  printf "\n"
} >> "$OUT"
tail -n +$((end_ln)) "$TMP" >> "$OUT"
rm -f "$TMP"

echo "Generated modified netlist: $OUT"
echo "Inputs parsed: ${#orig_inputs[@]}, Outputs parsed: ${#orig_outputs[@]}"
echo "Pad instances added: ${#inst_lines[@]}"

BASHPAD

chmod +x "$FLOOR_DIR/modified_netlist_generator.sh"

pushd "$FLOOR_DIR" >/dev/null
./modified_netlist_generator.sh source_netlist.v
popd >/dev/null


# ===================================================================
#                              PD TCL FILE       
# ===================================================================


cat > "$FLOOR_DIR/pd.tcl" <<TCLFP

# Netlist and Top Module
set init_verilog "./source_netlist_modified.v"
set init_top_cell "source"

# LEF Files
set init_lef_file [list \
    ${PDK_BASE}/stdlib/fs120/tech_data/lef/tsl180l4.lef \
    ${PDK_BASE}/stdlib/fs120/lef/tsl18fs120_scl.lef \
    ${PDK_BASE}/iolib/cio250/cds/lef/tsl18cio250_4lm.lef \
]

# Power Nets
set init_pwr_net {VDD VDDO}
set init_gnd_net {VSS VSSO}

# POINT TO THE MMMC FILE, Will be created
set init_mmmc_file "mmmc.tcl"

# init_design will now read the netlist, LEFs, AND source the mmmc.tcl file automatically
init_design

# Load IO Pins
loadIoFile ./padframe.io

# --- AUTOMATED WIDTH injection based on padframe ---
floorPlan -site CoreSite -noSnapToGrid -d ${WIDTH} ${WIDTH} 20 20 20 20

addIoFiller -cell pfeed10000 -prefix FILLER -side n
addIoFiller -cell pfeed10000 -prefix FILLER -side e
addIoFiller -cell pfeed10000 -prefix FILLER -side w
addIoFiller -cell pfeed10000 -prefix FILLER -side s

addIoFiller -cell pfeed01000 -prefix FILLER -side n
addIoFiller -cell pfeed01000 -prefix FILLER -side e
addIoFiller -cell pfeed01000 -prefix FILLER -side w
addIoFiller -cell pfeed01000 -prefix FILLER -side s

addIoFiller -cell pfeed00010 -prefix FILLER -side n
addIoFiller -cell pfeed00010 -prefix FILLER -side e
addIoFiller -cell pfeed00010 -prefix FILLER -side w
addIoFiller -cell pfeed00010 -prefix FILLER -side s

report_area -detail > area_floorplan.rpt

saveDesign source_floorplan.enc

#Powerplan

globalNetConnect VDD -type pgpin -pin VDD -override -verbose -netlistOverride
globalNetConnect VSS -type pgpin -pin VSS -override -verbose -netlistOverride
globalNetConnect VDDO -type pgpin -pin VDDO -override -verbose -netlistOverride
globalNetConnect VSSO -type pgpin -pin VSSO -override -verbose -netlistOverride


addRing -skip_via_on_wire_shape Noshape -exclude_selected 1 -skip_via_on_pin Standardcell -center 1 -stacked_via_top_layer TOP_M -type core_rings -jog_distance 0.56 -threshold 0.56 -nets {VDD VSS} -follow core -stacked_via_bottom_layer M1 -layer {bottom M3 top M3 right TOP_M left TOP_M} -width 6 -spacing 2 -offset 2

sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { M1 TOP_M } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange { M1 TOP_M } -nets { VDD VSS } -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { M1 TOP_M }

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit TOP_M -max_same_layer_jog_length 0.88 -padcore_ring_bottom_layer_limit M3 -set_to_set_distance 40 -skip_via_on_pin Standardcell -stacked_via_top_layer TOP_M -padcore_ring_top_layer_limit TOP_M -spacing 0.46 -xleft_offset 10 -merge_stripes_value 0.56 -layer TOP_M -block_ring_bottom_layer_limit M3 -width 2 -nets {VDD VSS} -stacked_via_bottom_layer M1

report_power > power_powerplan.rpt

saveDesign source_powerplan.enc

#Placement

setPlaceMode -fp false
placeDesign -noPrePlaceOpt

report_timing > timing_placement.rpt
saveNetlist ./source_netlist_placement.v

saveDesign source_placement.enc

#CTS

setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -preCTS
setCTSMode -engine ck
optDesign -postCTS


report_timing > timing_cts.rpt
report_clocks > clocks_cts.rpt
saveNetlist ./source_netlist_cts.v

saveDesign source_cts.enc

#Routing

routeDesign -globalDetail
setAnalysisMode -analysisType onChipVariation -cppr both
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postRoute
addFiller -cell feedth9 -prefix FILLER -doDRC
addFiller -cell feedth3 -prefix FILLER -doDRC
addFiller -cell feedth -prefix FILLER -doDRC

report_power > power_routing.rpt
report_timing > timing_routing.rpt
report_area > area_routing.rpt
saveNetlist ./source_netlist_routing.v

saveDesign source_routing.enc

streamOut source.gds -mapFile ${PDK_BASE}/stdlib/fs120/tech_data/lef/gds2_fe_4l.map -libName DesignLib -merge {${PDK_BASE}/stdlib/fs120/gds/tsl18fs120.gds ${PDK_BASE}/iolib/cio150/gds/tsl18cio150_4lm.gds} -uniquifyCellNames -units 1000 -mode ALL  

mkdir ../3_powerplan ../4_placement ../5_cts ../6_routing ../7_GDSII_import

mv source_powerplan.enc.dat ../3_powerplan/source_powerplan.enc.dat
mv source_powerplan.enc ../3_powerplan/source_powerplan.enc

mv power_powerplan.rpt ../3_powerplan/power_powerplan.rpt

mv source_placement.enc.dat ../4_placement/source_placement.enc.dat
mv source_placement.enc ../4_placement/source_placement.enc

mv timing_placement.rpt ../4_placement/timing_placement.rpt
mv source_netlist_placement.v ../4_placement/source_netlist_placement.v

mv source_cts.enc.dat ../5_cts/source_cts.enc.dat
mv source_cts.enc ../5_cts/source_cts.enc

mv timing_cts.rpt ../5_cts/timing_cts.rpt
mv clocks_cts.rpt ../5_cts/clocks_cts.rpt
mv source_netlist_cts.v ../5_cts/source_netlist_cts.v

mv source_routing.enc.dat ../6_routing/source_routing.enc.dat
mv source_routing.enc ../6_routing/source_routing.enc

mv power_routing.rpt ../6_routing/power_routing.rpt
mv timing_routing.rpt ../6_routing/timing_routing.rpt
mv area_routing.rpt ../6_routing/area_routing.rpt
mv source_netlist_routing.v ../6_routing/source_netlist_routing.v

mv source.gds ../7_GDSII_import/source.gds

rm padframe_generator.sh pd.tcl mmmc.tcl source.sdc source.v modified_netlist_generator.sh

exit
TCLFP


# ===================================================================
#                              MMMC TCL FILE     
# ===================================================================


cat > "$FLOOR_DIR/mmmc.tcl" <<TCLFP
# File: mmmc.tcl

# 1. Library Sets
create_library_set -name my_min_library_set -timing [list \
    ${PDK_BASE}/stdlib/fs120/liberty/lib_flow_ff/tsl18fs120_scl_ff.lib \
    ${PDK_BASE}/iolib/cio250/synopsys/2002.05/models/tsl18cio250_min.lib \
]

create_library_set -name my_max_library_set -timing [list \
    ${PDK_BASE}/stdlib/fs120/liberty/lib_flow_ss/tsl18fs120_scl_ss.lib \
    ${PDK_BASE}/iolib/cio250/synopsys/2002.05/models/tsl18cio250_max.lib \
]

create_library_set -name lib_180nm -timing [list \
    ${PDK_BASE}/stdlib/fs120/liberty/lib_flow_ss/tsl18fs120_scl_ss.lib \
    ${PDK_BASE}/iolib/cio250/synopsys/2002.05/models/tsl18cio250_typ.lib \
]

# 2. Constraint Modes
create_constraint_mode -name my_constraint_mode -sdc_files ./source.sdc

# 3. RC Corners
create_rc_corner -name my_rc_corner_worst -T 25

# 4. Delay Corners
create_delay_corner -name my_delay_corner_max -library_set my_max_library_set -rc_corner my_rc_corner_worst
create_delay_corner -name my_delay_corner_min -library_set my_min_library_set -rc_corner my_rc_corner_worst

# 5. Analysis Views
create_analysis_view -name my_analysis_view_setup -constraint_mode my_constraint_mode -delay_corner my_delay_corner_max
create_analysis_view -name my_analysis_view_hold  -constraint_mode my_constraint_mode -delay_corner my_delay_corner_min

# 6. Set Analysis View
set_analysis_view -setup {my_analysis_view_setup} -hold {my_analysis_view_hold}

TCLFP


# ===================================================================
#                              EXECUTE INNOVUS   
# ===================================================================


csh -c "cd $FLOOR_DIR; source \"$CADENCE_CSH\"; innovus -file ./pd.tcl;"

echo "=== FULL RTL TO GDS2 AUTOMATION COMPLETE ==="

