//----------------------------------------------------------------------
//--SAYEH (Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
//Arithmetic Logic Unit (ALU)

`timescale 1 ns /1 ns

`define B15to0H 10'b1000000000
`define AandBH  10'b0100000000
`define AorBH   10'b0010000000
`define notBH   10'b0001000000
`define shlBH   10'b0000100000
`define shrBH   10'b0000010000
`define AaddBH  10'b0000001000
`define AsubBH  10'b0000000100
`define AmulBH  10'b0000000010
`define AcmpBH  10'b0000000001

module ArithmeticUnit (
	A, B, 
	B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,  
	aluout, cin,  cout, zout
);
input [15:0] A, B;
input B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB;
input cin;
output [15:0] aluout;
output cout,zout;
reg [15:0] aluout;
reg  cout,zout;

	always @(
		 A or B or B15to0 or AandB or AorB or notB or shlB or shrB or AaddB or AsubB  or AmulB  or AcmpB or cin
	) 
	begin
		cout = 0; aluout = 0;zout=0;
		case ({B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB})
			//code 
			`AcmpBH: begin
			    aluout = A;
				if (A> B) cout = 1; else cout = 0;
			end
			default: aluout = 0;
		endcase
		if (aluout == 0) zout = 1'b1;
    end
endmodule



 

   
  
  