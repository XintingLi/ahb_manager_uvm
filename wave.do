onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ahb_manager/ahb_if/HCLK
add wave -noupdate /tb_ahb_manager/ahb_if/HRESETn
add wave -noupdate -color Yellow /tb_ahb_manager/ahb_if/HADDR
add wave -noupdate /tb_ahb_manager/ahb_if/HSEL
add wave -noupdate -color Pink /tb_ahb_manager/ahb_if/HWRITE
add wave -noupdate -color Orange /tb_ahb_manager/ahb_if/HRDATA
add wave -noupdate -color Cyan /tb_ahb_manager/ahb_if/HWDATA
add wave -noupdate -color Pink /tb_ahb_manager/bus_if/wen
add wave -noupdate -color Pink /tb_ahb_manager/bus_if/ren
add wave -noupdate -color Yellow /tb_ahb_manager/bus_if/addr
add wave -noupdate -color Cyan /tb_ahb_manager/bus_if/wdata
add wave -noupdate -color Orange /tb_ahb_manager/bus_if/rdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {27706061 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {58176300 ps}
