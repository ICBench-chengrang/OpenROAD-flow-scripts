#!/usr/bin/tclsh

set FLOWDIR "./flow"
set RESDIR "${FLOWDIR}/results/smic180/m3/base/"
set PDK "${FLOWDIR}/platforms/smic180"

# Read lef
read_lef "${PDK}/data/tech/smic18_6lm.lef"

# Read verilog
read_verilog "${FLOWDIR}/results/smic180/m3/base/1_synth.v"

link_design "CORTEXM3"
#read_sdc "${FLOWDIR}/results/smic180/m3/base/1_synth.sdc"
set num_instances [llength [get_cells -hier *]]
puts "number instances in verilog is $num_instances"

initialize_floorplan -utilization 30 -aspect_ratio 1.0 -core_space 2 -site smic18site
make_tracks 

place_pins -hor_layers METAL3 -ver_layers METAL4 -random
write_pin_placement "${FLOWDIR}/results/smic180/m3/base/fp.io.txt" -placed_status

tapcell \
   -distance 30 \
   -tapcell_master "FILL4" \
   -tap_prefix "WELLTAP" \
   -endcap_master "FILL4" \
   -endcap_prefix "ENDCAP" \
   -tap_nwintie_master "FILL4" \
   -tap_nwin2_master "FILL2" \
   -tap_nwin3_master "FILL1" \
   -tap_nwouttie_master "FILL4" \
   -tap_nwout2_master "FILL2" \
   -tap_nwout3_master "FILL1" \
   -cnrcap_nwin_master "FILL4" \
   -cnrcap_nwout_master "FILL4" \
   -incnrcap_nwin_master "FILL4" \
   -incnrcap_nwout_master "FILL4"

add_global_connection -net VDD -pin_pattern {^VDD$} -power
add_global_connection -net VSS -pin_pattern {^VSS$} -ground
set_voltage_domain -power VDD -ground VSS
define_pdn_grid -name "Core"
add_pdn_stripe -followpins -layer METAL1 -width 0.8
add_pdn_stripe -layer METAL6 -width 4 -spacing 2 -pitch 20 -extend_to_boundary
add_pdn_connect -layers {METAL1 METAL6}
pdngen

## pre report
#
#puts "\n=========================================================================="
#puts "report_checks"
#puts "--------------------------------------------------------------------------"
#report_checks -fields {input slew capacitance} -format full_clock
#
#puts "\n=========================================================================="
#puts "report_tns"
#puts "--------------------------------------------------------------------------"
#report_tns
#
#puts "\n=========================================================================="
#puts "report_wns"
#puts "--------------------------------------------------------------------------"
#report_wns
#
#puts "\n=========================================================================="
#puts "report_design_area"
#puts "--------------------------------------------------------------------------"
#report_design_area
#
  # write output
 #1_synth.v
write_def "${RESDIR}/floorplan.def"
write_verilog "${RESDIR}/floorplan.v"
#write_sdc $::env(RESULTS_DIR)/2_floorplan.sdc
