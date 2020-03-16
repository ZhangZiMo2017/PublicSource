vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/aantron/better-enums/archive/0.11.1.zip"
    FILENAME "better-enums.zip"
    SHA512 c748b7731a2738dcd7bbf3c746b6131d67a557fd792fa272fd348466245e035a9e7a8ca65c7243d4e8c4ab2a628164b9148385dbbf1acd45324d2f6ffeecc466
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