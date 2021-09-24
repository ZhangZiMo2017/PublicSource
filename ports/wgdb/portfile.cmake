vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO priitj/whitedb
    REF 11c962703dc7a89001d24ac0b1661729e545da00
    SHA512
        658762e30cbc57a5ccdfb687829a89c5374f142fe7f67b3eaa8cf51800ca599d586f353fa47482e9d0e67ddbbdc81977bb4b98890a96975aeb87bf70436b06b5
    PATCHES
    001-cmake-build.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

# # Moves all .cmake files from /debug/share/wgdb/ to /share/wgdb/
# # See /docs/maintainers/vcpkg_fixup_cmake_targets.md for more details
# vcpkg_fixup_cmake_targets(CONFIG_PATH cmake TARGET_PATH share/wgdb)

# # Handle copyright
file(INSTALL ${SOURCE_PATH}/GPLLICENCE DESTINATION ${CURRENT_PACKAGES_DIR}/share/wgdb RENAME copyright)
