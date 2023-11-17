DESCRIPTION = "Custom flash layout file to add a/b partitions"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "file://flash_mender.xml \
           file://flash_l4t_nvme.xml"

INHIBIT_DEFAULT_DEPS = "1"
COMPATIBLE_MACHINE = "(tegra)"

inherit l4t_bsp nopackages
FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}-${@d.getVar('L4T_VERSION').replace('.', '-')}:"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${datadir}/ab-flash-layout
    install -m 0644 ${S}/flash_mender.xml ${D}${datadir}/ab-flash-layout/
    install -m 0644 ${S}/flash_l4t_nvme.xml ${D}${datadir}/ab-flash-layout/
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
