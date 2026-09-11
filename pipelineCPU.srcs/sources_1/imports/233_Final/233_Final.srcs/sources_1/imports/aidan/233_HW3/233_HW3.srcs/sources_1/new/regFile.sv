`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aidan Sheridan
// 
// Create Date: 10/06/2025 05:48:14 PM
// Design Name: 
// Module Name: regFile
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


module regFile(clk,en,wa,wd,adr1,adr2,rs1,rs2);
    //inputs
    input clk, en;
    input [4:0] wa, adr1, adr2;
    input [31:0] wd;
    //outputs
    output [31:0] rs1,rs2;
    
    //Create array of registers
    logic [31:0] ram[0:31];
    
    //Initialize regs to 0
    initial begin
    for (int i=0;i<32;i++) begin
        ram[i]=0;
    end
    end
    
    //assign statements for asynch reads
    assign rs1 = ram[adr1];
    assign rs2 = ram[adr2];
    
    //synch write statements
    always_ff @(posedge clk)
    begin
        if ((en == 1)&&(wa != 0)) //synch enable & reg0 check
            ram[wa] <= wd;
    end
    
    
endmodule
