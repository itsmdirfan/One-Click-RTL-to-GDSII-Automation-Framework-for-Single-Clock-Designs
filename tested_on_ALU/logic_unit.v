// logic_unit.v - bitwise logic operations
module logic_unit (
    input  [7:0] a,
    input  [7:0] b,
    input  [1:0] op,       // 00=AND 01=OR 10=XOR 11=NOT a
    output reg [7:0] result
);
    always @(*) begin
        case (op)
            2'b00: result = a & b;
            2'b01: result = a | b;
            2'b10: result = a ^ b;
            2'b11: result = ~a;
            default: result = 8'b0;
        endcase
    end
endmodule
