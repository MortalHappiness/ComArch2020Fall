module HW4(clk,
           rst_n,
           // for mem_I
           mem_addr_I,
           mem_rdata_I,
           // for result output
           ctrl_signal,
           immediate,
           );

input                clk, rst_n   ;
output      [31:2]   mem_addr_I   ;
input       [31:0]   mem_rdata_I  ;
output reg  [11:0]   ctrl_signal  ;
output reg  [31:0]   immediate    ;

reg         [31:0]   delayed_mem_rdata_I;
wire        [22:0]   instruction_type;
wire        [ 4:0]   instruction_format;

parameter JAL   =  {1'b1,22'b0};
parameter JALR  =  {1'b0,1'b1,21'b0};
parameter BEQ   =  {2'b0,1'b1,20'b0};
parameter BNE   =  {3'b0,1'b1,19'b0};
parameter LD    =  {4'b0,1'b1,18'b0};
parameter SD    =  {5'b0,1'b1,17'b0};
parameter ADDI  =  {6'b0,1'b1,16'b0};
parameter SLTI  =  {7'b0,1'b1,15'b0};
parameter XORI  =  {8'b0,1'b1,14'b0};
parameter ORI   =  {9'b0,1'b1,13'b0};
parameter ANDI  =  {10'b0,1'b1,12'b0};
parameter SLLI  =  {11'b0,1'b1,11'b0};
parameter SRLI  =  {12'b0,1'b1,10'b0};
parameter SRAI  =  {13'b0,1'b1,9'b0};
parameter ADD   =  {14'b0,1'b1,8'b0};
parameter SUB   =  {15'b0,1'b1,7'b0};
parameter SLL   =  {16'b0,1'b1,6'b0};
parameter SLT   =  {17'b0,1'b1,5'b0};
parameter XOR   =  {18'b0,1'b1,4'b0};
parameter SRL   =  {19'b0,1'b1,3'b0};
parameter SRA   =  {20'b0,1'b1,2'b0};
parameter OR    =  {21'b0,1'b1,1'b0};
parameter AND   =  {22'b0,1'b1};

parameter R_TYPE = 5'b10000;
parameter I_TYPE = 5'b01000;
parameter S_TYPE = 5'b00100;
parameter B_TYPE = 5'b00010;
parameter J_TYPE = 5'b00001;

parameter CTRL_JAL      = 8'b10000000;
parameter CTRL_JALR     = 8'b01000000;
parameter CTRL_BRANCH   = 8'b00100000;
parameter CTRL_MEMREAD  = 8'b00010000;
parameter CTRL_MEMWRITE = 8'b00001000;
parameter CTRL_MEMTOREG = 8'b00000100;
parameter CTRL_REGWRITE = 8'b00000010;
parameter CTRL_ALUSRC   = 8'b00000001;

parameter ALU_ADD = 4'b0000;
parameter ALU_SUB = 4'b1000;
parameter ALU_SLL = 4'b0001;
parameter ALU_SLT = 4'b0010;
parameter ALU_XOR = 4'b0100;
parameter ALU_SRL = 4'b0101;
parameter ALU_SRA = 4'b1101;
parameter ALU_OR  = 4'b0110;
parameter ALU_AND = 4'b0111;

HW3 decoder (
    clk,
    rst_n,
    mem_addr_I,
    mem_rdata_I,
    instruction_type,
    instruction_format,
);

always @(*) begin
    ctrl_signal = 1'b0;
    immediate = 1'b0;

    if (instruction_format == R_TYPE) begin
        if (instruction_type == ADD) begin
            ctrl_signal = {
                CTRL_REGWRITE,
                ALU_ADD
            };
        end
        else if (instruction_type == SUB) begin
            ctrl_signal = {
                CTRL_REGWRITE,
                ALU_SUB
            };
        end
        else if (instruction_type == SLL) begin
            ctrl_signal = {
                CTRL_REGWRITE,
                ALU_SLL
            };
        end
        else if (instruction_type == SLT) begin
            ctrl_signal = {
                CTRL_REGWRITE,
                ALU_SLT
            };
        end
        else if (instruction_type == XOR) begin
            ctrl_signal = {
                CTRL_REGWRITE,
                ALU_XOR
            };
        end
        else if (instruction_type == SRL) begin
            ctrl_signal = {
                CTRL_REGWRITE,
                ALU_SRL
            };
        end
        else if (instruction_type == SRA) begin
            ctrl_signal = {
                CTRL_REGWRITE,
                ALU_SRA
            };
        end
        else if (instruction_type == OR) begin
            ctrl_signal = {
                CTRL_REGWRITE,
                ALU_OR
            };
        end
        else if (instruction_type == AND) begin
            ctrl_signal = {
                CTRL_REGWRITE,
                ALU_AND
            };
        end
    end
    else if (instruction_format == I_TYPE) begin
        immediate = {
            {20{delayed_mem_rdata_I[31]}},
            delayed_mem_rdata_I[31:20]
        };
        if (instruction_type == JALR) begin
            ctrl_signal = {
                CTRL_JALR | CTRL_REGWRITE,
                ALU_ADD
            };
        end
        else if (instruction_type == LD) begin
            ctrl_signal = {
                CTRL_MEMREAD | CTRL_MEMTOREG | CTRL_REGWRITE | CTRL_ALUSRC,
                ALU_ADD
            };
        end
        else if (instruction_type == ADDI) begin
            ctrl_signal = {
                CTRL_REGWRITE | CTRL_ALUSRC,
                ALU_ADD
            };
        end
        else if (instruction_type == SLLI) begin
            ctrl_signal = {
                CTRL_REGWRITE | CTRL_ALUSRC,
                ALU_SLL
            };
        end
        else if (instruction_type == SLTI) begin
            ctrl_signal = {
                CTRL_REGWRITE | CTRL_ALUSRC,
                ALU_SLT
            };
        end
        else if (instruction_type == XORI) begin
            ctrl_signal = {
                CTRL_REGWRITE | CTRL_ALUSRC,
                ALU_XOR
            };
        end
        else if (instruction_type == ORI) begin
            ctrl_signal = {
                CTRL_REGWRITE | CTRL_ALUSRC,
                ALU_OR
            };
        end
        else if (instruction_type == ANDI) begin
            ctrl_signal = {
                CTRL_REGWRITE | CTRL_ALUSRC,
                ALU_AND
            };
        end
        else if (instruction_type == SRLI) begin
            ctrl_signal = {
                CTRL_REGWRITE | CTRL_ALUSRC,
                ALU_SRL
            };
        end
        else if (instruction_type == SRAI) begin
            ctrl_signal = {
                CTRL_REGWRITE | CTRL_ALUSRC,
                ALU_SRA
            };
        end
    end
    else if (instruction_format == S_TYPE) begin
        // Only SD
        ctrl_signal = {
            CTRL_MEMWRITE | CTRL_ALUSRC,
            ALU_ADD
        };
        immediate = {
            {20{delayed_mem_rdata_I[31]}},
            delayed_mem_rdata_I[31:25],
            delayed_mem_rdata_I[11:7]
        };
    end
    else if (instruction_format == B_TYPE) begin
        // Only BEQ and BNE
        ctrl_signal = {
            CTRL_BRANCH,
            ALU_ADD
        };
        immediate = {
            {20{delayed_mem_rdata_I[31]}},
            delayed_mem_rdata_I[7],
            delayed_mem_rdata_I[30:25],
            delayed_mem_rdata_I[11:8],
            1'b0
        };
    end
    else if (instruction_format == J_TYPE) begin
        // Only JAL
        ctrl_signal = {
            CTRL_JAL | CTRL_REGWRITE,
            ALU_ADD
        };
        immediate = {
            {12{delayed_mem_rdata_I[31]}},
            delayed_mem_rdata_I[19:12],
            delayed_mem_rdata_I[20],
            delayed_mem_rdata_I[30:21],
            1'b0
        };
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        delayed_mem_rdata_I <= 1'b0;
    end
    else begin
        delayed_mem_rdata_I <= mem_rdata_I;
    end
end

endmodule
