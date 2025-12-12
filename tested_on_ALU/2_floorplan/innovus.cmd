#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Fri Dec 12 16:00:14 2025                
#                                                     
#######################################################

#@(#)CDS: Innovus v21.15-s110_1 (64bit) 09/23/2022 13:08 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 21.15-s110_1 NR220912-2004/21_15-UB (database version 18.20.592) {superthreading v2.17}
#@(#)CDS: AAE 21.15-s039 (64bit) 09/23/2022 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 21.15-s038_1 () Sep 20 2022 11:42:13 ( )
#@(#)CDS: SYNTECH 21.15-s012_1 () Sep  5 2022 10:25:51 ( )
#@(#)CDS: CPE v21.15-s076
#@(#)CDS: IQuantus/TQuantus 21.1.1-s867 (64bit) Sun Jun 26 22:12:54 PDT 2022 (Linux 3.10.0-693.el7.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getVersion
set init_verilog ./source_netlist_modified.v
set init_top_cell source
set init_lef_file {/home/vlsi12/Downloads/scl_pdk/stdlib/fs120/tech_data/lef/tsl180l4.lef /home/vlsi12/Downloads/scl_pdk/stdlib/fs120/lef/tsl18fs120_scl.lef /home/vlsi12/Downloads/scl_pdk/iolib/cio250/cds/lef/tsl18cio250_4lm.lef}
set init_pwr_net {VDD VDDO}
set init_gnd_net {VSS VSSO}
set init_mmmc_file mmmc.tcl
init_design
loadIoFile ./padframe.io
floorPlan -site CoreSite -noSnapToGrid -d 1410 1410 20 20 20 20
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
globalNetConnect VDD -type pgpin -pin VDD -override -verbose -netlistOverride
globalNetConnect VSS -type pgpin -pin VSS -override -verbose -netlistOverride
globalNetConnect VDDO -type pgpin -pin VDDO -override -verbose -netlistOverride
globalNetConnect VSSO -type pgpin -pin VSSO -override -verbose -netlistOverride
addRing -skip_via_on_wire_shape Noshape -exclude_selected 1 -skip_via_on_pin Standardcell -center 1 -stacked_via_top_layer TOP_M -type core_rings -jog_distance 0.56 -threshold 0.56 -nets {VDD VSS} -follow core -stacked_via_bottom_layer M1 -layer {bottom M3 top M3 right TOP_M left TOP_M} -width 6 -spacing 2 -offset 2
sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { M1 TOP_M } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange { M1 TOP_M } -nets { VDD VSS } -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { M1 TOP_M }
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit TOP_M -max_same_layer_jog_length 0.88 -padcore_ring_bottom_layer_limit M3 -set_to_set_distance 40 -skip_via_on_pin Standardcell -stacked_via_top_layer TOP_M -padcore_ring_top_layer_limit TOP_M -spacing 0.46 -xleft_offset 10 -merge_stripes_value 0.56 -layer TOP_M -block_ring_bottom_layer_limit M3 -width 2 -nets {VDD VSS} -stacked_via_bottom_layer M1
report_power > power_powerplan.rpt
saveDesign source_powerplan.enc
setPlaceMode -fp false
getPlaceMode -place_hierarchical_flow -quiet
report_message -start_cmd
getRouteMode -maxRouteLayer -quiet
getRouteMode -user -maxRouteLayer
getPlaceMode -place_global_place_io_pins -quiet
getPlaceMode -user -maxRouteLayer
getPlaceMode -quiet -adaptiveFlowMode
getPlaceMode -timingDriven -quiet
getPlaceMode -adaptive -quiet
getPlaceMode -relaxSoftBlockageMode -quiet
getPlaceMode -user -relaxSoftBlockageMode
getPlaceMode -ignoreScan -quiet
getPlaceMode -user -ignoreScan
getPlaceMode -repairPlace -quiet
getPlaceMode -user -repairPlace
getPlaceMode -inPlaceOptMode -quiet
getPlaceMode -quiet -bypassFlowEffortHighChecking
getDesignMode -quiet -siPrevention
getPlaceMode -quiet -place_global_exp_enable_3d
getPlaceMode -exp_slack_driven -quiet
um::push_snapshot_stack
getDesignMode -quiet -flowEffort
getDesignMode -highSpeedCore -quiet
getPlaceMode -quiet -adaptive
set spgFlowInInitialPlace 1
getPlaceMode -sdpAlignment -quiet
getPlaceMode -softGuide -quiet
getPlaceMode -useSdpGroup -quiet
getPlaceMode -sdpAlignment -quiet
getPlaceMode -enableDbSaveAreaPadding -quiet
getPlaceMode -quiet -wireLenOptEffort
getPlaceMode -sdpPlace -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -sdpPlace -quiet
getPlaceMode -groupHighLevelClkGate -quiet
setvar spgRptErrorForScanConnection 0
getPlaceMode -place_global_exp_allow_missing_scan_chain -quiet
getPlaceMode -place_check_library -quiet
getPlaceMode -trimView -quiet
getPlaceMode -expTrimOptBeforeTDGP -quiet
getPlaceMode -quiet -useNonTimingDeleteBufferTree
getPlaceMode -congEffort -quiet
getPlaceMode -relaxSoftBlockageMode -quiet
getPlaceMode -user -relaxSoftBlockageMode
getPlaceMode -ignoreScan -quiet
getPlaceMode -user -ignoreScan
getPlaceMode -repairPlace -quiet
getPlaceMode -user -repairPlace
getPlaceMode -congEffort -quiet
getPlaceMode -fp -quiet
getPlaceMode -timingDriven -quiet
getPlaceMode -user -timingDriven
getPlaceMode -fastFp -quiet
getPlaceMode -clusterMode -quiet
get_proto_model -type_match {flex_module flex_instgroup} -committed -name -tcl
getPlaceMode -inPlaceOptMode -quiet
getPlaceMode -quiet -bypassFlowEffortHighChecking
getPlaceMode -ultraCongEffortFlow -quiet
getPlaceMode -forceTiming -quiet
getPlaceMode -fp -quiet
getPlaceMode -fastfp -quiet
getPlaceMode -timingDriven -quiet
getPlaceMode -fp -quiet
getPlaceMode -fastfp -quiet
getPlaceMode -powerDriven -quiet
getExtractRCMode -quiet -engine
getAnalysisMode -quiet -clkSrcPath
getAnalysisMode -quiet -clockPropagation
getAnalysisMode -quiet -cppr
setExtractRCMode -engine preRoute
setAnalysisMode -clkSrcPath false -clockPropagation forcedIdeal
getPlaceMode -exp_slack_driven -quiet
isAnalysisModeSetup
getPlaceMode -quiet -place_global_exp_solve_unbalance_path
getPlaceMode -quiet -NMPsuppressInfo
getPlaceMode -quiet -place_global_exp_wns_focus_v2
getPlaceMode -quiet -place_incr_exp_isolation_flow
getPlaceMode -enableDistPlace -quiet
getPlaceMode -quiet -clusterMode
getPlaceMode -wl_budget_mode -quiet
setPlaceMode -reset -place_global_exp_balance_buffer_chain
getPlaceMode -wl_budget_mode -quiet
setPlaceMode -reset -place_global_exp_balance_pipeline
getPlaceMode -place_global_exp_balance_buffer_chain -quiet
getPlaceMode -place_global_exp_balance_pipeline -quiet
getPlaceMode -tdgpMemFlow -quiet
getPlaceMode -user -resetCombineRFLevel
getPlaceMode -quiet -resetCombineRFLevel
setPlaceMode -resetCombineRFLevel 1000
setvar spgSpeedupBuildVSM 1
getPlaceMode -tdgpResetCteTG -quiet
getPlaceMode -macroPlaceMode -quiet
getPlaceMode -place_global_replace_QP -quiet
getPlaceMode -macroPlaceMode -quiet
getPlaceMode -enableDistPlace -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -place_global_ignore_spare -quiet
getPlaceMode -enableDistPlace -quiet
getPlaceMode -quiet -expNewFastMode
setPlaceMode -expHiddenFastMode 1
setPlaceMode -reset -ignoreScan
getPlaceMode -quiet -place_global_exp_auto_finish_floorplan
colorizeGeometry
getPlaceMode -quiet -IOSlackAdjust
getAnalysisMode -quiet -honorClockDomains
getPlaceMode -honorUserPathGroup -quiet
getAnalysisMode -quiet -honorClockDomains
set delaycal_use_default_delay_limit 101
set delaycal_default_net_delay 0
set delaycal_default_net_load 0
set delaycal_default_net_load_ignore_for_ilm 0
set delaycal_input_transition_delay 1ps
getAnalysisMode -clkSrcPath -quiet
getAnalysisMode -clockPropagation -quiet
getAnalysisMode -checkType -quiet
buildTimingGraph
getDelayCalMode -ignoreNetLoad -quiet
getDelayCalMode -ignoreNetLoad -quiet
setDelayCalMode -ignoreNetLoad true -quiet
get_global timing_enable_path_group_priority
get_global timing_constraint_enable_group_path_resetting
set_global timing_enable_path_group_priority false
set_global timing_constraint_enable_group_path_resetting false
getOptMode -allowPreCTSClkSrcPaths -quiet
set_global _is_ipo_interactive_path_groups 1
group_path -name in2reg_tmp.303793 -from {0x682 0x685} -to 0x686 -ignore_source_of_trigger_arc
getOptMode -allowPreCTSClkSrcPaths -quiet
set_global _is_ipo_interactive_path_groups 1
group_path -name in2out_tmp.303793 -from {0x689 0x68c} -to 0x68d -ignore_source_of_trigger_arc
set_global _is_ipo_interactive_path_groups 1
group_path -name reg2reg_tmp.303793 -from 0x68f -to 0x690
set_global _is_ipo_interactive_path_groups 1
group_path -name reg2out_tmp.303793 -from 0x693 -to 0x694
setPathGroupOptions reg2reg_tmp.303793 -effortLevel high
reset_path_group -name in2reg_tmp.303793
set_global _is_ipo_interactive_path_groups 0
reset_path_group -name in2out_tmp.303793
set_global _is_ipo_interactive_path_groups 0
setDelayCalMode -ignoreNetLoad false
set delaycal_use_default_delay_limit 1000
set delaycal_default_net_delay 1000ps
set delaycal_input_transition_delay 0ps
set delaycal_default_net_load 0.5pf
set delaycal_default_net_load_ignore_for_ilm 0
all_setup_analysis_views
getPlaceMode -place_global_exp_ignore_low_effort_path_groups -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -ignoreUnproperPowerInit -quiet
getPlaceMode -quiet -expSkipGP
setDelayCalMode -engine feDc
psp::embedded_egr_init_
psp::embedded_egr_term_
psp::embedded_egr_init_
psp::embedded_egr_term_
psp::embedded_egr_init_
psp::embedded_egr_term_
scanReorder
setDelayCalMode -engine aae
all_setup_analysis_views
getPlaceMode -exp_slack_driven -quiet
reset_path_group -name reg2reg_tmp.303793
set_global _is_ipo_interactive_path_groups 0
reset_path_group -name reg2out_tmp.303793
set_global _is_ipo_interactive_path_groups 0
set_global timing_enable_path_group_priority $gpsPrivate::optSave_ctePGPriority
set_global timing_constraint_enable_group_path_resetting $gpsPrivate::optSave_ctePGResetting
getPlaceMode -quiet -tdgpAdjustNetWeightBySlack
get_ccopt_clock_trees *
getPlaceMode -exp_insert_guidance_clock_tree -quiet
getPlaceMode -exp_cluster_based_high_fanout_buffering -quiet
getPlaceMode -place_global_exp_incr_skp_preserve_mode_v2 -quiet
getPlaceMode -quiet -place_global_exp_netlist_balance_flow
getPlaceMode -quiet -timingEffort
getAnalysisMode -quiet -honorClockDomains
getPlaceMode -honorUserPathGroup -quiet
getAnalysisMode -quiet -honorClockDomains
set delaycal_use_default_delay_limit 101
set delaycal_default_net_delay 0
set delaycal_default_net_load 0
set delaycal_default_net_load_ignore_for_ilm 0
getAnalysisMode -clkSrcPath -quiet
getAnalysisMode -clockPropagation -quiet
getAnalysisMode -checkType -quiet
buildTimingGraph
getDelayCalMode -ignoreNetLoad -quiet
getDelayCalMode -ignoreNetLoad -quiet
setDelayCalMode -ignoreNetLoad true -quiet
get_global timing_enable_path_group_priority
get_global timing_constraint_enable_group_path_resetting
set_global timing_enable_path_group_priority false
set_global timing_constraint_enable_group_path_resetting false
getOptMode -allowPreCTSClkSrcPaths -quiet
set_global _is_ipo_interactive_path_groups 1
group_path -name in2reg_tmp.303793 -from {0x698 0x69b} -to 0x69c -ignore_source_of_trigger_arc
getOptMode -allowPreCTSClkSrcPaths -quiet
set_global _is_ipo_interactive_path_groups 1
group_path -name in2out_tmp.303793 -from {0x69f 0x6a2} -to 0x6a3 -ignore_source_of_trigger_arc
set_global _is_ipo_interactive_path_groups 1
group_path -name reg2reg_tmp.303793 -from 0x6a5 -to 0x6a6
set_global _is_ipo_interactive_path_groups 1
group_path -name reg2out_tmp.303793 -from 0x6a9 -to 0x6aa
setPathGroupOptions reg2reg_tmp.303793 -effortLevel high
reset_path_group -name in2reg_tmp.303793
set_global _is_ipo_interactive_path_groups 0
reset_path_group -name in2out_tmp.303793
set_global _is_ipo_interactive_path_groups 0
setDelayCalMode -ignoreNetLoad false
set delaycal_use_default_delay_limit 1000
set delaycal_default_net_delay 1000ps
set delaycal_default_net_load 0.5pf
set delaycal_default_net_load_ignore_for_ilm 0
all_setup_analysis_views
getPlaceMode -place_global_exp_ignore_low_effort_path_groups -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -quiet -cong_repair_commit_clock_net_route_attr
getPlaceMode -enableDbSaveAreaPadding -quiet
getPlaceMode -quiet -wireLenOptEffort
setPlaceMode -reset -improveWithPsp
getPlaceMode -quiet -debugGlobalPlace
getPlaceMode -congRepair -quiet
getPlaceMode -fp -quiet
getPlaceMode -user -rplaceIncrNPClkGateAwareMode
getPlaceMode -user -congRepairMaxIter
getPlaceMode -quiet -congRepairPDClkGateMode4
setPlaceMode -rplaceIncrNPClkGateAwareMode 4
getPlaceMode -quiet -expCongRepairPDOneLoop
setPlaceMode -congRepairMaxIter 1
getPlaceMode -quickCTS -quiet
get_proto_model -type_match {flex_module flex_instgroup} -committed -name -tcl
getPlaceMode -congRepairForceTrialRoute -quiet
getPlaceMode -user -congRepairForceTrialRoute
setPlaceMode -congRepairForceTrialRoute true
::goMC::is_advanced_metrics_collection_running
congRepair
::goMC::is_advanced_metrics_collection_running
::goMC::is_advanced_metrics_collection_running
::goMC::is_advanced_metrics_collection_running
setPlaceMode -reset -congRepairForceTrialRoute
getPlaceMode -quiet -congRepairPDClkGateMode4
setPlaceMode -reset -rplaceIncrNPClkGateAwareMode
setPlaceMode -reset -congRepairMaxIter
getPlaceMode -congRepairCleanupPadding -quiet
getPlaceMode -quiet -wireLenOptEffort
all_setup_analysis_views
getPlaceMode -exp_slack_driven -quiet
reset_path_group -name reg2reg_tmp.303793
set_global _is_ipo_interactive_path_groups 0
reset_path_group -name reg2out_tmp.303793
set_global _is_ipo_interactive_path_groups 0
set_global timing_enable_path_group_priority $gpsPrivate::optSave_ctePGPriority
set_global timing_constraint_enable_group_path_resetting $gpsPrivate::optSave_ctePGResetting
getPlaceMode -place_global_exp_incr_skp_preserve_mode_v2 -quiet
getPlaceMode -quiet -place_global_exp_netlist_balance_flow
getPlaceMode -quiet -timingEffort
getPlaceMode -tdgpDumpStageTiming -quiet
getPlaceMode -quiet -tdgpAdjustNetWeightBySlack
getPlaceMode -trimView -quiet
getOptMode -quiet -viewOptPolishing
getOptMode -quiet -fastViewOpt
spInternalUse deleteViewOptManager
spInternalUse tdgp clearSkpData
setAnalysisMode -clkSrcPath true -clockPropagation sdcControl
getPlaceMode -exp_slack_driven -quiet
setExtractRCMode -engine preRoute
setPlaceMode -reset -relaxSoftBlockageMode
setPlaceMode -reset -ignoreScan
setPlaceMode -reset -repairPlace
getPlaceMode -quiet -NMPsuppressInfo
setvar spgSpeedupBuildVSM 0
getPlaceMode -macroPlaceMode -quiet
getPlaceMode -place_global_replace_QP -quiet
getPlaceMode -macroPlaceMode -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -enableDistPlace -quiet
getPlaceMode -place_global_ignore_spare -quiet
getPlaceMode -tdgpMemFlow -quiet
setPlaceMode -reset -resetCombineRFLevel
getPlaceMode -enableDistPlace -quiet
getPlaceMode -quiet -clusterMode
getPlaceMode -quiet -place_global_exp_solve_unbalance_path
getPlaceMode -enableDistPlace -quiet
setPlaceMode -reset -expHiddenFastMode
getPlaceMode -tcg2Pass -quiet
getPlaceMode -quiet -wireLenOptEffort
getPlaceMode -fp -quiet
getPlaceMode -fastfp -quiet
getPlaceMode -doRPlace -quiet
getPlaceMode -RTCPlaceDesignFlow -quiet
getPlaceMode -quickCTS -quiet
set spgFlowInInitialPlace 0
getPlaceMode -user -maxRouteLayer
spInternalUse TDGP resetIgnoreNetLoad
getPlaceMode -place_global_exp_balance_pipeline -quiet
getDesignMode -quiet -flowEffort
report_message -end_cmd
um::create_snapshot -name final -auto min
um::pop_snapshot_stack
um::create_snapshot -name place_design
getPlaceMode -exp_slack_driven -quiet
report_timing > timing_placement.rpt
saveNetlist ./source_netlist_placement.v
saveDesign source_placement.enc
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -preCTS
optDesign -postCTS
report_timing > timing_cts.rpt
report_clocks > clocks_cts.rpt
saveNetlist ./source_netlist_cts.v
saveDesign source_cts.enc
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
streamOut source.gds -mapFile /home/vlsi12/Downloads/scl_pdk/stdlib/fs120/tech_data/lef/gds2_fe_4l.map -libName DesignLib -merge {/home/vlsi12/Downloads/scl_pdk/stdlib/fs120/gds/tsl18fs120.gds /home/vlsi12/Downloads/scl_pdk/iolib/cio150/gds/tsl18cio150_4lm.gds} -uniquifyCellNames -units 1000 -mode ALL
