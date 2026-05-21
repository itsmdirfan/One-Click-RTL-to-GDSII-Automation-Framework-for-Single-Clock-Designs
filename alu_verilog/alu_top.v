// alu_top.v - top module: 8-bit ALU (adder + logic unit)
// Ports:
//   clk    : clock
//   a, b   : 8-bit operands
//   cin    : carry in (used in ADD mode)
//   opcode : 3-bit operation select
//             3'b000 = ADD
//             3'b001 = AND
//             3'b010 = OR
//             3'b011 = XOR
//             3'b100 = NOT a
//   result : 8-bit output
//   cout   : carry out (valid only in ADD mode)
//   zero   : asserted when result == 0

module alu_top (
    input        clk,
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    input  [2:0] opcode,
    output reg [7:0] result,
    output reg       cout,
    output           zero
);
    wire [7:0] add_sum;
    wire       add_cout;
    wire [7:0] logic_result;

    adder u_adder (
        .a   (a),
        .b   (b),
        .cin (cin),
        .sum (add_sum),
        .cout(add_cout)
    );

    logic_unit u_logic (
        .a     (a),
        .b     (b),
        .op    (opcode[1:0]),
        .result(logic_result)
    );

    always @(posedge clk) begin
        if (opcode == 3'b000) begin
            result <= add_sum;
            cout   <= add_cout;
        end else begin
            result <= logic_result;
            cout   <= 1'b0;
        end
    end

    assign zero = (result == 8'b0);

endmodule
