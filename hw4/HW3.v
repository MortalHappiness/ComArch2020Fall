module HW3(clk,
           rst_n,
           // for mem_I
           mem_addr_I,
           mem_rdata_I,
           // for result output
           instruction_type,
           instruction_format,
           );

input                clk, rst_n        ;
output reg  [31:2]   mem_addr_I        ;
input       [31:0]   mem_rdata_I       ;
output reg  [22:0]   instruction_type  ;
output reg  [ 4:0]   instruction_format;

reg         [31:2]   next_mem_addr_I;
reg         [22:0]   next_instruction_type  ;
reg         [ 4:0]   next_instruction_format;

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


always @(*) begin
    next_mem_addr_I = mem_addr_I + 1'b1;
    next_instruction_type = instruction_type;
    next_instruction_format = instruction_format;

    // R type
    if (mem_rdata_I[6:0] == 7'b0110011) begin
        next_instruction_format = R_TYPE;
        if (mem_rdata_I[14:12] == 3'b000 &&
            mem_rdata_I[31:25] == 7'b0000000) begin
            next_instruction_type = ADD;
        end
        else if (mem_rdata_I[14:12] == 3'b000 &&
                 mem_rdata_I[31:25] == 7'b0100000) begin
            next_instruction_type = SUB;
        end
        else if (mem_rdata_I[14:12] == 3'b001 &&
                 mem_rdata_I[31:25] == 7'b0000000) begin
            next_instruction_type = SLL;
        end
        else if (mem_rdata_I[14:12] == 3'b010 &&
                 mem_rdata_I[31:25] == 7'b0000000) begin
            next_instruction_type = SLT;
        end
        else if (mem_rdata_I[14:12] == 3'b100 &&
                 mem_rdata_I[31:25] == 7'b0000000) begin
            next_instruction_type = XOR;
        end
        else if (mem_rdata_I[14:12] == 3'b101 &&
                 mem_rdata_I[31:25] == 7'b0000000) begin
            next_instruction_type = SRL;
        end
        else if (mem_rdata_I[14:12] == 3'b101 &&
                 mem_rdata_I[31:25] == 7'b0100000) begin
            next_instruction_type = SRA;
        end
        else if (mem_rdata_I[14:12] == 3'b110 &&
                 mem_rdata_I[31:25] == 7'b0000000) begin
            next_instruction_type = OR;
        end
        else if (mem_rdata_I[14:12] == 3'b111 &&
                 mem_rdata_I[31:25] == 7'b0000000) begin
            next_instruction_type = AND;
        end
    end

    // I type
    else if (mem_rdata_I[6:0] == 7'b1100111) begin
        next_instruction_format = I_TYPE;
        if (mem_rdata_I[14:12] == 3'b000) begin
            next_instruction_type = JALR;
        end
    end
    else if (mem_rdata_I[6:0] == 7'b0000011) begin
        next_instruction_format = I_TYPE;
        if (mem_rdata_I[14:12] == 3'b011) begin
            next_instruction_type = LD;
        end
    end
    else if (mem_rdata_I[6:0] == 7'b0010011) begin
        next_instruction_format = I_TYPE;
        if (mem_rdata_I[14:12] == 3'b000) begin
            next_instruction_type = ADDI;
        end
        else if (mem_rdata_I[14:12] == 3'b001 &&
                 mem_rdata_I[31:25] == 7'b0000000) begin
            next_instruction_type = SLLI;
        end
        else if (mem_rdata_I[14:12] == 3'b010) begin
            next_instruction_type = SLTI;
        end
        else if (mem_rdata_I[14:12] == 3'b100) begin
            next_instruction_type = XORI;
        end
        else if (mem_rdata_I[14:12] == 3'b110) begin
            next_instruction_type = ORI;
        end
        else if (mem_rdata_I[14:12] == 3'b111) begin
            next_instruction_type = ANDI;
        end
        else if (mem_rdata_I[14:12] == 3'b101 &&
                 mem_rdata_I[31:25] == 7'b0000000) begin
            next_instruction_type = SRLI;
        end
        else if (mem_rdata_I[14:12] == 3'b101 &&
                 mem_rdata_I[31:25] == 7'b0100000) begin
            next_instruction_type = SRAI;
        end
    end

    // S type
    else if (mem_rdata_I[6:0] == 7'b0100011) begin
        next_instruction_format = S_TYPE;
        if (mem_rdata_I[14:12] == 3'b011) begin
            next_instruction_type = SD;
        end
    end

    // B type
    else if (mem_rdata_I[6:0] == 7'b1100011) begin
        next_instruction_format = B_TYPE;
        if (mem_rdata_I[14:12] == 3'b000) begin
            next_instruction_type = BEQ;
        end
        else if (mem_rdata_I[14:12] == 3'b001) begin
            next_instruction_type = BNE;
        end
    end

    // J type
    else if (mem_rdata_I[6:0] == 7'b1101111) begin
        next_instruction_format = J_TYPE;
        next_instruction_type = JAL;
    end
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mem_addr_I <= 1'b0;
        instruction_type <= 1'b0;
        instruction_format <= 1'b0;
    end
    else begin
        mem_addr_I <= next_mem_addr_I;
        instruction_type <= next_instruction_type;
        instruction_format <= next_instruction_format;
    end
end

endmodule
