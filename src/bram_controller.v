`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/27 16:48:45
// Design Name: 
// Module Name: singleBramCtrl
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
`timescale 1 ns / 1 ps

module bram_controller #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 12
)(
    input                   system_clk,
    input                   reset,
    input                   run,
    input                   mode,
    input  [ADDR_WIDTH-1:0] addr,
    input  [DATA_WIDTH-1:0] write_data,
    output                  idle,
    output                  done,

//  Block Memory Interface    
    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *)
    output[ADDR_WIDTH-1:0]  bram_addr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *)
    output                  bram_clk,    
    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *)
    output[DATA_WIDTH-1:0]  bram_wrdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *)
    input [DATA_WIDTH-1:0]  bram_rddata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *)    
    output                  bram_en,
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_PORTA, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, READ_LATENCY 1" *)
    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA RST" *)
    output                  bram_rst,
    (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *)
    output [3:0]            bram_we,    

// output read value from BRAM
    output                  read_valid,
    output[DATA_WIDTH-1:0]  read_data
);
  

/////// Local Param. to define state ////////
localparam S_IDLE       = 3'd0;
localparam S_WRITE      = 3'd1;
localparam S_READ       = 3'd2;
localparam S_DONE       = 3'd3;
localparam S_UNKOWN     = 3'd4;

localparam READ_MODE    = 1'b0;
localparam WRITE_MODE   = 1'b1;

/////// Type ////////
reg [2:0]   current_state; // Current state  (F/F)
reg [2:0]   next_state; // Next state (Variable in Combinational Logic)
wire        write_flag;
wire        read_flag;
wire        is_write_done;
wire        is_read_done;
wire        is_done;

/////// Main ////////

// Step 1. always block to update state 
always @(posedge system_clk or negedge reset) begin
    if(!reset) begin
        current_state <= S_IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Step 2. always block to compute next_state
//always @(current_state or run or is_done) 
always @(*)
begin
    next_state = current_state; // To prevent Latch.
    case(current_state)
        S_IDLE :
            if(run) begin                
                if(mode == 1'b1) begin
                    next_state = S_WRITE;
                end else if(mode == 1'b0) begin
                    next_state = S_READ;
                end else begin
                    next_state = S_IDLE;
                end   
            end
        S_WRITE : 
            if(is_write_done) begin
                next_state = S_DONE;
            end
        S_READ  : 
            if(is_read_done) begin
                next_state = S_DONE;
            end
        S_DONE  :
            if(is_done) begin
                next_state = S_IDLE;
            end
    endcase
end 

// Step 3.  always block to compute output
// Added to communicate with control signals.
assign idle         = (current_state == S_IDLE);
assign write_flag   = (current_state == S_WRITE);
assign read_flag    = (current_state == S_READ);
assign done         = (current_state == S_DONE);

reg [1:0] num_cnt; 
assign is_write_done    = write_flag && (num_cnt == 2'd0);
assign is_read_done     = read_flag  && (num_cnt == 2'd0);
assign is_done          = done && (num_cnt == 2'd0);
 
always @(posedge system_clk or negedge reset) begin
    if(!reset) begin
        num_cnt <= 0;  
    end else if (is_write_done || is_read_done || is_done) begin
        num_cnt <= 0;  
    end else if (write_flag || read_flag || done) begin
        num_cnt <= num_cnt + 1;
    end 
end

// Assign Memory I/F
assign bram_addr    = addr;
assign bram_clk     = system_clk;
assign bram_wrdata  = write_data;
assign bram_en      = write_flag || read_flag || done;
assign bram_rst     = ~reset;
assign bram_we      = (current_state == S_WRITE) ? 4'hF:4'h0;



// output data from memory 
reg                     r_valid;

// 1 cycle latency to sync mem output
always @(posedge system_clk or negedge reset) begin
    if(!reset) begin
        r_valid <= 0;  
    end else begin
        r_valid <= done; // read data
    end 
end

assign read_valid = r_valid;
assign read_data = bram_rddata;  // direct assign, bus Matbi recommends you to add a register for timing.


endmodule