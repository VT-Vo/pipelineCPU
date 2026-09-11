`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aidan Sheridan
// 
// Create Date: 11/13/2025 10:43:01 AM
// Design Name: 
// Module Name: otter_dcdr
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


module otter_dcdr(opcode,func3,ir30,br_eq,br_lt,br_ltu,alu_fun,alu_srcA,alu_srcB,pcSource,rf_wr_sel);
    input ir30, br_eq, br_lt, br_ltu;
    input [2:0] func3;
    input [6:0] opcode;
    output logic alu_srcA;
    output logic [1:0] alu_srcB, pcSource, rf_wr_sel;
    output logic [3:0] alu_fun;
    
    always_comb begin
    //set outputs to 0
    alu_srcA = 0;
    alu_srcB = 0;
    pcSource = 0;
    rf_wr_sel = 0;
    alu_fun = 0;
        case (opcode)
            //r-type
            7'b0110011 : begin 
            pcSource = 0;
            alu_srcA = 0;
            alu_srcB = 0;
            rf_wr_sel = 3;
            alu_fun = {ir30,func3};
            end
            //i-type but without loads and jalr
            7'b0010011 : begin
            pcSource = 0;
            alu_srcA = 0;
            alu_srcB = 1;
            rf_wr_sel = 3;
            if (func3 == 3'b101)
                alu_fun = {ir30,func3};
            else
                alu_fun = {1'b0,func3};  
            end  
            //jalr i-type
            7'b1100111 : begin
            pcSource = 1;
            rf_wr_sel = 0;
            end
            //loads (size and sign considered in mem module)
            7'b0000011 : begin 
            alu_fun = 4'b0000;
            alu_srcA = 0;
            alu_srcB = 1;
            pcSource = 0;
            rf_wr_sel = 2;
            end
            //lui
            7'b0110111 : begin
            pcSource = 0;
            alu_srcA = 1;
            rf_wr_sel = 3;
            alu_fun = 4'b1001;
            end
            //auipc
            7'b0010111 : begin
            alu_fun = 4'b0000;
            alu_srcA = 1;
            alu_srcB = 3;
            pcSource = 0;
            rf_wr_sel = 3; 
            end
            //jal
            7'b1101111 : begin
            pcSource = 3;
            rf_wr_sel = 0;
            end
            //b-type
            7'b1100011 : begin
            case (func3) 
                //beq and bne
                3'b000 : pcSource = {br_eq,1'b0};
                3'b001 : pcSource = {~br_eq,1'b0};
                //blt and bge
                3'b100 : pcSource = {br_lt,1'b0};
                3'b101 : pcSource = {~br_lt,1'b0};
                //bltu and bgeu
                3'b110 : pcSource = {br_ltu,1'b0};
                3'b111 : pcSource = {~br_ltu,1'b0};
                default : pcSource = 0;
            endcase 
            end
            //s-type
            7'b0100011 : begin
            alu_fun = 4'b0000;
            alu_srcA = 0;
            alu_srcB = 2;
            pcSource = 0;
            end
            default : begin
            pcSource = 0;
            rf_wr_sel = 0;
            alu_srcA = 0;
            alu_srcB = 0;
            alu_fun = 0;
            end
        endcase
    end
endmodule


