import uvm_pkg::*;
`include "uvm_macros.svh"
`include "bus_transaction.svh"

class bus_seq extends uvm_sequence#(bus_transaction);
    `uvm_object_utils(bus_seq)

    function new(string name = "bus_seq");
        super.new(name);
    endfunction

    task body();
        bus_transaction req_item;
        req_item = bus_transaction::type_id::create("req_item");

        start_item(req_item);
        req_item.wen = 0;
        req_item.ren = 0;
        req_item.addr = 0;
        req_item.wdata = 0;
        req_item.strobe = 0;
        finish_item(req_item);
    endtask
endclass : bus_seq

class read_seq extends uvm_sequence#(bus_transaction);
    `uvm_object_utils(read_seq)

    function new(string name = "configure_50p_duty");
        super.new(name);
    endfunction

    task body();
        bus_transaction req_item;
        req_item = bus_transaction::type_id::create("req_item");

        start_item(req_item);
        req_item.wen = 0;
        req_item.ren = 1;
        req_item.addr = 32'h4;
        req_item.rdata = 32'h1111;
        finish_item(req_item);
    endtask

endclass : read_seq

class write_seq extends uvm_sequence#(bus_transaction);
    `uvm_object_utils(write_seq)

    function new(string name = "configure_30p_center_low");
        super.new(name);
    endfunction

    task body();
        bus_transaction req_item;
        req_item = bus_transaction::type_id::create("req_item");

        start_item(req_item);
        req_item.wen = 1;
        req_item.ren = 0;
        req_item.addr = 32'h8;
        req_item.wdata = 32'h10;
        finish_item(req_item);    
    endtask

endclass : write_seq