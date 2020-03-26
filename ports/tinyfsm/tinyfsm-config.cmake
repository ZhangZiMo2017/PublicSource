include ("${CMAKE_CURRENT_LIST_DIR}/tinyfsm-targets.cmake")
add_library(tinyfsm::tinyfsm INTERFACE IMPORTED)
target_link_libraries(tinyfsm::tinyfsm INTERFACE tinyfsm)

get_target_property(_tinyfsm_INCLUDE_DIR tinyfsm INTERFACE_INCLUDE_DIRECTORIES)
set(tinyfsm_INCLUDE_DIR "${_tinyfsm_INCLUDE_DIR}")
