// this is a test bench feeds initial instruction and data
// the processor output is not verified

`timescale 1 ns/10 ps

`define CYCLE 5.0 // You can modify your clock frequency
`define END_CYCLE 30 // You can modify your maximum cycles
`define PAT_LENGTH 23

`define IMEM_INIT   "./pattern/instruction.txt"
`define IMME_ANS  "./pattern/immediate_ans.txt"
`define CTRL_ANS "./pattern/ctrl_signal_ans.txt"

`ifdef RTL
	`include "HW4.v"
	`include "HW3.v"
`elsif SYN
	`include "./Netlist/HW4_syn.v"
	`include "tsmc13.v"
	`define SDF
	`define SDFFILE "./Netlist/HW4_syn.sdf"
`endif

module HW4_tb;

    reg         clk, rst_n ;

    wire [31:2] mem_addr_I ;
    wire [31:0] mem_rdata_I;
	wire [11:0] ctrl_signal;
	wire [31:0] immediate;
    
    reg  [31:0] mem_data_ans [0:31];
	reg  [11:0] mem_CTRL[0:`PAT_LENGTH-1];
	reg  [31:0] mem_IMME[0:`PAT_LENGTH-1];
    integer i, k, error_num;

    HW4 chip0(
        clk,
        rst_n,
        // for mem_I
        mem_addr_I,
        mem_rdata_I,
		// for result output
		ctrl_signal,
		immediate);

    // Instruction memory
	ROM128x32 i_rom(
		.addr(mem_addr_I[8:2]),
		.data(mem_rdata_I)
	);

    `ifdef SDF
        initial $sdf_annotate(`SDFFILE, chip0);
    `endif
	
    initial begin
        $fsdbDumpfile("RISCV.fsdb");            
        $fsdbDumpvars(0,HW4_tb,"+mda");

        $display("------------------------------------------------------------");
        $display("START!!! Simulation Start .....");
        $display("------------------------------------------------------------\n");
		$display("                        Correct ans              Your ans");
        clk = 1;
        rst_n = 1'b1;
		error_num = 0;
		k = 0;
        #(`CYCLE*0.2) rst_n = 1'b0;
        #(`CYCLE*2.0) rst_n = 1'b1;

		$readmemb (`CTRL_ANS, mem_CTRL);
		$readmemh (`IMME_ANS, mem_IMME);

        #(`CYCLE*`END_CYCLE)
        $display("============================================================\n");
        $display("Simulation time is longer than expected.");
        $display("The test result is .....FAIL :(\n");
        $display("============================================================\n");
        $finish;
    end
	

	always @(negedge clk) begin
		#(`CYCLE/2-0.1)
		if (mem_addr_I > 1'b0) begin
			if ((mem_CTRL[k] != ctrl_signal) || (^ ctrl_signal === 1'bx)) begin
				error_num = error_num + 1;
				$display("Error!   Execution %2d                     %b                    %b", k+1, mem_CTRL[k], ctrl_signal);
			end
			else
				$display("Success! Execution %2d                     %b                    %b", k+1, mem_CTRL[k], ctrl_signal);
			if (mem_IMME[k] !== immediate) begin
				error_num = error_num + 1;
				$display("Error!   Execution %2d   %b  %b", k+1, mem_IMME[k], immediate);
			end
			else
				$display("Success! Execution %2d   %b  %b", k+1, mem_IMME[k], immediate);
			k = k + 1;
		end
		if (k>=`PAT_LENGTH) begin
			if( error_num > 0 )begin
				$display("============================================================\n");
				$display("==============================The result is wrong===============================");
				$display("                    ...                                                         ");
				$display("                  ,,*****/**,*.*(,                                              ");
				$display("              ./((#((/////((#888#8(,** ,                                        ");
				$display("             ,*,*//(/*/#88#(#88&#88888(,                                        ");
				$display("            *//((#&&##((#(##8#8888#8&8#/*                                       ");
				$display("          .*,*/###888###(#(//(/#####&88#/                                       ");
				$display("          ,,/((////**,,,,,**/////(##(888#,                                      ");
				$display("          .*(((/**,,,,,...,,,,*/*//(#(888.                                      ");
				$display("           /(//***,,,,,,....,,,,**/###88#.                                      ");
				$display("           ./*//*,,,,,,....,**,,****(#8(**.                                     ");
				$display("             *///*,,,,,/##/*//**,,,*/#/,/*.                                     ");
				$display("              (//8&88*,**//***,,,,,**(,,,.                                      ");
				$display("              ,/////(*,,,,,,,,..,,**/*/*/                                       ");
				$display("              .****/(*,,,,*,/*,,,****///(                                       ");
				$display("               *//(#((///ERROR,,******/*,                                       ");
				$display("                (//##(((/,..,*,,,,***/***                                       ");
				$display("                 .(*//((//*,,,,,***//***,..                                     ");
				$display("                    //(((//*,,,*//(/***/*,,..                                   ");
				$display("                      ///******(//***,,*/**,..*......  ..     .......           ");
				$display("                        (####(//*****,,,,(/*,..,,..,..,,,..........,,.....      ");
				$display("                     .,((((((((//********,,((,,**,,,,,,..,...,,,,,,,,,,,.,,,    ");
				$display("                  ,,,*,8((##(///////****,,,*#((**,,..,*,******************//*   ");
				$display("               ,,,,,,,,,,(((#(/***/,,,,,,,,,/(*,,,...,,,,,***////*****//////(// ");
				$display("         .,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*,,...*,,,,,,****//*////////((#(/((");
				$display("      .,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,**,,..,*,,,.,,,,,,**/**///((((##(#(((");
				$display("    .,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/(*,,,/,,,.,,,,,,,,***////#(((((###(((");
				$display("   ,,,,,,,,,,,,,,**,,,,,,,,,,,,,,,,,,*,,*(###(#*,,,,,/,,,,,*,,,*(((((#########(,");
				$display("   /*,,*****,***,,,,,,,,,,,,,,,,,******/8###8###/**/,,,,,/,,,,*######(###(###(/,");
				$display("  .//*,,**/***,**,,,,*,,*****,************(8####88###///*,,,/#88&888&&8888#///(,");
				$display("  *//(*****************,**,,*************//////(#8#######(((((((##8888/         ");
				$display("  ///(((/(******************************//*////////(*/((///////((/(((/          ");
				$display(" *///(#/#(////************************///////////////////////////////           ");
				$display(" //////#(8(((/**********//**********//////////////#*////////////////,         \n");
				$display("       FAIL! There are %02d errors at functional simulation !        ", error_num);
				$display("==============================================================================\n");
			end
			else begin
			`ifdef RTL
				$display("=============================The RTL result is PASS=============================");
				$display("  .88/                                                                          ");
				$display("   #88888                                                                       ");
				$display("    (8888**/                                                                    ");
				$display("      88******                                                                  ");
				$display("       8********#                                       *##8#*                  ");
				$display("        ,*********#                         /(********&88888&                   ");
				$display("          #*********#(/************/# (**************#88&*                      ");
				$display("            8***************************************8                           ");
				$display("              ,//*************************/**/#/                                ");
				$display("               /***************************                        #(/*********8");
				$display("               ****************************/              //******************* ");
				$display("              (***@&  &*************&,&&8***        /*************************( ");
				$display("              ****/&&&*******&/******&&/*****   ******************************  ");
				$display("             ,#(((#********************(((((#.  *****************************#  ");
				$display("             #(((((#******************/((((((    ****************************   ");
				$display("              .((((*******SUCCESS*******((((      ***////////////////*******/   ");
				$display("               #(*************************##       ***///                       ");
				$display("               ***/*********************(***        **///*                      ");
				$display("               ************//*///***********8     (*/////(                      ");
				$display("              #********************/*********  (//////(8                        ");
				$display("              ********************#**********8  /(/*                            ");
				$display("              ****************************/**/  8##8                            ");
				$display("             /***/********#******(*******8****######                            ");
				$display("             #*******************(*****/******8                                 ");
				$display("             ,********#((*********************#                                 ");
				$display("              ********************************8                                 ");
				$display("               ******************************8                                  ");
				$display("                #//******///////////******/#                                    ");
			`elsif SYN
				$display("=============================The SYN result is PASS=============================");
				$display("                                 */.  ,                                         ");
				$display("                             (888888888.          .                             ");
				$display("                          . &888888888888.    .  &88888888& .                   ");
				$display("                           888888888&&@@@@&8/.&8888888888888 .                  ");
				$display("                         . @8#................,...,&#88888#8&                   ");
				$display("                         &../&,               ,&(,,....&#8888 .                 ");
				$display("                      .#*/@                      ./,#....,888 .                 ");
				$display("                     &&     .                         /,...*&                   ");
				$display("                    8    ..,@&8             8.#( @      8...,*                  ");
				$display("                  ...    , @&&&8           &      8      /.../ .                ");
				$display("                   8     #/&@#(&,          . 8(,, ..      @,..#                 ");
				$display("                   &     8 @@&&&           *@.  * ,       (...8                 ");
				$display("                   &      8*,/&  88(88     .*    *,       #.,./                 ");
				$display("             .. .. *   ..       .*,,*.                    8..8 .                ");
				$display("            *(    #.&        &                    .,.    8..8 .                 ");
				$display("           &        (&          (#SUCCESS               8..& (8#&(              ");
				$display("           *       ,,.(.          8(/(((8              8.8 #       # .          ");
				$display("           . .&#88,.....#           /#               8.&8,/         *           ");
				$display("                . (,...,.8(88.                    *&,....../.     ./            ");
				$display("                     8...,,,,&8((((&&8((((((((#&@.........,..8    .             ");
				$display("                     .  &(,&    .#//(8#8       &.,........,&                    ");
				$display("                      .. #&      &,8..,,         .....*&. .                     ");
				$display("                  . &*   8/ & (*(./(.#//8#88&@8  &..,8&&  / .                   ");
				$display("                . &         (.#/(8  *(#, .#(8 /  (...(,@#,  ,                   ");
				$display("                 (           #&  8(,8 .*8/  8   /..../&( &(, .                  ");
				$display("                 8           /(# .#&&8&&(    8,.,......//..                     ");
				$display("                . /          #........,,..............&   ,                     ");
				$display("                 . #        ,*(&&&&&@&#,...........,/.    ( .                   ");
				$display("                     @,   &, ,          .   *&@@&,        & .                   ");
				$display("                       ..                    . /,        & ,                    ");
				$display("                                                ,   */.  .                      ");
			`endif
			end
			$finish;
		end
	end
        
    always #(`CYCLE*0.5) clk = ~clk;
        
endmodule


module ROM128x32 (
	addr,
	data
);
	input [6:0] addr;
	output [31:0] data;
	reg [31:0] data;
	reg [31:0] mem [0:127];
		
	integer i;
	initial begin
		// Initialize the instruction memory
		$readmemh (`IMEM_INIT, mem);
		$display("Reading instruction memory......");
	end	
	
	always @(addr) data = mem[addr];
	
endmodule