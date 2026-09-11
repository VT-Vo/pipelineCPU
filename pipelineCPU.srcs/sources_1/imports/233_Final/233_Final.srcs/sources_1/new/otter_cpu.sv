`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aidan Sheridan
// 
// Create Date: 11/13/2025 10:43:01 AM
// Design Name: 
// Module Name: otter_cpu
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

module otter_cpu(rst,intr,iobus_in,clk,iobus_wr,iobus_out,iobus_addr);
    //IO
    input rst,intr,clk;
    input [31:0] iobus_in;
    output iobus_wr;
    output [31:0] iobus_out,iobus_addr;
    
    //internal signals
    logic [31:0] pc_out,ir,jtype,btype,utype,itype,stype;
    logic memRDEN1,memRDEN2,memWE2,reset,PCwrite,regWrite;
    logic br_eq,br_lt,br_ltu,alu_srcA;
    logic [1:0] alu_srcB, pcSource,rf_wr_sel;
    logic [3:0] alu_fun;
    logic [31:0] jalr,branch,jal,rs1,rs2,regmuxout,dout2;
    logic [31:0] alu_result,amuxout,bmuxout;
    
    //cpu output assigns
    assign iobus_addr = alu_result;
    assign iobus_out = rs2;
    
    typedef struct packed {
       logic [31:0] instruction;
       logic [31:0] PC;
       logic [31:0] PC_PLUS4;
    } pipe_reg;
    
    pipe_reg IF_DEV_reg;
    pipe_reg DEC_EXE_reg;
    
    always_ff @ (posedge clk) begin
        IF_DEV_reg.instruction <= ir;
        IF_DEV_reg.PC <= pc_out;
        IF_DEV_reg.PC_PLUS4 <= pc_out + 4;
    end
    
    always_ff @ (posedge clk) begin
        DEC_EXE_reg <= IF_DEV_reg;
    end
    
    ProgRom myProgRom(
        .PROG_CLK(clk),
        .PROG_ADDR(pc_out),
        .INSTRUCT(ir)
    );
    
    //FSM module
    otter_fsm myFSM (
        .rst (rst),
        .clk (clk),
        .intr (intr),
        .opcode (ir[6:0]),
        .reset (reset),
        .PCwrite (PCwrite),
        .regWrite (regWrite),
        .memWE2 (memWE2),
        .memRDEN1 (memRDEN1),
        .memRDEN2 (memRDEN2)    );
    
    //Decoder module
    otter_dcdr myDCDR (
        .ir30 (ir[30]),
        .br_eq (br_eq),
        .br_lt (br_lt),
        .br_ltu (br_ltu),
        .func3 (ir[14:12]),
        .opcode (ir[6:0]),
        .alu_srcA (alu_srcA),
        .alu_srcB (alu_srcB),
        .pcSource (pcSource),
        .rf_wr_sel (rf_wr_sel),
        .alu_fun (alu_fun)  );
    
    //memory module
    Memory my_memory (
        .MEM_CLK (clk),
        .MEM_RDEN1 (memRDEN1),
        .MEM_RDEN2 (memRDEN2),
        .MEM_WE2 (memWE2),
        .MEM_ADDR1 (pc_out[15:2]),
        .MEM_ADDR2 (alu_result),
        .MEM_DIN2 (rs2),
        .MEM_SIZE (ir[13:12]),
        .MEM_SIGN (ir[14]),
        .IO_IN (iobus_in),
        .IO_WR (iobus_wr),
        .MEM_DOUT1 (ir),
        .MEM_DOUT2 (dout2)  );
    
    //PC and PC mux module
    PC_PCmux myPC (
        .reset (reset),
        .PCwrite (PCwrite),
        .clk (clk),
        .jalr (jalr),
        .branch (branch),
        .jal (jal),
        .pcSource (pcSource),
        .PCout (pc_out) );
    
    //Branch address generator module
    BAG myBag (
        .jtype (jtype),
        .btype (btype),
        .itype (itype),
        .rs1 (rs1),
        .pc (pc_out),
        .jalr (jalr),
        .branch (branch),
        .jal (jal)  );
        
    //Branch condition generator module
    BCG myBcg (
        .rs1 (rs1),
        .rs2 (rs2),
        .br_eq (br_eq),
        .br_lt (br_lt),
        .br_ltu (br_ltu)    );
    
    //Immediate generator module  
    Imm_Gen myImmGen (
        .ir (ir[31:7]),
        .jtype (jtype),
        .btype (btype),
        .utype (utype),
        .itype (itype),
        .stype (stype)  );
        
    //Register file module
    regFile myRegFile (
        .clk (clk),
        .en (regWrite),
        .wa (ir[11:7]),
        .adr1 (ir[19:15]),
        .adr2 (ir[24:20]),
        .wd (regmuxout),
        .rs1 (rs1),
        .rs2 (rs2)  );
    
    //Reg file mux
    always_comb begin
        case (rf_wr_sel)
            2'b00 : regmuxout = pc_out + 4;
            2'b01 : regmuxout = 32'd0;
            2'b10 : regmuxout = dout2;
            2'b11 : regmuxout = alu_result;
            default : regmuxout = 32'd0;
        endcase
    end
    
    //ALU module
    alu myALU (
        .srcA (amuxout),
        .srcB (bmuxout),
        .alu_fun (alu_fun),
        .result (alu_result)    );
    
    //ALU mux a
    always_comb begin
        case (alu_srcA)
            1'b0 : amuxout = rs1;
            1'b1 : amuxout = utype;
            default : amuxout = 32'd0;
        endcase
    end
    
    //ALU mux b
    always_comb begin
        case (alu_srcB)
            2'b00 : bmuxout = rs2;
            2'b01 : bmuxout = itype;
            2'b10 : bmuxout = stype;
            2'b11 : bmuxout = pc_out;
            default : bmuxout = 32'd0;
        endcase
    end
endmodule

