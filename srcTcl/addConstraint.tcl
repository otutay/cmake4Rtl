set i 0

foreach data $argv {
    if {$i == 0 } {    
        puts "(TCL) project Name 2 open -> $data"
        open_project $data
        set i 1
    } else {
        puts "(TCL) Constraint 2 add -> $data"
        update_compile_order -fileset sources_1
        add_files -fileset constrs_1 -norecurse $data
   }
}
update_compile_order -fileset sources_1

exit
