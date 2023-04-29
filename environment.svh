`ifndef ENVIROMENT_SVH
`define ENVIROMENT_SVH

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "ahb_manager_agent.svh"
`include "ahb_if.svh"
`include "ahb_manager_transaction.svh"
`include "scoreboard.svh"
`include "bus_if.svh"
`include "bus_agent.svh"
`include "bus_transaction.svh"

class environment_base extends uvm_env;
    `uvm_component_utils(environment_base)
    bus_agent bus_agt;
    ahb_manager_agent ahb_manager_agt;
    scoreboard scrb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        bus_agt = bus_agent::type_id::create("bus_agt", this);
        ahb_manager_agt = ahb_manager_agent::type_id::create("ahb_manager_agt", this);
        uvm_config_db#(int)::set(ahb_manager_agt, "mon.*", "channel_num", 0);
        scrb = scoreboard::type_id::create("scoreboard", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        ahb_manager_agt.mon.ahb_manager_ap.connect(scrb.ahb_manager_export);
    endfunction
endclass : environment_base


class environment extends environment_base;
    `uvm_component_utils(environment)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction
endclass : environment

`endif