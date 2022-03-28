include(vcpkg_build_make)
 
if (VCPKG_TARGET_IS_WINDOWS)
    set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/acl/3.5.3-0-4229ba226c)
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO acl-dev/acl
    REF master
    SHA512 879aae1ff2c263a088a42ab1c28e3e5791005491948222fb410fb69b8128ada94e40848d3f361d7adebeed02fa1f83b3092c47fce39f70635dea4b10ae67a5fc
    HEAD_REF master
)

# vcpkg_download_distfile(ARCHIVE
#     URLS "https://github.com/acl-dev/acl/archive/refs/tags/v3.5.3-4.tar.gz"
#     FILENAME "v3.5.4-0.tar.gz"
#     SHA512 ea5505816fa3a98f05a6c19769d21388fa9e3827464461d774da682fd34808e2d96632adb0449e0c79616e25cdc9e766573bd048886c02d5f2683689b9e99f17
# )

set(ACL_VERSION 3.5.4-0)

set(ACL_BUILD_SHARED "YES")

message(STATUS "Begin to extract files ...")
message(STATUS "ARCHIVE: ${ARCHIVE}")
if (VCPKG_TARGET_IS_LINUX)
    
    vcpkg_extract_source_archive_ex(
        OUT_SOURCE_PATH SOURCE_PATH
        REF ${ACL_VERSION}
        ARCHIVE ${ARCHIVE} 
        PATCHES 
            fix_linux_build.patch
    )
else()

    

    # vcpkg_extract_source_archive_ex(
    #     OUT_SOURCE_PATH SOURCE_PATH
    #     REF ${ACL_VERSION}
    #     ARCHIVE ${ARCHIVE} 
    # )
endif()

if (VCPKG_TARGET_IS_WINDOWS)
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

elseif(VCPKG_TARGET_IS_OSX)

    message(STATUS "current plateform: Apple or UNIX-like")

    vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    DISABLE_PARALLEL_CONFIGURE
    NO_CHARSET_FLAG
    OPTIONS
        -DACL_BUILD_SHARED="YES"
    )

    vcpkg_build_cmake()
elseif(VCPKG_TARGET_IS_LINUX)
	message(STATUS "current plateform: Linux")
	
	vcpkg_configure_make(
	    SOURCE_PATH ${SOURCE_PATH}
	    SKIP_CONFIGURE
	    NO_DEBUG
	    PRERUN_SHELL linux_build.sh
	)
endif()


# # Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/acl RENAME copyright)
file(COPY ${SOURCE_PATH}/lib_acl/include/ DESTINATION ${CURRENT_PACKAGES_DIR}/include/)
file(COPY ${SOURCE_PATH}/lib_acl_cpp/include/ DESTINATION ${CURRENT_PACKAGES_DIR}/include/)
file(COPY ${SOURCE_PATH}/lib_protocol/include/ DESTINATION ${CURRENT_PACKAGES_DIR}/include/)

# # Handle libraries

if (VCPKG_TARGET_IS_WINDOWS)
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
    endif()
elseif (VCPKG_TARGET_IS_OSX)
    set(DBG_BINARY_DIR ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg)
    file(COPY ${DBG_BINARY_DIR}/lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug)

    set(REL_BINARY_DIR ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel)
    file(COPY ${REL_BINARY_DIR}/lib DESTINATION ${CURRENT_PACKAGES_DIR})
elseif (VCPKG_TARGET_IS_LINUX)
    file(COPY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}/shared_libs/libacl.so DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
    file(COPY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}/shared_libs/libprotocol.so DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
    file(COPY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}/shared_libs/libacl_cpp.so DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
endif()