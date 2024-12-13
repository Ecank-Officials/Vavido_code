`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/24 10:40:48
// Design Name: 
// Module Name: mem
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


module mem(
    input                 rst_n,
    
    input [4:0]           wd_i,
    input                 wreg_i,
    input [31:0]          wdata_i,
    
    output reg [4:0]      wd_o,
    output reg            wreg_o,
    output reg [31:0]     wdata_o
    );
    
always @ (*) begin
    if(~rst_n) begin
        wd_o <= 0;
        wreg_o <= 0;
        wdata_o <= 0;
    end
    else begin
        wd_o <= wd_i;
        wreg_o <= wreg_i;
        wdata_o <= wdata_i;
    end
end
endmodule
