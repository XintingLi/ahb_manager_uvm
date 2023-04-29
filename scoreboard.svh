`ifndef AHB_BUS_SCOREBOARD
`define AHB_BUS_SCOREBOARD

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "ahb_manager_transaction.svh"
`include "bus_transaction.svh"

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    uvm_analysis_export#(bus_transaction) bus_export;
    uvm_tlm_analysis_fifo#(bus_transaction) bus_fifo;
    uvm_analysis_export#(ahb_manager_transaction) ahb_manager_export;
    uvm_tlm_analysis_fifo#(ahb_manager_transaction) ahb_manager_fifo;

    localparam ADDR_WIDTH = 32;
    localparam DATA_WIDTH = 32;

    logic [31:0] period_cfg, duty_cfg, control_cfg;
    logic expected_HSEL;
    logic expected_HREADY;
    logic expected_HREADYOUT;
    logic expected_HWRITE;
    logic expected_HMASTLOCK;
    logic expected_HRESP;
    logic [1:0] expected_HTRANS;
    // TODO: HBUST check
    // logic [2:0] expected_HBURST;
    logic [2:0] expected_HSIZE;
    logic [ADDR_WIDTH - 1:0] expected_HADDR;
    logic [DATA_WIDTH - 1:0] expected_HWDATA;
    logic [DATA_WIDTH - 1:0] expected_HRDATA;
    logic [(DATA_WIDTH/8) - 1:0] expected_HWSTRB;

    int n_matches, n_mismatches;
    int count, inactive;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        n_matches = 0;
        n_mismatches = 0;
        count = 0;
    endfunction

    function void build_phase(uvm_phase phase);
        ahb_manager_export = new("ahb_manager_export", this);
        ahb_manager_fifo = new("ahb_manager_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        ahb_manager_export.connect(ahb_manager_fifo.analysis_export);
    endfunction

    task configure_phase(uvm_phase phase);
        if (!uvm_config_db#(logic[31:0])::get(null, "env.*", "period_reg_config", period_cfg))
            `uvm_fatal("Scoreboard", "No period config specified for this test instance")
        if (!uvm_config_db#(logic[31:0])::get(null, "env.*", "duty_reg_config", duty_cfg))
            `uvm_fatal("Scoreboard", "No duty config specified for this test instance")
        if (!uvm_config_db#(logic[31:0])::get(null, "env.*", "control_reg_config", control_cfg))
            `uvm_fatal("Scoreboard", "No control config specified for this test instance")
    endtask

    task main_phase(uvm_phase phase);
        ahb_manager_transaction mon_tx; // just a name
        bus_transaction mon_rx; // just a name
        count = 1;
        forever begin
            ahb_manager_fifo.get(mon_tx);
            bus_fifo.get(mon_rx);

            expected_HREADY = ~mon_rx.request_stall;
            expected_HRESP = mon_rx.error;
            expected_HREADYOUT = expected_HREADY;
            expected_HWRITE = mon_rx.wen &~ mon_rx.ren;
            expected_HSEL = ~mon_rx.error && expected_HWRITE;
            expected_HADDR = mon_rx.addr;
            expected_HMASTLOCK = 0;
            expected_HSIZE = 32;
            expected_HTRANS = expected_HSEL? 2'b0:2'b10; // IDLE:NONSEQ
            expected_HWSTRB = mon_rx.strobe;
            expected_HWDATA = mon_rx.wdata;
            expected_HRDATA = mon_rx.rdata;

            // HSEL
            if (mon_tx.HSEL == expected_HSEL) begin
                n_matches++;
                uvm_report_info("Scoreboard", $psprintf("CORRECT\nExpected HSEL: %d\n Actual HSEL:   %d\n Count: %d\n", expected_HSEL, mon_tx.HSEL, count), UVM_LOW);
            end
            else begin
                n_mismatches++;
                uvm_report_info("Scoreboard", $psprintf("INCORRECT\nExpected HSEL: %d\n Actual HSEL:   %d\n Count: %d\n",expected_HSEL, mon_tx.HSEL, count), UVM_LOW);
            end

            // HREADY
            if (mon_tx.HREADY == expected_HREADY) begin
                n_matches++;
                uvm_report_info("Scoreboard", $psprintf("CORRECT\nExpected HREADY: %d\n Actual HREADY:   %d\n Count: %d\n", expected_HREADY, mon_tx.HREADY, count), UVM_LOW);
            end
            else begin
                n_mismatches++;
                uvm_report_info("Scoreboard", $psprintf("INCORRECT\nExpected HREADY: %d\n Actual HREADY:   %d\n Count: %d\n",expected_HREADY, mon_tx.HREADY, count), UVM_LOW);
            end

            // HREADYOUT
            if (mon_tx.HREADYOUT == expected_HREADYOUT) begin
                n_matches++;
                uvm_report_info("Scoreboard", $psprintf("CORRECT\nExpected HREADYOUT: %d\n Actual HREADYOUT:   %d\n Count: %d\n", expected_HREADYOUT, mon_tx.HREADYOUT, count), UVM_LOW);
            end
            else begin
                n_mismatches++;
                uvm_report_info("Scoreboard", $psprintf("INCORRECT\nExpected HREADYOUT: %d\n Actual HREADYOUT:   %d\n Count: %d\n",expected_HREADYOUT, mon_tx.HREADYOUT, count), UVM_LOW);
            end

            // HWRITE
            if (mon_tx.HWRITE == expected_HWRITE) begin
                n_matches++;
                uvm_report_info("Scoreboard", $psprintf("CORRECT\nExpected HWRITE: %d\n Actual HWRITE:   %d\n Count: %d\n", expected_HWRITE, mon_tx.HWRITE, count), UVM_LOW);
            end
            else begin
                n_mismatches++;
                uvm_report_info("Scoreboard", $psprintf("INCORRECT\nExpected HWRITE: %d\n Actual HWRITE:   %d\n Count: %d\n",expected_HWRITE, mon_tx.HWRITE, count), UVM_LOW);
            end

            // HMASTLOCK
            if (mon_tx.HMASTLOCK == expected_HMASTLOCK) begin
                n_matches++;
                uvm_report_info("Scoreboard", $psprintf("CORRECT\nExpected HMASTLOCK: %d\n Actual HMASTLOCK:   %d\n Count: %d\n", expected_HMASTLOCK, mon_tx.HMASTLOCK, count), UVM_LOW);
            end
            else begin
                n_mismatches++;
                uvm_report_info("Scoreboard", $psprintf("INCORRECT\nExpected HMASTLOCK: %d\n Actual HMASTLOCK:   %d\n Count: %d\n",expected_HMASTLOCK, mon_tx.HMASTLOCK, count), UVM_LOW);
            end

            // HRESP
            if (mon_tx.HRESP == expected_HRESP) begin
                n_matches++;
                uvm_report_info("Scoreboard", $psprintf("CORRECT\nExpected HRESP: %d\n Actual HRESP:   %d\n Count: %d\n", expected_HRESP, mon_tx.HRESP, count), UVM_LOW);
            end
            else begin
                n_mismatches++;
                uvm_report_info("Scoreboard", $psprintf("INCORRECT\nExpected HRESP: %d\n Actual HRESP:   %d\n Count: %d\n",expected_HRESP, mon_tx.HRESP, count), UVM_LOW);
            end

            // HTRANS
            if (mon_tx.HTRANS == expected_HTRANS) begin
                n_matches++;
                uvm_report_info("Scoreboard", $psprintf("CORRECT\nExpected HTRANS: %d\n Actual HTRANS:   %d\n Count: %d\n", expected_HTRANS, mon_tx.HTRANS, count), UVM_LOW);
            end
            else begin
                n_mismatches++;
                uvm_report_info("Scoreboard", $psprintf("INCORRECT\nExpected HTRANS: %d\n Actual HTRANS:   %d\n Count: %d\n",expected_HTRANS, mon_tx.HTRANS, count), UVM_LOW);
            end

            // // HBRUST
            // if (mon_tx.HBURST == expected_HBURST) begin
            //     n_matches++;
            //     uvm_report_info("Scoreboard", $psprintf("CORRECT\nExpected HBURST: %d\n Actual HBURST:   %d\n Count: %d\n", expected_HBURST, mon_tx.HBURST, count), UVM_LOW);
            // end
            // else begin
            //     n_mismatches++;
            //     uvm_report_info("Scoreboard", $psprintf("INCORRECT\nExpected HBURST: %d\n Actual HBURST:   %d\n Count: %d\n",expected_HBURST, mon_tx.HBURST, count), UVM_LOW);
            // end

            // HSIZE
            if (mon_tx.HSIZE == expected_HSIZE) begin
                n_matches++;
                uvm_report_info("Scoreboard", $psprintf("CORRECT\nExpected HSIZE: %d\n Actual HSIZE:   %d\n Count: %d\n", expected_HSIZE, mon_tx.HSIZE, count), UVM_LOW);
            end
            else begin
                n_mismatches++;
                uvm_report_info("Scoreboard", $psprintf("INCORRECT\nExpected HSIZE: %d\n Actual HSIZE:   %d\n Count: %d\n",expected_HSIZE, mon_tx.HSIZE, count), UVM_LOW);
            end

            // HADDR
            if (mon_tx.HADDR == expected_HADDR) begin
                n_matches++;
                uvm_report_info("Scoreboard", $psprintf("CORRECT\nExpected HADDR: %d\n Actual HADDR:   %d\n Count: %d\n", expected_HADDR, mon_tx.HADDR, count), UVM_LOW);
            end
            else begin
                n_mismatches++;
                uvm_report_info("Scoreboard", $psprintf("INCORRECT\nExpected HADDR: %d\n Actual HADDR:   %d\n Count: %d\n",expected_HADDR, mon_tx.HADDR, count), UVM_LOW);
            end

            // HWDATA
            if (mon_tx.HWDATA == expected_HWDATA) begin
                n_matches++;
                uvm_report_info("Scoreboard", $psprintf("CORRECT\nExpected HWDATA: %d\n Actual HWDATA:   %d\n Count: %d\n", expected_HWDATA, mon_tx.HWDATA, count), UVM_LOW);
            end
            else begin
                n_mismatches++;
                uvm_report_info("Scoreboard", $psprintf("INCORRECT\nExpected HWDATA: %d\n Actual HWDATA:   %d\n Count: %d\n",expected_HWDATA, mon_tx.HWDATA, count), UVM_LOW);
            end

            // HRDATA
            if (mon_tx.HRDATA == expected_HRDATA) begin
                n_matches++;
                uvm_report_info("Scoreboard", $psprintf("CORRECT\nExpected HRDATA: %d\n Actual HRDATA:   %d\n Count: %d\n", expected_HRDATA, mon_tx.HRDATA, count), UVM_LOW);
            end
            else begin
                n_mismatches++;
                uvm_report_info("Scoreboard", $psprintf("INCORRECT\nExpected HRDATA: %d\n Actual HRDATA:   %d\n Count: %d\n",expected_HRDATA, mon_tx.HRDATA, count), UVM_LOW);
            end

            // HWSTRB
            if (mon_tx.HWSTRB == expected_HWSTRB) begin
                n_matches++;
                uvm_report_info("Scoreboard", $psprintf("CORRECT\nExpected HWSTRB: %d\n Actual HWSTRB:   %d\n Count: %d\n", expected_HWSTRB, mon_tx.HWSTRB, count), UVM_LOW);
            end
            else begin
                n_mismatches++;
                uvm_report_info("Scoreboard", $psprintf("INCORRECT\nExpected HWSTRB: %d\n Actual HWSTRB:   %d\n Count: %d\n",expected_HWSTRB, mon_tx.HWSTRB, count), UVM_LOW);
            end

            if (count == period_cfg) count = 1;
            else count++;
        end
    endtask

    function void report_phase(uvm_phase phase);
        uvm_report_info("Scoreboard", $psprintf("Matches:    %d", n_matches), UVM_LOW);
        uvm_report_info("Scoreboard", $psprintf("Mismatches: %d", n_mismatches), UVM_LOW);
    endfunction

endclass : scoreboard
`endif