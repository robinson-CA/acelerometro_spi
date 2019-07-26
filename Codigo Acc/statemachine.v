`timescale 1ns / 1ps
module statemachine(sclk,Dout,MISO,MOSI,cs,n,i);

input MISO;
input sclk;
input [5:0] n;
reg [5:0] ni=0;


output reg [7:0] Dout;
output reg MOSI=1;
output reg cs=1;

wire [23:0] shift;
reg [1:0] sti;
output reg i=0;

wire [7:0] instruction;
reg [7:0] shift_mi=0;
reg [15:0] shift_mo=0;
reg [2:0] st=0;

parameter MO=1;
parameter final=2;

parameter Din_charge=1;
parameter MO_sh=2;
parameter MI_sh=3;
parameter MI_init=4;
parameter Dout_charge=5;

assign instruction=8'b00001011;


assign shift [23:16] = 8'b00001010; //instruction
assign shift [15:8] = 8'b00101101; //add
assign shift[7:0] =8'b00000010;   //control

always @(negedge sclk)
begin
if(i==1)
begin
case(st)
Din_charge:
begin
shift_mo[15:8]<=instruction;
shift_mo[7:0]<=8'b00001111;
end

MO_sh: 
   begin //mosi
	 cs<=0;
    MOSI<=shift_mo[18-n];
	end
	
MI_sh: MOSI<=1;

Dout_charge: 
   begin //carga de dato de salida
    Dout<=shift_mi;
    cs<=1;
	end
	
	endcase
	end
else 
 begin
  case(sti)
  MO: begin
  cs<=0;
  MOSI<=shift[25-ni];
  end
  
  final:begin
  cs<=1;  
  i<=1;
  MOSI<=1;
 end
  endcase
 end
end

always @(posedge sclk)
begin

case(st)
MI_sh:
   begin
	 shift_mi[26-n]<=MISO;
	end
endcase	
end

always@(negedge sclk)
begin
case(n)
1: st<=Din_charge;
2: st<=MO_sh;
18: st<=MI_sh;
26:st<=Dout_charge;
endcase
end

always@(posedge sclk) 
if (i==0) ni=ni+1;
else ni=0;

always@(negedge sclk)
begin
case(ni)
1: sti<=MO;
25: sti<=final;
endcase
end

endmodule
