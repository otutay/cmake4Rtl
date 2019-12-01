
set i 0

foreach data $argv {
    if {$i == 0 } {    
        puts "project Name 2 open -> $data"
        open_project $data
   } else {
        puts "src file 2 add -> $data"
        add_files -norecurse $data     
   }
   set i 2
}
update_compile_order -fileset sources_1
#puts "project Name -> [lindex $argv 0]"


#puts "project Location -> [lindex $argv 1]"
#puts "project Location -> [lindex $argv 2]"
#puts "project Location -> [lindex $argv 3]"

#open_project [lindex $argv 0]

exit

