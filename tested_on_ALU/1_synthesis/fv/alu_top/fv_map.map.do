
//input ports
add mapped point clk clk -type PI PI
add mapped point a[7] a[7] -type PI PI
add mapped point a[6] a[6] -type PI PI
add mapped point a[5] a[5] -type PI PI
add mapped point a[4] a[4] -type PI PI
add mapped point a[3] a[3] -type PI PI
add mapped point a[2] a[2] -type PI PI
add mapped point a[1] a[1] -type PI PI
add mapped point a[0] a[0] -type PI PI
add mapped point b[7] b[7] -type PI PI
add mapped point b[6] b[6] -type PI PI
add mapped point b[5] b[5] -type PI PI
add mapped point b[4] b[4] -type PI PI
add mapped point b[3] b[3] -type PI PI
add mapped point b[2] b[2] -type PI PI
add mapped point b[1] b[1] -type PI PI
add mapped point b[0] b[0] -type PI PI
add mapped point cin cin -type PI PI
add mapped point opcode[2] opcode[2] -type PI PI
add mapped point opcode[1] opcode[1] -type PI PI
add mapped point opcode[0] opcode[0] -type PI PI

//output ports
add mapped point result[7] result[7] -type PO PO
add mapped point result[6] result[6] -type PO PO
add mapped point result[5] result[5] -type PO PO
add mapped point result[4] result[4] -type PO PO
add mapped point result[3] result[3] -type PO PO
add mapped point result[2] result[2] -type PO PO
add mapped point result[1] result[1] -type PO PO
add mapped point result[0] result[0] -type PO PO
add mapped point cout cout -type PO PO
add mapped point zero zero -type PO PO

//inout ports




//Sequential Pins
add mapped point result[7]/q result_reg[7]/Q -type DFF DFF
add mapped point cout/q cout_reg/Q -type DFF DFF
add mapped point result[6]/q result_reg[6]/Q -type DFF DFF
add mapped point result[5]/q result_reg[5]/Q -type DFF DFF
add mapped point result[4]/q result_reg[4]/Q -type DFF DFF
add mapped point result[3]/q result_reg[3]/Q -type DFF DFF
add mapped point result[2]/q result_reg[2]/Q -type DFF DFF
add mapped point result[1]/q result_reg[1]/Q -type DFF DFF
add mapped point result[0]/q result_reg[0]/Q -type DFF DFF



//Black Boxes



//Empty Modules as Blackboxes
