`ifndef AHB_MANAGER_TRANSACTION_SVH
`define AHB_MANAGER_TRANSACTION_SVH

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "ahb_manager_if.sv"

class ahb_manager_transaction extends uvm_sequence_item;
    `uvm_object_utils(ahb_manager_transaction)

    localparam ADDR_WIDTH = 32;
    localparam DATA_WIDTH = 32;

    logic HSEL;
    logic HREADY;
    logic HREADYOUT;
    logic HWRITE;
    logic HMASTLOCK;
    logic HRESP;
    logic [1:0] HTRANS;
    logic [2:0] HBURST;
    logic [2:0] HSIZE;
    logic [ADDR_WIDTH - 1:0] HADDR;
    logic [DATA_WIDTH - 1:0] HWDATA;
    logic [DATA_WIDTH - 1:0] HRDATA;
    logic [(DATA_WIDTH/8) - 1:0] HWSTRB;

    function new(string name = "ahb_transaction_transaction");
        super.new(name);
    endfunction

endclass : ahb_manager_transaction

`endif