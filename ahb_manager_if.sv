`ifndef AHB_MANAGER_IF_SV
`define AHB_MANAGER_IF_SV

interface ahb_manager_if #(
    parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32
)(
    input HCLK,
    input HRESETn
);

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

    assign HREADY = HREADYOUT;

    modport ahb_manager(
        input HCLK, HRESETn,
        input HREADY, HRESP, HRDATA,
        output HWRITE, HMASTLOCK, HTRANS,
        HBURST, HSIZE, HADDR, HWDATA, HWSTRB, HSEL
    );

endinterface

`endif