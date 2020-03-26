vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/digint/tinyfsm/archive/v0.3.2.zip"
    FILENAME "tinyfsm.zip"
    SHA512 44a8a1bf628bd5b8ca4b72cea06e51e286ae75d03718f71be30344820bcf3e3dedaa88d193cf5efede20e4c7b1c8926dd79a37c5cbe95ef010243e304130cfab
)

set(VCPKG_BUILD_TYPE release)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    PATCHES
        0001-tinyfsm-add-CMakeLists.txt.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH "share/tinyfsm")
file(INSTALL
    ${CMAKE_CURRENT_LIST_DIR}/tinyfsm-config.cmake
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/tinyfsm/
)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug)

# # Handle copyright
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/tinyfsm RENAME copyright)

