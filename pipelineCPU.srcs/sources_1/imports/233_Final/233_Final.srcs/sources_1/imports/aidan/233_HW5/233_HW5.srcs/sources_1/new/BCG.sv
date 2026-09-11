`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aidan Sheridan
// 
// Create Date: 10/25/2025 08:51:53 PM
// Design Name: 
// Module Name: BCG
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


module BCG(rs1,rs2,br_eq,br_lt,br_ltu);
    input [31:0] rs1,rs2;
    output br_eq,br_lt,br_ltu;
    
    //equal check
    assign br_eq = (rs1 == rs2) ? 1 : 0;
    //lt check signed
    assign br_lt = ($signed(rs1) < $signed(rs2)) ? 1 : 0;
    //lt check unsigned
    assign br_ltu = (rs1 < rs2) ? 1 : 0;
    
endmodule