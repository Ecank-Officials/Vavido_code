`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/21 02:06:47
// Design Name: 
// Module Name: pc_reg
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


module pc_reg(
    input              clk,
    input              rst_n,
    output reg [31:0]  pc,
    output reg         ce
    );

always @ (posedge clk or negedge rst_n) begin
    if(~rst_n)
        ce <= 1'b0;
    else
        ce <= 1'b1;      
end

always @ (posedge clk) begin
    if(~ce)
        pc <= 32'b0;
    else
        pc <= pc + 4'h4;
end
endmodule
