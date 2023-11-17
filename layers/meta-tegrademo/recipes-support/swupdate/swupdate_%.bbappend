FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

PACKAGECONFIG ??= ""
PACKAGECONFIG[hawkbit] = ",,,,,"

CBOOTFILES = "\
    file://0001-Add-support-for-custom-bootloader.patch \
    file://disable-uboot.cfg \
    file://enable-cboot.cfg \
    file://swupdate-bootloader-interface-cboot.sh \
"

CBOOTFILES:tegra210 = "file://enable-uboot.cfg"

SRC_URI:append:tegra = "\
    file://disable-mtd.cfg \
    file://disable-cfi.cfg \
    ${CBOOTFILES} \
    file://systemd.cfg \
    file://hash.cfg \
    file://disable_http_server.cfg \
    file://part-format.cfg \
    file://archive.cfg \
    file://signed-images.cfg \
"

install_cboot_interface() {
    install -d ${D}${sbindir}
    install -m 0755 ${WORKDIR}/swupdate-bootloader-interface-cboot.sh ${D}${sbindir}/swupdate-bootloader-interface
}
install_cboot_interface:tegra210() {
    :
}

DEPENDS += "e2fsprogs"

do_install:append() {
    install_cboot_interface
    rm -rf ${D}${libdir}/swupdate
}

FILES:${PN} += "${sbindir}/swupdate-bootloader-interface"
CBOOTTOOLS = "tegra-boot-tools"
CBOOTTOOLS:tegra210 = "u-boot-default-env"
RDEPENDS:${PN} += "${CBOOTTOOLS} swupdate-machine-config"
PACKAGE_ARCH = "${MACHINE_ARCH}"

KERNEL_ROOTSPEC = "root=PARTLABEL=${bootpart_label} rw rootwait"
