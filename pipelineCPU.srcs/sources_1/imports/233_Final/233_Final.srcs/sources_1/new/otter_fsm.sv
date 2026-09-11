`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aidan Sheridan
// 
// Create Date: 11/13/2025 10:43:01 AM
// Design Name: 
// Module Name: otter_fsm
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


module otter_fsm(opcode,rst,clk,intr,PCwrite,regWrite,memWE2,memRDEN1,memRDEN2,reset);
    input rst,clk;
    input [6:0] opcode;
    input intr;
    output logic reset,PCwrite,regWrite,memWE2,memRDEN1,memRDEN2;
    
    typedef enum {ST_INIT,ST_FETCH,ST_EXEC,ST_WRBACK} STATES;
    STATES NS,PS;
    
    //state regs
    always_ff @(posedge clk) begin
    if (rst)
        PS <= ST_INIT;
    else
        PS <= NS;
    end
    
    //fsm
    always_comb begin
    reset = 0;
    PCwrite = 0;
    regWrite = 0;
    memWE2 = 0;
    memRDEN1 = 0;
    memRDEN2 = 0;
    case (PS)
        ST_INIT : begin
            reset = 1; //pc out becomes 0
            NS = ST_FETCH;
        end
        ST_FETCH : begin
            memRDEN1 = 1; //instruction to be executed goes to DOUT1
            NS = ST_EXEC;
        end
        ST_EXEC : begin
            case (opcode) 
                //loads
                7'b0000011 : begin 
                memRDEN2 = 1;
                end
                //s-type
                7'b0100011 : begin 
                PCwrite = 1;
                memWE2 = 1;
                end
                //b-type
                7'b1100011 : begin
                PCwrite = 1;
                end
                default : begin
                PCwrite = 1;
                regWrite = 1;
                end
            endcase
            if (opcode == 7'b0000011)
                NS = ST_WRBACK;
            else
                NS = ST_FETCH;
        end
        ST_WRBACK : begin 
            PCwrite = 1;
            regWrite = 1;
            NS = ST_FETCH;
        end
        default : NS = ST_INIT;
    endcase
    end
    
endmodule 

