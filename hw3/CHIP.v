module CHIP(clk,
            rst_n,
            // for mem_I
            mem_addr_I,
            mem_rdata_I,
			// for result output
			instruction_type,
			instruction_format,
			);

    input         clk, rst_n        ;
    output [31:2] mem_addr_I        ;
    input  [31:0] mem_rdata_I       ;
	output [22:0] instruction_type  ;
	output [ 4:0] instruction_format;
    


endmodule
