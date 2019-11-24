cmake_minimum_required(VERSION 3.0)

project(VHDLDeneme)

function(printList nameVar inVar)
    # message(STATUS "(${nameVar}) -> found files are : ${inVar}")   

    foreach (it IN ITEMS ${inVar})
        message(STATUS "(${nameVar}) -> found files are : ${it}")   
    endforeach()
    
endfunction() 

function(searchDirectory srcDirectory fileSuffix outputVar)
    file(GLOB dummyFiles ${srcDirectory}/*)

    foreach (it IN ITEMS ${dummyFiles})
        message(STATUS "searching for ${it}")
        file(GLOB dummySrc ${it}/*.${fileSuffix})
        list(APPEND outputVar ${dummySrc})
    endforeach ()


    # foreach (it IN ITEMS ${outputVar})
    #     message(STATUS "(Src) -> found files are : ${it}")   
    # endforeach()

    set(${outputVar} ${srcFiles} PARENT_SCOPE)
    # message(STATUS "(Design) -> ${outputVar}")
    
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
set(srcTcl "srcTcl")
set(srcIp "srcIp")
set(srcBd "srcBd")
set(srcConstraint "srcConstraint")

message(STATUS "adding src directories")
message(STATUS "VHD directories is -> ${srcRtl}")
message(STATUS "IP directories is -> ${srcIp}")
message(STATUS "Block design directories is -> ${srcBd}")
message(STATUS "Tcl directories is -> ${srcTcl}")

# file(GLOB dummyFiles ${srcRtl}/*)

searchDirectory(${srcRtl} "*vhd" vhdFiles)
printList("Design" ${${vhdFiles}})
# message(STATUS "(Design) -> ${vhdFiles}")
# # message(STATUS "")

# foreach (it IN ITEMS ${dummyFiles})
#     message(STATUS "searching for ${it}")
#     file(GLOB dummySrc ${it}/*.vhd)
#     list(APPEND vhdSrc ${dummySrc})
# endforeach ()


# foreach (it IN ITEMS ${vhdSrc})
#     message(STATUS "(Src) -> found files are : ${it}")   
# endforeach()

# message(STATUS "(Design) -> ${vhdSrc}")


# add_subdirectory(srcTcl)
# add_subdirectory(srcRtl)
# add_subdirectory(srcIp)
# add_subdirectory(srcConstraint)
# add_subdirectory(srcBd)


# message(STATUS "vhd files are ${vhdSrc}")

