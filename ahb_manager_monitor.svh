`ifndef AHB_MANAGER_MONITOR_SVH
`define AHB_MANAGER_MONITOR_SVH

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "ahb_if.svh"
`include "ahb_manager_transaction.svh"

class ahb_manager_monitor extends uvm_monitor;
    `uvm_component_utils(ahb_manager_monitor)
    localparam ADDR_WIDTH = 32;
    localparam DATA_WIDTH = 32;

    virtual ahb_if#(ADDR_WIDTH, DATA_WIDTH) vif;

    uvm_analysis_port#(ahb_manager_transaction) ahb_manager_ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ahb_manager_ap = new("ahb_manager_ap", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(virtual ahb_if#(ADDR_WIDTH, DATA_WIDTH))::get(this, "", "ahb_manager_vif", vif))
            `uvm_fatal("ahb_manager_monitor", "No virtual interface specified for this test instance");
        uvm_config_db#(virtual ahb_if#(ADDR_WIDTH, DATA_WIDTH))::set(this, "env.agt*", "ahb_vif", vif);
    endfunction

    virtual task main_phase(uvm_phase phase);
        super.main_phase(phase);
        // wait for DUT reset
        @(posedge vif.clk);
        @(posedge vif.clk);

        forever begin
            ahb_manager_transaction tx;
            @(posedge vif.clk);
            tx = ahb_manager_transaction::type_id::create("tx");
            tx.HSEL = vif.a_m_if.HSEL;
            tx.HREADY = vif.a_m_if.HREADY;
            tx.HREADYOUT = vif.a_m_if.HREADYOUT;
            tx.HWRITE = vif.a_m_if.HWRITE;
            tx.HMASTLOCK = vif.a_m_if.HMASTLOCK;
            tx.HRESP = vif.a_m_if.HRESP;
            tx.HTRANS = vif.a_m_if.HTRANS;
            tx.HADDR[ADDR_WIDTH - 1:0] = vif.a_m_if.HADDR[ADDR_WIDTH - 1:0];
            tx.HWDATA = vif.a_m_if.HWDATA;
            tx.HRDATA = vif.a_m_if.HRDATA;
            tx.HWSTRB = vif.a_m_if.HWSTRB;
            ahb_manager_ap.write(tx);
        end
    
    endtask

endclass : ahb_manager_monitor

`endif