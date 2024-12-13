`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/21 02:16:20
// Design Name: 
// Module Name: if_id
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


module if_id(
    input              clk,
    input              rst_n,
    input [31:0]       if_pc,
    input [31:0]       if_inst,
    output reg [31:0]  id_pc,
    output reg [31:0]  id_inst
    );
    
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        id_pc <= 32'b0;
        id_inst <= 32'b0;
    end
    else begin
        id_pc <= if_pc;
        id_inst <= if_inst;
    end
end
endmodule
