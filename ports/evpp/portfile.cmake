include(vcpkg_common_functions)

set(EVPP_VERSION 0.7.0)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Qihoo360/evpp
    # REF v${EVPP_VERSION}
    REF 86764566277574c2b73f300479ca46709385b2bb
    SHA512 31d8481a44b3d911c07be89bde883215ce30205ab3855ddd35985822dd455a02c00621961382347415f8471cc989619ef62ad4151d9c82d383e8568c6714f29c
    HEAD_REF master
    PATCHES
        fix-rapidjson-1-1.patch
        fix-linux-build.patch
)
file(REMOVE_RECURSE ${SOURCE_PATH}/3rdparty/rapidjson ${SOURCE_PATH}/3rdparty/concurrentqueue)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS -DEVPP_VCPKG_BUILD=ON
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
