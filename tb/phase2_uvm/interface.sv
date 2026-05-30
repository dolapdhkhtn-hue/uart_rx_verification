`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

// ============================================================
// INTERFACE
// ============================================================
interface uart_if(input logic clk);
    logic        reset_n;
    logic        rx;
    logic [7:0]  p_addr;
    logic        p_write;
    logic        p_enable;
    logic        p_sel_uart;
    logic [7:0]  p_data_uart;
endinterface