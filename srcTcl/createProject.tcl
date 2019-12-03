puts "(TCL) project Name -> [lindex $argv 0]"
puts "(TCL) project Location -> [lindex $argv 1]"
puts "(TCL) fpga part name ->  [lindex $argv 2]"
puts "(TCL) fpga board name -> [lindex $argv 3]"

create_project [lindex $argv 0] [lindex $argv 1] -part [lindex $argv 2]
set_property board_part [lindex $argv 3] [current_project]
exit
#create_project
