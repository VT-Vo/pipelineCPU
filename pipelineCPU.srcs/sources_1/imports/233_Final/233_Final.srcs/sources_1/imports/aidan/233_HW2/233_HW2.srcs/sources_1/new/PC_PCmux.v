`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aidan Sheridan
// 
// Create Date: 10/01/2025 01:11:03 PM
// Design Name: 
// Module Name: PC_PCmux
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


module PC_PCmux(pcSource,jalr,branch,jal,reset,PCwrite,clk,PCout);
    //inputs
    input reset, PCwrite, clk;
    input [31:0] jalr,branch,jal;
    input [1:0] pcSource;
    //outputs
    output [31:0] PCout;
    
    //Wire connecting mux output to data input of PC
    wire [31:0] muxOut, PCmux0;
    
    //Program Counter Instantiation
    PC myPC (
        .reset (reset),
        .PCwrite (PCwrite),
        .clk (clk),
        .mux (muxOut),
        .PC (PCout)     );
       
    //Mux instantiation 
    PCmux myMux (
        .sel (pcSource),
        .mux0 (PCout+4),
        .mux1 (jalr),
        .mux2 (branch),
        .mux3 (jal),
        .muxOut (muxOut)    );
        
endmodule
