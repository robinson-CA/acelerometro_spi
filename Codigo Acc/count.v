`timescale 1ns / 1ps
module count(sclk,n,i);

input sclk;
input i;
output reg [5:0] n=0;

always@(posedge sclk)
case(n)
26: n=0;
default: if(i==1) n=n+1;
endcase

endmodule
