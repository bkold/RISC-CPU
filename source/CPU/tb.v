module test;
	/* Make a reset that pulses once. */
	reg sclk=1;
	reg reset=0;
	reg load=0;
	reg [31:0]addr=0;
	reg [31:0]instr=0;
	
	initial begin  	
	#1 reset=1;
	#0 load=1;
	#1 addr = 0;
	#0 instr = 32'd8; //NOP
	#1 addr = 32'h4;
	#0 instr = 32'd8; //NOP
	#1 addr = 32'h8;
	#0 instr = 32'b00110100000000000000000000010100; //load address 50 for core1.0
	#1 addr = 32'hc;
	#0 instr = 32'b00110000001000000000000000000000; // BCPU 1, 0
	#1 addr = 32'h10;
	#0 instr = 32'b00100000000000000000000000011110; //sleep 30
	#1 addr = 32'h14;
	#0 instr = 32'b00110100000000000000000000011011; //load address 6c for core1.1
	#1 addr = 32'h18;
	#0 instr = 32'b00110000001000010000000000000000; // BCPU 1, 1
	#1 addr = 32'h1c;
	#0 instr = 32'b00000011110000000001000000001000; //add $2, $30, $0 aka move $2, $30
	#1 addr = 32'h20;
	#0 instr = 32'd8; //NOP;
	#1 addr = 32'h24;
	#0 instr = 32'd8; //NOP;
	#1 addr = 32'h28;
	#0 instr = 32'b00100000000000000000000000011110; //sleep 30
	#1 addr = 32'h2c;
	#0 instr = 32'b00111100010000000000000000000000; //BCPUJR $2
	#1 addr = 32'h30;
	#0 instr = 32'b00110000001000000000000000000000; // BCPU 1, 0
	#1 addr = 32'h34;
	#0 instr = 32'b00000011110000000001000000001000; //add $2, $30, $0 aka move $2, $30
	#1 addr = 32'h38;
	#0 instr = 32'd8; //NOP;
	#1 addr = 32'h3c;
	#0 instr = 32'd8; //NOP;
	#1 addr = 32'h40;
	#0 instr = 32'b00100000000000000000000000011110; //sleep 30
	#1 addr = 32'h44;
	#0 instr = 32'b00111100010000000000000000000000; //BCPUJR $2
	#1 addr = 32'h48;
	#0 instr = 32'b00010100000000000000000000000110; //J 18
	#1 addr = 32'h4c;
	#0 instr = 32'd8; //NOP;

	//function for core1.0-count reg2 by 1
	#1 addr = 32'h50;
	#0 instr = 32'd8; //NOP;
	#1 addr = 32'h54;
	#0 instr = 32'd8; //NOP;
	#1 addr = 32'h58;
	#0 instr = 32'b10100000000000100000000000000000; //addi $2, $0, 0
	#1 addr = 32'h5c;
	#0 instr = 32'd8; //NOP;
	#1 addr = 32'h60;
	#0 instr = 32'b10100000010000100000000000000001; //addi $2, $2, 1
	#1 addr = 32'h64; 
	#0 instr = 32'b00010100000000000000000000010111; //J 5c
	#1 addr = 32'h68;
	#0 instr = 32'd8; //NOP;

	//function for core1.1-count reg2 by 2
	#1 addr = 32'h6c;
	#0 instr = 32'd8; //NOP;
	#1 addr = 32'h70;
	#0 instr = 32'd8; //NOP;
	#1 addr = 32'h74;
	#0 instr = 32'b10100000000000100000000000000000; //addi $2, $0, 0
	#1 addr = 32'h78;
	#0 instr = 32'd8; //NOP;
	#1 addr = 32'h7c;
	#0 instr = 32'b10100000010000100000000000000010; //addi $2, $2, 2
	#1 addr = 32'h80; 
	#0 instr = 32'b00010100000000000000000000011110; //J 78
	#1 addr = 32'h84;
	#0 instr = 32'd8; //NOP;
	#3 reset=0;
	#0 load=0;
	#600 $finish;
	end  	

	always #1 sclk=!sclk;
	CPU cpu (sclk, reset, load, addr, instr);
endmodule // test
