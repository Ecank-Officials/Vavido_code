`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/24 12:43:56
// Design Name: 
// Module Name: riscv
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


module riscv(
        input                 rst_n,
        input                 clk,
        
        input [31:0]          rom_data_i,
        output [31:0]         rom_addr_o,
        output                rom_ce_o
    );

wire [31:0]             pc;
wire [31:0]             id_pc_i;
wire [31:0]             id_inst_i;

wire [6:0]              id_aluop_o;
wire [2:0]              id_alusel_o;
wire [6:0]              id_alusel_o2;
wire [31:0]             id_reg1_o;
wire [31:0]             id_reg2_o;
wire                    id_wreg_o;
wire [4:0]              id_wd_o;

wire [6:0]              ex_aluop_i;
wire [2:0]              ex_alusel_i;
wire [6:0]              ex_alusel_i2;
wire [31:0]             ex_reg1_i;
wire [31:0]             ex_reg2_i;
wire                    ex_wreg_i;
wire [4:0]              ex_wd_i;
      //......


wire                    ex_wreg_o;
wire [4:0]              ex_wd_o;
wire [31:0]             ex_wdata_o;

wire                    mem_wreg_i;
wire [4:0]              mem_wd_i;
wire [31:0]             mem_wdata_i;

wire                    mem_wreg_o;
wire [4:0]              mem_wd_o;
wire [31:0]             mem_wdata_o;

wire                    wb_wreg_i;
wire [4:0]              wb_wd_i;
wire [31:0]             wb_wdata_i;

wire                    reg1_read;
wire                    reg2_read;
wire [31:0]             reg1_data;
wire [31:0]             reg2_data;
wire [4:0]              reg1_addr;
wire [4:0]              reg2_addr;

                        pc_reg pc_reg0(
                            .clk(clk),
                            .rst_n(rst_n),
                            .pc(pc),
                            .ce(rom_ce_o)
                        );
                        assign rom_addr_o = pc;
                        
                        if_id if_id0(
                            .clk(clk),
                            .rst_n(rst_n),
                            .if_pc(pc),
                            .if_inst(rom_data_i),
                            .id_pc(id_pc_i),
                            .id_inst(id_inst_i)
                        );
                        regfile regfile0(
                            .clk(clk),
                            .rst_n(rst_n),
                            .we(wb_wreg_i),
                            .waddr(wb_wd_i),
                            .wdata(wb_wdata_i),
                            .re1(reg1_read),
                            .raddr1(reg1_addr),
                            .rdata1(reg1_data),
                            .re2(reg2_read),
                            .raddr2(reg2_addr),
                            .rdata2(reg2_data)
                        );
id id0(
    .rst_n(rst_n),
    .pc_i(id_pc_i),
    .inst_i(id_inst_i),
    
    .reg1_data_i(reg1_data),
    .reg2_data_i(reg2_data),
    
    .reg1_read_o(reg1_read),
    .reg2_read_o(reg2_read),
    .reg1_addr_o(reg1_addr),
    .reg2_addr_o(reg2_addr),
    
    .aluop_o(id_aluop_o),
    .alusel_o(id_alusel_o),
    .alusel_o2(id_alusel_o2),
    .reg1_o(id_reg1_o),
    .reg2_o(id_reg2_o),
    .wd_o(id_wd_o),
    .wreg_o(id_wreg_o),
    
    .ex_wreg_i(ex_wreg_o),
    .ex_wdata_i(ex_wdata_o),
    .ex_wd_i(ex_wd_o),

    .mem_wreg_i(mem_wreg_o),
    .mem_wdata_i(mem_wdata_o),
    .mem_wd_i(mem_wd_o)
);



id_ex id_ex0(
    .clk(clk),
    .rst_n(rst_n),
    
    .id_aluop(id_aluop_o),
    .id_alusel(id_alusel_o),
    .id_alusel2(id_alusel_o2),
    .id_reg1(id_reg1_o),
    .id_reg2(id_reg2_o),
    .id_wd(id_wd_o),
    .id_wreg(id_wreg_o),
    
    .ex_aluop(ex_aluop_i),
    .ex_alusel(ex_alusel_i),
    .ex_alusel2(ex_alusel_i2),
    .ex_reg1(ex_reg1_i),
    .ex_reg2(ex_reg2_i),
    .ex_wd(ex_wd_i),
    .ex_wreg(ex_wreg_i) 
);

ex ex0(
    .rst_n(rst_n),
    
    .aluop_i(ex_aluop_i),
    .alusel_i(ex_alusel_i),
    .alusel_i2(ex_alusel_i2),
    .reg1_i(ex_reg1_i),
    .reg2_i(ex_reg2_i),
    .wd_i(ex_wd_i),
    .wreg_i(ex_wreg_i),
    
    .wd_o(ex_wd_o),
    .wreg_o(ex_wreg_o),
    .wdata_o(ex_wdata_o)
);

ex_mem ex_mem0(
    .clk(clk),
    .rst_n(rst_n),
    
    .ex_wd(ex_wd_o),
    .ex_wreg(ex_wreg_o),
    .ex_wdata(ex_wdata_o),
    
    .mem_wd(mem_wd_i),
    .mem_wreg(mem_wreg_i),
    .mem_wdata(mem_wdata_i)
);

mem mem0(
    .rst_n(rst_n),
    
    .wd_i(mem_wd_i),
    .wreg_i(mem_wreg_i),
    .wdata_i(mem_wdata_i),
    
    .wd_o(mem_wd_o),
    .wreg_o(mem_wreg_o),
    .wdata_o(mem_wdata_o)
);

mem_wb mem_wb0(
    .clk(clk),
    .rst_n(rst_n),
    
    .mem_wd(mem_wd_o),
    .mem_wreg(mem_wreg_o),
    .mem_wdata(mem_wdata_o),
    
    .wb_wd(wb_wd_i),
    .wb_wreg(wb_wreg_i),
    .wb_wdata(wb_wdata_i)
);
endmodule
