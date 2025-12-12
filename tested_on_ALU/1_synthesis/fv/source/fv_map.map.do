
//input ports
add mapped point clk clk -type PI PI
add mapped point rst_n rst_n -type PI PI
add mapped point A[7] A[7] -type PI PI
add mapped point A[6] A[6] -type PI PI
add mapped point A[5] A[5] -type PI PI
add mapped point A[4] A[4] -type PI PI
add mapped point A[3] A[3] -type PI PI
add mapped point A[2] A[2] -type PI PI
add mapped point A[1] A[1] -type PI PI
add mapped point A[0] A[0] -type PI PI
add mapped point B[7] B[7] -type PI PI
add mapped point B[6] B[6] -type PI PI
add mapped point B[5] B[5] -type PI PI
add mapped point B[4] B[4] -type PI PI
add mapped point B[3] B[3] -type PI PI
add mapped point B[2] B[2] -type PI PI
add mapped point B[1] B[1] -type PI PI
add mapped point B[0] B[0] -type PI PI
add mapped point op[2] op[2] -type PI PI
add mapped point op[1] op[1] -type PI PI
add mapped point op[0] op[0] -type PI PI

//output ports
add mapped point result[7] result[7] -type PO PO
add mapped point result[6] result[6] -type PO PO
add mapped point result[5] result[5] -type PO PO
add mapped point result[4] result[4] -type PO PO
add mapped point result[3] result[3] -type PO PO
add mapped point result[2] result[2] -type PO PO
add mapped point result[1] result[1] -type PO PO
add mapped point result[0] result[0] -type PO PO
add mapped point carry carry -type PO PO
add mapped point zero zero -type PO PO
add mapped point sign sign -type PO PO
add mapped point overflow overflow -type PO PO

//inout ports




//Sequential Pins
add mapped point zero/q zero_reg/Q -type DFF DFF
add mapped point result[7]/q result_reg[7]/Q -type DFF DFF
add mapped point overflow/q overflow_reg/Q -type DFF DFF
add mapped point result[6]/q result_reg[6]/Q -type DFF DFF
add mapped point carry/q carry_reg/Q -type DFF DFF
add mapped point result[5]/q result_reg[5]/Q -type DFF DFF
add mapped point result[4]/q result_reg[4]/Q -type DFF DFF
add mapped point result[3]/q result_reg[3]/Q -type DFF DFF
add mapped point result[1]/q result_reg[1]/Q -type DFF DFF
add mapped point result[2]/q result_reg[2]/Q -type DFF DFF
add mapped point result[0]/q result_reg[0]/Q -type DFF DFF



//Black Boxes



//Empty Modules as Blackboxes
