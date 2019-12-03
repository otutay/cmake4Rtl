set i 0

foreach data $argv {
    if {$i == 0 } {    
        puts "(TCL) project Name 2 open -> $data"
        open_project $data
        set i 1
   } else {
        puts "(TCL) ip 2 add -> $data"
        add_files -norecurse $data
        export_ip_user_files -of_objects  [get_files $data]
   }
}
update_compile_order -fileset sources_1

exit
