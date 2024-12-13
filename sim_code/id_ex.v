`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/23 22:37:29
// Design Name: 
// Module Name: id_ex
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


module id_ex(
        input                clk,
        input                rst_n,
        
        input [6:0]          id_aluop,
        input [2:0]          id_alusel,
        input [6:0]          id_alusel2,
        input [31:0]         id_reg1,
        input [31:0]         id_reg2,
        input [4:0]          id_wd,
        input                id_wreg,               //目的寄存器使能
        
        output reg [6:0]     ex_aluop,
        output reg [2:0]     ex_alusel,
        output reg [6:0]     ex_alusel2,
        output reg [31:0]    ex_reg1,
        output reg [31:0]    ex_reg2,
        output reg [4:0]     ex_wd,
        output reg           ex_wreg
    );
    
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        ex_aluop <= 0;
        ex_alusel <= 0;
        ex_alusel2 <= 0;
        ex_reg1 <= 0;
        ex_reg2 <= 0;
        ex_wd <= 0;
        ex_wreg <= 0;
    end
    else begin
        ex_aluop <= id_aluop;
        ex_alusel <= id_alusel;
        ex_alusel2 <= id_alusel2;
        ex_reg1 <= id_reg1;
        ex_reg2 <= id_reg2;
        ex_wd <= id_wd;
        ex_wreg <= id_wreg;   
    end
end
endmodule
