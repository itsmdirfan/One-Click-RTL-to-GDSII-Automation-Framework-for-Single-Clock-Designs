module source (
    input  wire        clk,     // single clock
    input  wire        rst_n,   // active-low synchronous reset
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    input  wire [2:0]  op,      // opcode
    output reg  [7:0]  result,  // registered result
    output reg         carry,   // carry/borrow for add/sub
    output reg         zero,    // result == 0
    output reg         sign,    // result[7]
    output reg         overflow // signed overflow
);

  // Opcode map:
  // 000 : ADD   -> result = A + B
  // 001 : SUB   -> result = A - B
  // 010 : AND
  // 011 : OR
  // 100 : XOR
  // 101 : SHL   -> logical left shift by 1 (B ignored)
  // 110 : SHR   -> logical right shift by 1 (B ignored)
  // 111 : PASSB -> result = B (simple move)

  reg [8:0] alu_ext;      // for add/sub carry/overflow detection
  reg [7:0] alu_out;
  reg       alu_carry;
  reg       alu_overflow;

  always @(*) begin
    // default vals
    alu_out      = 8'h00;
    alu_ext      = 9'h000;
    alu_carry    = 1'b0;
    alu_overflow = 1'b0;

    case (op)
      3'b000: begin // ADD
        alu_ext = {1'b0, A} + {1'b0, B}; // 9-bit for carry
        alu_out = alu_ext[7:0];
        alu_carry = alu_ext[8];
        // signed overflow: (A7 == B7) && (res7 != A7)
        alu_overflow = ((A[7] == B[7]) && (alu_out[7] != A[7]));
      end
      3'b001: begin // SUB (A - B)
        // compute as A + (~B + 1)
        alu_ext = {1'b0, A} + {1'b0, (~B)} + 9'h001;
        alu_out = alu_ext[7:0];
        // borrow flag: if A < B, then carry (9th bit) will be 0 -> we convert to borrow
        // Here we set carry = ~alu_ext[8] to indicate borrow (conventional interpretation)
        alu_carry = alu_ext[8]; // 1 means no borrow; user can interpret, we also show overflow
        alu_overflow = ((A[7] != B[7]) && (alu_out[7] != A[7])); // signed overflow for subtraction
      end
      3'b010: begin // AND
        alu_out = A & B;
      end
      3'b011: begin // OR
        alu_out = A | B;
      end
      3'b100: begin // XOR
        alu_out = A ^ B;
      end
      3'b101: begin // SHL (logical left by 1)
        alu_out = A << 1;
        alu_carry = A[7]; // MSB shifted out
      end
      3'b110: begin // SHR (logical right by 1)
        alu_out = A >> 1;
        alu_carry = A[0]; // LSB shifted out
      end
      3'b111: begin // PASSB
        alu_out = B;
      end
      default: begin
        alu_out = 8'h00;
      end
    endcase
  end

  // synchronous register stage
  always @(posedge clk) begin
    if (!rst_n) begin
      result   <= 8'h00;
      carry    <= 1'b0;
      zero     <= 1'b1;
      sign     <= 1'b0;
      overflow <= 1'b0;
    end else begin
      result   <= alu_out;
      carry    <= alu_carry;
      zero     <= (alu_out == 8'h00);
      sign     <= alu_out[7];
      overflow <= alu_overflow;
    end
  end

endmodule

