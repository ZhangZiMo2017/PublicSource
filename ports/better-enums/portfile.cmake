vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/aantron/better-enums/archive/0.11.1.zip"
    FILENAME "better-enums.zip"
    SHA512 61928591ee26926f0f870e711a1f8e70e92472f1b899b0c2d31f9124d841fd24af5552a7bb8893d58157459a9e8b4e29fae4e685ab5ff5872769df2df6da8fcd
)

set(VCPKG_BUILD_TYPE release)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    PATCHES 0001-add-CMakeLists.txt.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
)


vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/doc/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/better-enums RENAME copyright)