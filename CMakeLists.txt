cmake_minimum_required(VERSION 3.0)



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

function(creatingDirectory nameOfDirectory subDirs)
	if(NOT ${subDirs} MATCHES " ")
		message(STATUS ${CMAKE_CURRENT_SOURCE_DIR}/${nameOfDirectory}/${subDirs})
		file(MAKE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${nameOfDirectory}/${subDirs})
	else()
		message(STATUS ${CMAKE_CURRENT_SOURCE_DIR}\${nameOfDirectory})
		file(MAKE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${nameOfDirectory})
	endif()
endfunction()

macro(stripName fileNames suffix outputVar)
    get_filename_component(dummyVar ${it} NAME_WE)
    set(outputVar ${dummyVar})
endmacro()


function(copyFiles fileNames suffix relLoc)
    foreach(it IN ITEMS ${fileNames})
        stripName(${it} ${suffix} dummyVar)
        message(STATUS "files copied to -> ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}/${relLoc}/${dummyVar}/")
        file(COPY ${it} DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}/${relLoc}/${dummyVar}/)
    endforeach()
endfunction()

function(createProject tclLoc fpgaName boardName)
    message(STATUS "Vivado Project will be created in ${PROJECT_NAME} and with tcl ${tclLoc}")
	if(WIN32)
		execute_process(COMMAND cmd /c vivado -mode tcl -source ${CMAKE_CURRENT_SOURCE_DIR}/${tclLoc}/createProject.tcl -tclargs ${PROJECT_NAME} ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}/project ${fpgaName} ${boardName})
	else()
		execute_process(COMMAND vivado -mode tcl -source ${CMAKE_CURRENT_SOURCE_DIR}/${tclLoc}/createProject.tcl -tclargs ${PROJECT_NAME} ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}/project ${fpgaName} ${boardName})
	endif()
endfunction()

function(addSrc2Project tclLoc srcFiles)
    message(STATUS "RTL source files will be added to the xilinx project")
	if(WIN32)
		execute_process(COMMAND cmd /c vivado -mode tcl -source ${CMAKE_CURRENT_SOURCE_DIR}/${tclLoc}/addRtl.tcl -tclargs ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}/project/${PROJECT_NAME}.xpr ${srcFiles})
	else()
		execute_process(COMMAND vivado -mode tcl -source ${CMAKE_CURRENT_SOURCE_DIR}/${tclLoc}/addRtl.tcl -tclargs ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}/project/${PROJECT_NAME}.xpr ${srcFiles})
	endif()
endfunction()

function(addConst2Project tclLoc srcFiles)
    message(STATUS "Constraint source files will be added to the xilinx project")
	if(WIN32)
		execute_process(COMMAND cmd /c vivado -mode tcl -source ${CMAKE_CURRENT_SOURCE_DIR}/${tclLoc}/addConstraint.tcl -tclargs ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}/project/${PROJECT_NAME}.xpr ${srcFiles})
	else()
		execute_process(COMMAND vivado -mode tcl -source ${CMAKE_CURRENT_SOURCE_DIR}/${tclLoc}/addConstraint.tcl -tclargs ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}/project/${PROJECT_NAME}.xpr ${srcFiles})
	endif()
endfunction()

function(addIP2Project tclLoc relLoc suffix)
    message(STATUS "IP/blockDesign files will be added to the xilinx project")
    set(dummyDirect "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}/${relLoc}")
    searchDirectory(${dummyDirect} ${suffix} dumyFiles)
    printList("add ip/blockDesign -> " "${dumyFiles}")
	if(WIN32)
		execute_process(COMMAND cmd /c vivado -mode tcl -source ${CMAKE_CURRENT_SOURCE_DIR}/${tclLoc}/addIp.tcl -tclargs ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}/project/${PROJECT_NAME}.xpr ${dumyFiles})
	else()
		execute_process(COMMAND vivado -mode tcl -source ${CMAKE_CURRENT_SOURCE_DIR}/${tclLoc}/addIp.tcl -tclargs ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}/project/${PROJECT_NAME}.xpr ${dumyFiles})
	endif()
endfunction()


project(VHDLDeneme)
#setting compile,simulate,sythesis directives
set(FPGAName "xc7z045ffg900-2")
set(boardName "xilinx.com:zc706:part0:1.4")


# set(compile FALSE)
# set(simulate TRUE)
# set(synthesize FALSE)

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

searchDirectory(${srcTcl} "tcl" tclFiles)
printList("TCL files to create project" "${tclFiles}")

message(STATUS "(PROJECT LOC CREATE) creating file with the name ${PROJECT_NAME}")
creatingDirectory(${PROJECT_NAME} " ")

message(STATUS "(COPY IP) copying IP file in to the project file")
copyFiles("${ipFiles}" "xci" "ip")

message(STATUS "(COPY Block Design) copying BD files in to the project file")
copyFiles("${bdFiles}" "bd" "blkdesign")


createProject(${srcTcl} ${FPGAName} ${boardName})


addSrc2Project(${srcTcl} "${vhdFiles}")
addConst2Project(${srcTcl} "${xdcFiles}")

addIP2Project(${srcTcl} "ip" "xci")
addIP2Project(${srcTcl} "blkdesign" "bd")


message(STATUS "deneme")
