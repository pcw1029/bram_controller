set script_path [ file dirname [ file normalize [ info script ] ] ]
puts $script_path

create_project bram_controller $script_path -part xczu3eg-sfvc784-1-e
add_files -norecurse $script_path/src/bram_controller.v
update_compile_order -fileset sources_1

ipx::package_project -root_dir $script_path -vendor user.org -library user -taxonomy /UserIP

ipx::merge_project_changes files [ipx::current_core]

set_property core_revision 2 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property  ip_repo_paths  $script_path [current_project]
update_ip_catalog

close_project

create_project bram_controller $script_path/../test_bram_controller -part xczu3eg-sfvc784-1-e

create_bd_design "design_1"
update_compile_order -fileset sources_1

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0
endgroup
set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.Enable_B {Use_ENB_Pin} CONFIG.Use_RSTB_Pin {true} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Write_Rate {50} CONFIG.Port_B_Enable_Rate {100} CONFIG.EN_SAFETY_CKT {false}] [get_bd_cells blk_mem_gen_0]

set_property  ip_repo_paths  /home/pcw1029/projects/MTTS/hw/bram_controller [current_project]
update_ip_catalog

create_bd_cell -type ip -vlnv user.org:user:bram_controller:1.0 bram_controller_0
create_bd_cell -type ip -vlnv user.org:user:bram_controller:1.0 bram_controller_1

connect_bd_net [get_bd_pins bram_controller_0/bram_en] [get_bd_pins blk_mem_gen_0/ena]
connect_bd_net [get_bd_pins bram_controller_0/bram_rddata] [get_bd_pins blk_mem_gen_0/douta]
connect_bd_net [get_bd_pins bram_controller_0/bram_wrdata] [get_bd_pins blk_mem_gen_0/dina]
connect_bd_net [get_bd_pins bram_controller_0/bram_we] [get_bd_pins blk_mem_gen_0/wea]
connect_bd_net [get_bd_pins bram_controller_0/bram_addr] [get_bd_pins blk_mem_gen_0/addra]
connect_bd_net [get_bd_pins bram_controller_0/bram_clk] [get_bd_pins blk_mem_gen_0/clka]
connect_bd_net [get_bd_pins bram_controller_0/bram_rst] [get_bd_pins blk_mem_gen_0/rsta]

connect_bd_net [get_bd_pins bram_controller_1/bram_en] [get_bd_pins blk_mem_gen_0/enb]
connect_bd_net [get_bd_pins bram_controller_1/bram_rddata] [get_bd_pins blk_mem_gen_0/doutb]
connect_bd_net [get_bd_pins bram_controller_1/bram_wrdata] [get_bd_pins blk_mem_gen_0/dinb]
connect_bd_net [get_bd_pins bram_controller_1/bram_we] [get_bd_pins blk_mem_gen_0/web]
connect_bd_net [get_bd_pins bram_controller_1/bram_addr] [get_bd_pins blk_mem_gen_0/addrb]
connect_bd_net [get_bd_pins bram_controller_1/bram_clk] [get_bd_pins blk_mem_gen_0/clkb]
connect_bd_net [get_bd_pins bram_controller_1/bram_rst] [get_bd_pins blk_mem_gen_0/rstb]

startgroup
make_bd_pins_external  [get_bd_cells bram_controller_0]
make_bd_intf_pins_external  [get_bd_cells bram_controller_0]
endgroup
delete_bd_objs [get_bd_intf_nets bram_controller_0_BRAM_PORTA] [get_bd_intf_ports BRAM_PORTA_0]
delete_bd_objs [get_bd_intf_ports BRAM_PORTA_0]

connect_bd_net [get_bd_ports system_clk_0] [get_bd_pins bram_controller_1/system_clk]
connect_bd_net [get_bd_ports reset_0] [get_bd_pins bram_controller_1/reset]
startgroup
make_bd_pins_external  [get_bd_cells bram_controller_1]
make_bd_intf_pins_external  [get_bd_cells bram_controller_1]
endgroup
delete_bd_objs [get_bd_intf_nets bram_controller_1_BRAM_PORTA] [get_bd_intf_ports BRAM_PORTA_1]
delete_bd_objs [get_bd_intf_ports BRAM_PORTA_1]

regenerate_bd_layout
save_bd_design


make_wrapper -files [get_files /home/pcw1029/projects/MTTS/hw/test_bram_controller/bram_controller.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse /home/pcw1029/projects/MTTS/hw/test_bram_controller/bram_controller.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v


add_files -norecurse /home/pcw1029/projects/MTTS/hw/bram_controller/src/tb_bram_controller.v
update_compile_order -fileset sources_1

