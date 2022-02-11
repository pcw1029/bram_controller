`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/03 17:16:12
// Design Name: 
// Module Name: tb_single_bram_ctrl
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


module tb_bram_controller();

`define ADDR_WIDTH 12
`define DATA_WIDTH 32

reg                     system_clk_0;
reg                     reset_0;

reg 					run_0;
reg [`ADDR_WIDTH-1:0]   addr_0;
reg                     mode_0;
reg [`DATA_WIDTH-1:0]   write_data_0;
wire                    done_0;
wire                    idle_0;
wire [`DATA_WIDTH-1:0]  read_data_0;
wire                    read_valid_0;

reg 					run_1;
reg [`ADDR_WIDTH-1:0]   addr_1;
reg                     mode_1;
reg [`DATA_WIDTH-1:0]   write_data_1;
wire                    done_1;
wire                    idle_1;
wire [`DATA_WIDTH-1:0]  read_data_1;
wire                    read_valid_1;


// clk gen
always
    #5 system_clk_0 = ~system_clk_0;

integer i;

initial begin
//initialize value
$display("initialize value [%0d]", $time);
    reset_0   = 1;
    system_clk_0         = 0;
	run_0 	= 0;
	run_1 	= 0;
	mode_0   = 0;
	mode_1   = 0;
	
// reset_n gen
$display("Reset! [%0d]", $time);
# 30
    reset_0 = 0;
# 10
    reset_0 = 1;
# 10
@(posedge system_clk_0);


$display("Check Idle [%0d]", $time);
wait(idle_0);

$display("Start Write! [%d]", $time);
	for(i=0; i<10; i = i+1) begin
		@(negedge system_clk_0);
		run_0 = 1;
		addr_0 = i*4;
        mode_0 = 1;
        write_data_0 = i;
		@(posedge system_clk_0);
		run_0 = 0;
		wait(done_0);
		wait(!done_0);
	end
	

$display("Start Read! [%d]", $time);    
	for(i=1; i<10; i = i+1) begin
		@(negedge system_clk_0);
		run_1 = 1;
		addr_1 = i*4;
        mode_1 = 0;
        $display("read bram [%d]", read_data_1);
		@(posedge system_clk_0);
		run_1 = 0;
		wait(read_valid_1);
		wait(!read_valid_1);		
	end	
	addr_1 = 10;
	

# 30
$display("Success Simulation!! (Matbi = gudok & joayo) [%0d]", $time);
$finish;
end

// Call DUT


design_1_wrapper tb_bram_controller(
    .system_clk_0   (system_clk_0),
    .addr_0         (addr_0),
    .mode_0         (mode_0),
    .run_0          (run_0),
    .write_data_0   (write_data_0),
    .done_0         (done_0),
    .idle_0         (idle_0),
    .read_data_0    (read_data_0),
    .read_valid_0   (read_valid_0),
    .reset_0        (reset_0),
    .addr_1         (addr_1),
    .mode_1         (mode_1),
    .run_1          (run_1),
    .write_data_1   (write_data_1),
    .done_1         (done_1),
    .idle_1         (idle_1),
    .read_data_1    (read_data_1),
    .read_valid_1   (read_valid_1) 
);
    
endmodule
