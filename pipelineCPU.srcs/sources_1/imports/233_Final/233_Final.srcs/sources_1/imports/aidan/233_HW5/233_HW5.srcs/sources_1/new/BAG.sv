`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aidan Sheridan
// 
// Create Date: 10/25/2025 08:51:53 PM
// Design Name: 
// Module Name: BAG
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


module BAG(jtype,btype,itype,rs1,pc,jalr,branch,jal);
    input [31:0] jtype,btype,itype,rs1,pc;
    output [31:0] jalr,branch,jal;
    
    assign jal = pc + jtype;
    assign branch = pc + btype;
    assign jalr = rs1 + itype;
endmodule
