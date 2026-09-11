`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aidan Sheridan
// 
// Create Date: 10/15/2025 03:26:25 PM
// Design Name: 
// Module Name: Imm_Gen
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


module Imm_Gen(ir, jtype,btype,utype,itype,stype);
    input [24:0] ir;
    output [31:0] jtype,btype,utype,itype,stype;
    
    //j-type
    assign jtype = {{12{ir[24]}}, ir[12:5], ir[13], ir[23:14], 1'b0};
    //b-type
    assign btype = {{20{ir[24]}}, ir[0], ir[23:18], ir[4:1], 1'b0};
    //u-type
    assign utype = {ir[24:5], 12'b0};
    //i-type
    assign itype = {{21{ir[24]}}, ir[23:13]};
    //s-type
    assign stype = {{21{ir[24]}}, ir[23:18], ir[4:0]};
    
endmodule
