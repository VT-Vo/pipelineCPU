`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aidan Sheridan
// 
// Create Date: 10/01/2025 12:51:22 PM
// Design Name: 
// Module Name: PC
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


module PC(reset, PCwrite, mux, clk, PC);
    //input signals 
    input reset, PCwrite, clk;
    input [31:0] mux;
    //output signals
    output reg [31:0] PC;
    
    always @ (*)
    begin
        if (reset == 1'b1) PC = 0;
    end
    
    //Register model
    always @ (posedge clk)
    begin
        if (PCwrite == 1'b1) //synch load
            PC <= mux;
    end   
endmodule