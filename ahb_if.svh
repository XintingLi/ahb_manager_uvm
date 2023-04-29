`ifndef AHB_IF_SVH
`define PWM_IF_SVH

`include "ahb_manager_if.sv"

interface ahb_if #(parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32);
    // Inputs
    logic clk;
    logic n_rst;

    // Bus interface
    ahb_manager_if a_m_if(clk, n_rst);

endinterface : ahb_if

`endif