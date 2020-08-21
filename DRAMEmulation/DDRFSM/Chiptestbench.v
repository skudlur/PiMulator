`timescale 1ns / 1ps

module Chiptestbench(
       );


parameter BGWIDTH = 2;
parameter BAWIDTH = 2;
parameter ADDRWIDTH = 17;
parameter COLWIDTH = 10;
parameter DEVICE_WIDTH = 4;
parameter BL = 8;

localparam BANKGROUPS = BGWIDTH**2;
localparam BANKSPERGROUP = BAWIDTH**2;
localparam ROWS = 2**ADDRWIDTH;
localparam COLS = COLWIDTH**2;

reg clk;
reg reset_n;
reg halt;
reg [18:0]commands;
reg [BGWIDTH : 0]bg; // bank group address
reg [BAWIDTH : 0]ba; // bank address
wire [DEVICE_WIDTH-1 : 0]dq;
wire dqs_c;
wire dqs_t;
reg [$clog2(ROWS)-1 : 0] row;
reg [$clog2(COLS)-1 : 0] column;

reg [DEVICE_WIDTH-1 : 0]dq_reg;
assign dq = (commands[0] || commands[1]) ? dq_reg : {DEVICE_WIDTH{1'bZ}};
assign dqs_t = (commands[0] || commands[1]) ? 1'b1 : 1'bZ;
assign dqs_c = (commands[0] || commands[1]) ? 1'b0 : 1'bZ;

Chip #(.BGWIDTH(BGWIDTH),
       .BAWIDTH(BAWIDTH),
       .ADDRWIDTH(ADDRWIDTH),
       .COLWIDTH(COLWIDTH),
       .DEVICE_WIDTH(DEVICE_WIDTH),
       .BL(BL)) dut (
       .clk(clk),
       .reset_n(reset_n),
       .halt(halt),
       .commands(commands),
       .bg(bg),
       .ba(ba),
       .dq(dq),
       .dqs_c(dqs_c),
       .dqs_t(dqs_t),
       .row(row),
       .column(column)
     );

always #5 clk = ~clk;

initial
  begin
    clk = 0;
    reset_n = 0;
    halt = 0;
    commands = 19'b0000000000000000000;
    bg = 0;
    ba = 0;
    dq_reg = 0;
    row = 0;
    column = 0;

    #10 // reset down
     reset_n = 1;

    #50 // activating
     commands = 19'b1000000000000000000; // ACT = 1;
    #10
     commands = 19'b0000000000000000000; // ACT = 0;

    #40 // halting
     halt = 1;
    #30
     halt = 0;

    #200 // halting
     halt = 1;
    #40
     halt = 0;

    #80 // writing
     commands = 19'b0000000000000000010; // WR = 1;
    row = 1;
    column = 1;
    dq_reg = 2;
    #10
     column = 4;
    dq_reg = 5;
    #10
     column = 7;
    dq_reg = 8;
    #10
     column = 0;
    dq_reg = 1;
    #10
     column = 3;
    dq_reg = 4;
    #10
     column = 6;
    dq_reg = 7;

    #10 // reading
     commands = 19'b0000000000000100000; // WR = 0; RD = 1;
    row = 1;
    column = 1;
    dq_reg = 0;
    #10
     column = 4;
    #10
     column = 7;
    #10
     column = 0;
    #10
     column = 3;
    #10
     column = 6;

    #10
     commands = 19'b0000000000010000000; // RD = 0; PR = 1;
    row = 0;
    column = 0;
    dq_reg = 0;

    #10
     commands = 19'b0000000000000000000; // PR = 0;

    #210
     $stop;
  end;

endmodule
