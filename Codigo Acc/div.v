`timescale 1ns / 1ps
module div(clk, sclk);

input wire clk;
output wire sclk;
    
parameter N=14;

reg [N-1:0] count=0;

assign sclk =count[N-1];


always @(posedge(clk)) 
count =count + 1;

endmodule
