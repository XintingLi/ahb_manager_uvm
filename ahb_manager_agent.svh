`ifndef AHB_MANAGER_AGENT_SVH
`define AHB_MANAGER_AGENT_SVH

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "ahb_if.svh"
`include "ahb_manager_monitor.svh"

class ahb_manager_agent extends uvm_agent;
    `uvm_component_utils(ahb_manager_agent)
    ahb_manager_monitor mon;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        mon = ahb_manager_monitor::type_id::create("mon", this);
    endfunction

endclass : ahb_manager_agent

`endif