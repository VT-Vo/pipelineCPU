`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aidan Sheridan
// 
// Create Date: 10/19/2025 06:45:33 PM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(srcA,srcB,alu_fun,result);
    input logic [31:0] srcA,srcB;
    input logic [3:0] alu_fun;
    output logic [31:0] result;
    
    always_comb 
    begin
    case (alu_fun)
        //add
        4'b0000: result = $signed(srcA) + $signed(srcB);
        //sll
        4'b0001: result = srcA << srcB[4:0];
        //slt
        4'b0010: result = ($signed(srcA) < $signed(srcB)) ? 1:0;
        //sltu
        4'b0011: result = (srcA < srcB) ? 1:0;
        //xor
        4'b0100: result = srcA ^ srcB;
        //srl
        4'b0101: result = srcA >> srcB[4:0];
        //or
        4'b0110: result = srcA | srcB;
        //and
        4'b0111: result = srcA & srcB;
        //sub
        4'b1000: result = $signed(srcA) - $signed(srcB);
        //lui
        4'b1001: result = srcA;
        //sra
        4'b1101: result = $signed(srcA) >>> srcB[4:0];
        //error check
        default : result = 32'hDEAD_BEEF;
    endcase
    end
endmodule
