include(vcpkg_common_functions)
 
 set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/acl/3.5.1-4229ba226c)

# # Specifies if the port install should fail immediately given a condition
# vcpkg_fail_port_install(MESSAGE "acl currently only supports Linux and Mac platforms" ON_TARGET "Windows")

vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/acl-dev/acl/archive/v3.5.1-1.zip"
    FILENAME "acl-3.5.1.zip"
    SHA512 6ec6f129884876842354976dee1c00b7c06047de66631dbb07a3a6cfba02055e719cc564ab5f031a81266d9561e6b566ae4deb3ffe072ecd9b1188089fffdc06
)

set(ACL_VERSION 3.5.1)

set(ACL_BUILD_SHARED "YES")

# if (VCPKG_CRT_LINKAGE STREQUAL static)
    # set(DYNAMIC_PATCH "build_dll.patch")
# endif()

message(STATUS "Begin to extract files ...")
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    REF ${ACL_VERSION}
    ARCHIVE ${ARCHIVE} 
    # PATCHES
    #     ${DYNAMIC_PATCH}
)

if (WIN32)
    message(STATUS "current platform: Windows")

    if (VCPKG_TARGET_ARCHITECTURE MATCHES "x86")
        set(BUILD_ARCH "Win32")
        set(OUTPUT_DIR "Win32")
    elseif (VCPKG_TARGET_ARCHITECTURE MATCHES "x64")
        set(BUILD_ARCH "x64")
    else()
        message(FATAL_ERROR "Unsupported architecture: ${VCPKG_TARGET_ARCHITECTURE}")
    endif()

    message(STATUS "build on windows")

    if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
        set(Release_Configuration ReleaseDll)
        set(Debug_Configuration DebugDll)
    elseif (VCPKG_LIBRARY_LINKAGE STREQUAL static)
        set(Release_Configuration Release)
        set(Debug_Configuration Debug)
    endif()

    vcpkg_build_msbuild(
        PROJECT_PATH ${SOURCE_PATH}/lib_acl/lib_acl_vc2015.vcxproj
        PLATFORM ${BUILD_ARCH}
        RELEASE_CONFIGURATION ${Release_Configuration}
        DEBUG_CONFIGURATION ${Debug_Configuration}
        )

    vcpkg_build_msbuild(
        PROJECT_PATH ${SOURCE_PATH}/lib_protocol/lib_protocol_vc2015.vcxproj
        PLATFORM ${BUILD_ARCH}
        RELEASE_CONFIGURATION ${Release_Configuration}
        DEBUG_CONFIGURATION ${Debug_Configuration}
    )

    vcpkg_build_msbuild(
        PROJECT_PATH ${SOURCE_PATH}/lib_acl_cpp/lib_acl_cpp_vc2015.vcxproj
        PLATFORM ${BUILD_ARCH}
        RELEASE_CONFIGURATION ${Release_Configuration}
        DEBUG_CONFIGURATION ${Debug_Configuration}
    )
else()
    message(STATUS "current plateform: Apple or UNIX-like")
endif()


# # Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/acl RENAME copyright)
file(COPY ${SOURCE_PATH}/lib_acl/include/ DESTINATION ${CURRENT_PACKAGES_DIR}/include/)
file(COPY ${SOURCE_PATH}/lib_acl_cpp/include/ DESTINATION ${CURRENT_PACKAGES_DIR}/include/)
file(COPY ${SOURCE_PATH}/lib_protocol/include/ DESTINATION ${CURRENT_PACKAGES_DIR}/include/)

# # Handle libraries

if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    file(COPY ${SOURCE_PATH}/lib_acl/lib_acl_d.dll DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)
    file(COPY ${SOURCE_PATH}/lib_acl/lib_acl_d.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
    file(COPY ${SOURCE_PATH}/lib_acl/lib_acl.dll DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
    file(COPY ${SOURCE_PATH}/lib_acl/lib_acl.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib)

    file(COPY ${SOURCE_PATH}/lib_protocol/lib_protocol_d.dll DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)
    file(COPY ${SOURCE_PATH}/lib_protocol/lib_protocol_d.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
    file(COPY ${SOURCE_PATH}/lib_protocol/lib_protocol.dll DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
    file(COPY ${SOURCE_PATH}/lib_protocol/lib_protocol.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib)


    file(COPY ${SOURCE_PATH}/lib_acl_cpp/lib_acl_cpp_d.dll DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)
    file(COPY ${SOURCE_PATH}/lib_acl_cpp/lib_acl_cpp_d.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
    file(COPY ${SOURCE_PATH}/lib_acl_cpp/lib_acl_cpp.dll DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
    file(COPY ${SOURCE_PATH}/lib_acl_cpp/lib_acl_cpp.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
# elseif (VCPKG_LIBRARY_LINKAGE STREQUAL static)
#     file(COPY ${SOURCE_PATH}/lib_acl/lib_acl_vc2015_d.dll DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)
#     file(COPY ${SOURCE_PATH}/lib_acl/lib_acl_d.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
#     file(COPY ${SOURCE_PATH}/lib_acl/lib_acl.dll DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
#     file(COPY ${SOURCE_PATH}/lib_acl/lib_acl.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib)

#     file(COPY ${SOURCE_PATH}/lib_protocol/lib_protocol_d.dll DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)
#     file(COPY ${SOURCE_PATH}/lib_protocol/lib_protocol_d.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
#     file(COPY ${SOURCE_PATH}/lib_protocol/lib_protocol.dll DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
#     file(COPY ${SOURCE_PATH}/lib_protocol/lib_protocol.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib)


#     file(COPY ${SOURCE_PATH}/lib_acl_cpp/lib_acl_cpp_d.dll DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)
#     file(COPY ${SOURCE_PATH}/lib_acl_cpp/lib_acl_cpp_d.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
#     file(COPY ${SOURCE_PATH}/lib_acl_cpp/lib_acl_cpp.dll DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
#     file(COPY ${SOURCE_PATH}/lib_acl_cpp/lib_acl_cpp.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
endif()

#vcpkg_copy_pdbs()

# file(COPY ${DBG_BINARY_DIR}/lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug)
# file(COPY ${REL_BINARY_DIR}/lib DESTINATION ${CURRENT_PACKAGES_DIR})
# # Post-build test for cmake libraries
# vcpkg_test_cmake(PACKAGE_NAME acl)
