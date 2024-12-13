`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/23 22:55:58
// Design Name: 
// Module Name: ex
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


module ex(
    input                rst_n,
    input [6:0]          aluop_i,
    input [2:0]          alusel_i,
    input [6:0]          alusel_i2,
    input [31:0]         reg1_i,
    input [31:0]         reg2_i,
    input [4:0]          wd_i,
    input                wreg_i,
    
    output reg [4:0]     wd_o,
    output reg           wreg_o,
    output reg [31:0]    wdata_o
    );

reg [31:0] result;

always @ (*) begin         //通过译码阶段发送过来的信息确定具体的运算操作
    if(~rst_n)
        result <= 0;
    else begin
        case(aluop_i)
            7'b0010011: begin
                case(alusel_i)
                    3'b000: result <= reg1_i + reg2_i;  //执行相应的运算
                    3'b001: result <= reg1_i << reg2_i;
                    3'b100: result <= reg1_i ^ reg2_i;
                    3'b110: result <= reg1_i | reg2_i;
                    3'b111: result <= reg1_i & reg2_i;
                    3'b010: result <= (reg1_i<reg2_i)?1:0;//有符号小于
                    3'b011: result <= (reg1_i<reg2_i)?1:0;//无符号小于
                    3'b101:begin
                        case(alusel_i2)
                            7'b0000000:result <= reg1_i >>reg2_i;//右移
                            7'b0100000:result <= ((reg1_i>>reg2_i[4:0])&(32'hffffffff>>reg2_i[4:0]))|({32{reg1_i[31]}})&(^(32'hffffffff>>reg2_i[4:0]));
                        endcase
                    end                    
                    default: begin
                        result <= 0;
                    end
                endcase
            end
            7'b0110011: begin
                case(alusel_i)
                   // 3'b000: result <= reg1_i + reg2_i;
                    3'b001: result <= reg1_i << reg2_i;
                    3'b100: result <= reg1_i ^ reg2_i;
                    3'b110: result <= reg1_i | reg2_i;
                    3'b111: result <= reg1_i & reg2_i;
                   // 3'b101: result <= reg1_i >> reg2_i;//reg1右移reg2两位
                    3'b010: result <= (reg1_i<reg2_i)?1:0;//有符号小于
                    3'b011: result <= (reg1_i<reg2_i)?1:0;//无符号小于
                    3'b000:begin
                        case(alusel_i2)
                            7'b0000000: result <= reg1_i + reg2_i;
                            7'b0100000: result <= reg1_i - reg2_i;
                        endcase
                    end  
                    3'b101:begin
                        case(alusel_i2)
                            7'b0000000:result <= reg1_i >>reg2_i;//右移
                            7'b0100000:result <= ((reg1_i>>reg2_i[4:0])&(32'hffffffff>>reg2_i[4:0]))|({32{reg1_i[31]}})&(^(32'hffffffff>>reg2_i[4:0]));
                        endcase
                    end 
                endcase
            end
            default: begin
            end
        endcase
    end
end

always @ (*) begin           //将运算结果发送到下一阶段
    wd_o <= wd_i;
    wreg_o <= wreg_i;
    case(aluop_i)
        7'b0010011: begin
            case(alusel_i)
                3'b000,3'b001,3'b100,3'b110,3'b111,3'b010,3'b011,3'b101: wdata_o <= result;
                default: begin
                end
            endcase
        end
        7'b0110011: begin
            case(alusel_i)
                3'b000,3'b001,3'b100,3'b110,3'b111,3'b101,3'b010,3'b011: wdata_o <= result;
                default: begin
                end
            endcase
        end
        default: begin
            wdata_o <= 0;
        end
    endcase
end
endmodule
