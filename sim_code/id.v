`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/23 19:49:07
// Design Name: 
// Module Name: id
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


module id(
        input             rst_n,
        input [31:0]      pc_i,
        input [31:0]      inst_i,
        //读取register 
        input [31:0]      reg1_data_i,
        input [31:0]      reg2_data_i,
        //输出到regfile
        output reg        reg1_read_o,
        output reg        reg2_read_o,
        output reg [4:0]  reg1_addr_o,
        output reg [4:0]  reg2_addr_o,
        //送出到执行模块
        output reg [6:0]  aluop_o,
        output reg [2:0]  alusel_o,
        output reg [6:0]  alusel_o2,
        output reg [31:0] reg1_o,
        output reg [31:0] reg2_o,
        output reg [4:0]  wd_o,
        output reg        wreg_o,
        
//解决流水线冲突
        input             ex_wreg_i,
        input [31:0]      ex_wdata_i,
        input [4:0]       ex_wd_i,

        input             mem_wreg_i,
        input [31:0]      mem_wdata_i,
        input [4:0]       mem_wd_i
    );

wire [6:0] op  = inst_i[6:0];            //运算类型
wire [2:0] op1 = inst_i[14:12];          //具体运算方式
wire [6:0] op2 = inst_i[31:25];          //具体运算方式

reg [31:0] imm;

always @ (*) begin
    if(~rst_n) begin
        aluop_o <= 0;
        alusel_o <= 0;
        alusel_o2 <= 0;
        wd_o <= 0;
        wreg_o <= 0;
        reg1_read_o <= 0;
        reg2_read_o <= 0;
        reg1_addr_o <= 0;
        reg2_addr_o <= 0;
        imm <= 0;
    end
    else begin
        aluop_o <= 0;
        alusel_o <= 0;
        alusel_o2 <= 0;
        wd_o <= inst_i[11:7];                     //目的寄存器地址
        wreg_o <= 1'b1;                           //目的寄存器使能
        reg1_read_o <= 0;
        reg2_read_o <= 0;
        reg1_addr_o <= inst_i[19:15];
        reg2_addr_o <= inst_i[24:20];
        imm <= 0;
        
        case(op)
            7'b0010011: begin                               //立即数操作
                case (op1)
                    3'b000,3'b100,3'b110,3'b111,3'b010,3'b011: begin      //addi,xori,ori,andi,slt,sltu
                        wreg_o <= 1'b1;                     //是否写目的寄存器
                        aluop_o <= op;                      //运算类型
                        alusel_o <= op1;                    //运算方式
                        reg1_read_o <= 1'b1;                //是否读操作数1
                        reg2_read_o <= 1'b0;                //是否读操作数2
                        imm <= {{20{inst_i[31]}} , inst_i[31:20]};  //立即数扩展
                    end
                    3'b101: begin
                        wreg_o <= 1'b1;                     //是否写目的寄存器
                        aluop_o <= op;                      //运算类型
                        alusel_o <= op1; 
                        alusel_o2 <= op2;                  //运算方式
                        reg1_read_o <= 1'b1;                //是否读操作数1
                        reg2_read_o <= 1'b0;                //是否读操作数2
                        imm <= {{20{inst_i[31]}} , inst_i[31:20]};  //立即数扩展
                    end
                    3'b001: begin                           //slli,srli
                        wreg_o <= 1'b1;                     //是否写目的寄存器
                        aluop_o <= op;                      //运算类型
                        alusel_o <= op1;                    //运算方式
                        reg1_read_o <= 1'b1;                //是否读操作数1
                        reg2_read_o <= 1'b0;                //是否读操作数2
                        imm <= inst_i[24:20];               //移位量
                    end
                    default: begin
                    end
                endcase
            end
            
            7'b0110011: begin                                 //运算操作
                case(op1)
                    3'b001,3'b100,3'b110,3'b111,3'b010,3'b011: begin //add,sll,xor,or,and,slr,slt,sltu
                        wreg_o <= 1'b1;
                        aluop_o <= op;
                        alusel_o <= op1;
                        reg1_read_o <= 1'b1;
                        reg2_read_o <= 1'b1;                    
                    end
                    3'b000,3'b101: begin
                        wreg_o <= 1'b1;
                        aluop_o <= op;
                        alusel_o <= op1;
                        alusel_o2 <= op2;
                        reg1_read_o <= 1'b1;
                        reg2_read_o <= 1'b1; 
                    end 
                    default: begin
                    end
                endcase                
            end
            default: begin
            end
        endcase
    end
end

always @ (*) begin
    if(~rst_n)
        reg1_o <= 0;
    else if((reg1_read_o) && (ex_wreg_i) && (ex_wd_i == reg1_addr_o))     //如果执行阶段的数据为译码阶段所要
                                                                          //读取的数据则直接将其送回译码阶段
        reg1_o <= ex_wdata_i;
    else if((reg1_read_o) && (mem_wreg_i) && (mem_wd_i == reg1_addr_o))   //如果访存阶段的数据为译码阶段所要
                                                                          //读取的数据则直接将其送回译码阶段
        reg1_o <= mem_wdata_i;
        
    else if(reg1_read_o)
        reg1_o <= reg1_data_i;
    else if(~reg1_read_o)
        reg1_o <= imm;    
    else
        reg1_o <= 0;
end

always @ (*) begin
    if(~rst_n)
        reg2_o <= 0;
        
    else if((reg2_read_o) && (ex_wreg_i) && (ex_wd_i == reg2_addr_o))
        reg2_o <= ex_wdata_i;
    else if((reg2_read_o) && (mem_wreg_i) && (mem_wd_i == reg2_addr_o))
        reg2_o <= mem_wdata_i;
        
    else if(reg2_read_o)
        reg2_o <= reg2_data_i;
    else if(~reg2_read_o)
        reg2_o <= imm;
    else
        reg2_o <= 0;    
end

endmodule