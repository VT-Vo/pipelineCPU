`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aidan Sheridan
// 
// Create Date: 10/01/2025 12:51:22 PM
// Design Name: 
// Module Name: PCmux
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


module PCmux(sel, mux0,mux1,mux2,mux3,muxOut);
    //input signals
    input [1:0] sel;
    input [31:0] mux0,mux1,mux2,mux3;
    //output signals
    output reg [31:0] muxOut;
    
    //mux behavior
    always @ (*)
    begin
        case (sel)
            0 : muxOut = mux0;
            1 : muxOut = mux1;
            2 : muxOut = mux2;
            3 : muxOut = mux3;
        default : muxOut = mux0;
        endcase
    end
    
endmodule
