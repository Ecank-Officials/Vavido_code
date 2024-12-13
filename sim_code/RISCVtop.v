`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/24 20:02:44
// Design Name: 
// Module Name: RISCVtop
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


module RISCVtop(
        input clk,
        input rst_n
    );
wire [31:0] inst_addr;
wire [31:0] inst;
wire        rom_ce;

riscv riscv0(
    .clk(clk),
    .rst_n(rst_n),
    .rom_addr_o(inst_addr),
    .rom_data_i(inst),
    .rom_ce_o(rom_ce)
);

inst_rom inst_rom0(
    .ce(rom_ce),
    .addr(inst_addr),
    .inst(inst)
);
endmodule
