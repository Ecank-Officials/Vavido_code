`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/24 11:02:17
// Design Name: 
// Module Name: mem_wb
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


module mem_wb(
    input                  rst_n,
    input                  clk,
    
    input [4:0]            mem_wd,
    input                  mem_wreg,
    input [31:0]           mem_wdata,

    output reg [4:0]       wb_wd,
    output reg             wb_wreg,
    output reg [31:0]      wb_wdata
    );

always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        wb_wd <= 0;
        wb_wreg <= 0;
        wb_wdata <= 0;
    end
    else begin
        wb_wd <= mem_wd;
        wb_wreg <= mem_wreg;
        wb_wdata <= mem_wdata;
    end
end
endmodule
