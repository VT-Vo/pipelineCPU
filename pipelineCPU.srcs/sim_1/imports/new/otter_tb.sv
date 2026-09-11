`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aidan Sheridan
// 
// Create Date: 11/14/2025 05:27:56 PM
// Design Name: 
// Module Name: otter_tb
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


module otter_tb();
    //dut inputs
    logic rst, clk, intr;
    logic [31:0] iobus_in;
    //dut outputs
    logic iobus_wr;
    logic [31:0] iobus_out, iobus_addr;
    
    //dut instantiation
    otter_cpu myCPU (
        .rst (rst),
        .intr (intr),
        .clk (clk),
        .iobus_in (iobus_in),
        .iobus_wr (iobus_wr),
        .iobus_out (iobus_out),
        .iobus_addr (iobus_addr)    );
        
    always begin
        #10 clk = ~clk;
    end
    
    always begin
        #60 rst = 0;
        iobus_in = 32'h2;
    end
    
    initial begin
        clk = 0;
    end
    
endmodule
