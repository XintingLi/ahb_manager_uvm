import uvm_pkg::*;
// import ahb_pkg::*;
`include "ahb_if.svh"
`include "bus_if.svh"
`include "ahb_manager_test.svh"
`include "ahb_manager.sv"
// `inlcude "ahb_pkg.sv"

module tb_ahb_manager();
    logic clk;

    // generate clk
    initial begin
        clk = 0;
        forever #10 clk = !clk;
    end

    ahb_if ahb_if();
    bus_if b_if();

    // clock and reset signals are shared between interfaces
    assign ahb_if.clk = clk;
    assign b_if.clk = clk;
    assign ahb_if.n_rst = ahb_if.n_rst;
    assign b_if.n_rst = ahb_if.n_rst;

    // Initialize DUT
    // ahb_manager DUT(b_if.b_p_if, ahb_if);

    initial begin
        uvm_config_db#(virtual ahb_if)::set(null, "", "ahb_manager_vif", ahb_if);
        uvm_config_db#(virtual bus_if)::set(null, "", "bus_vif", b_if);
        run_test("base_test");
    end

endmodule : tb_ahb_manager