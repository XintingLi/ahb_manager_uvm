import uvm_pkg::*;
`include "uvm_macros.svh"
`include "environment.svh"
`include "bus_sequences.svh"

class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    localparam ADDR_WIDTH = 32;
    localparam DATA_WIDTH = 32;
    virtual ahb_if#(ADDR_WIDTH, DATA_WIDTH) vif;
    virtual bus_if bvif;
    environment env;

    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = environment::type_id::create("env", this);

        if (!uvm_config_db#(virtual ahb_if#(ADDR_WIDTH, DATA_WIDTH))::get(this, "", "ahb_vif", vif))
            `uvm_fatal("Test", "No virtual interface specified for this test instance")
        uvm_config_db#(virtual ahb_if#(ADDR_WIDTH, DATA_WIDTH))::set(this, "env.agt*", "ahb_vif", vif);

        if (!uvm_config_db#(virtual bus_if)::get(this, "", "bus_vif", bvif))
            `uvm_fatal("Test", "No virtual interface specified for this test instance")
        uvm_config_db#(virtual bus_if)::set(this, "env.agt*", "bus_vif", bvif);
    endfunction

    task main_phase(uvm_phase phase);
        bus_seq b_seq = bus_seq::type_id::create("b_seq", this);

        phase.raise_objection(this, "Starting main phase");
        $display("%t Starting sequence...", $time);
        b_seq.start(env.bus_agt.sqr);
        #10ns
        phase.drop_objection(this, "Finished main phase");
    endtask

endclass : base_test

class read_test extends base_test;
    `uvm_component_utils(read_test)

    function new(string name = "read_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        bus_seq b_seq = bus_seq::type_id::create("b_seq", this);
        `uvm_info(this.get_name(), "Starting read sequence....", UVM_LOW);
        b_seq.start(env.bus_agt.sqr);
        `uvm_info(this.get_name(), "Finished read sequence", UVM_LOW);
        #10ns
        phase.drop_objection(this, "Finished main phase");
    endtask
endclass : read_test

class write_test extends base_test;
    `uvm_component_utils(write_test)

    function new(string name = "write_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        bus_seq b_seq = bus_seq::type_id::create("b_seq", this);
        `uvm_info(this.get_name(), "Starting write sequence....", UVM_LOW);
        b_seq.start(env.bus_agt.sqr);
        `uvm_info(this.get_name(), "Finished write sequence", UVM_LOW);
        #10ns
        phase.drop_objection(this, "Finished main phase");
    endtask
endclass : write_test
