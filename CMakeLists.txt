cmake_minimum_required(VERSION 3.0)

project(VHDLDeneme)

function(searchDirectory srcDirectory fileSuffix outputVar)
    file(GLOB dummyFiles ${srcDirectory}/*)
    foreach (it IN ITEMS ${dummyFiles})
        if(IS_DIRECTORY ${it})
            message(STATUS "searching for ${it} (a subdirectory)")
            file(GLOB dummySrc ${it}/*.${fileSuffix})
            list(APPEND outputVar ${dummySrc})
        else()
            message(STATUS "adding for ${it} to file list")
            list(APPEND outputVar ${it})
        endif()
    endforeach ()

    set(${outputVar} PARENT_SCOPE)
    
endfunction()

function(printList nameVar inVar)

    foreach (it IN ITEMS ${inVar})
        message(STATUS "(${nameVar}) -> found files are : ${it}")   
    endforeach()
    
endfunction() 

#setting compile,simulate,sythesis directives
set(target "xilinx")
set(compile FALSE)
set(simulate TRUE)
set(synthesize FALSE)

message(STATUS "project directives are as follows ---> ")
message(STATUS "target is ${target}")
message(STATUS "compile ${compile}")
message(STATUS "simulate ${simulate}")
message(STATUS "synthesize ${synthesize}")

set(srcRtl "srcRtl")
set(srcConstraint "srcConstraint")
set(srcBd "srcBd")
set(srcTcl "srcTcl")
set(srcIp "srcIp")



message(STATUS "adding src directories")
message(STATUS "VHD directories is -> ${srcRtl}")
message(STATUS "IP directories is -> ${srcIp}")
message(STATUS "Block design directories is -> ${srcBd}")
message(STATUS "Tcl directories is -> ${srcTcl}")


searchDirectory(${srcRtl} "vhd" vhdFiles)
printList("Design" "${vhdFiles}")

searchDirectory(${srcConstraint} "xdc" xdcFiles)
printList("Constraint" "${xdcFiles}")

searchDirectory(${srcBd} "bd" bdFiles)
printList("Block Design" "${bdFiles}")


searchDirectory(${srcIp} "xci" ipFiles)
printList("Ip cores of design" "${ipFiles}")

message(STATUS "deneme")