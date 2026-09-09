# Recipe created by recipetool, then completed manually per AESD Assignment 6 Part 2.
SUMMARY = "AESD socket server assignment application"
LICENSE = "CLOSED"

SRC_URI = "git://github.com/prashantgautamofficial/aeld-assignment-3-and-later.git;protocol=https;branch=main"

# Pin to an immutable commit hash from your source repo — never a branch name.
# Confirm this exactly matches: git log -1 --format="%H" in the source repo.
SRCREV = "36d074cfce6a2eff63434e9e904a4f125748e549"

S = "${WORKDIR}/git/server"

inherit update-rc.d

INITSCRIPT_PACKAGES = "${PN}"
INITSCRIPT_NAME:${PN} = "aesdsocket-start-stop"


do_configure () {
	:
}

do_compile () {
	oe_runmake CC="${CC}" LDFLAGS="${LDFLAGS}"
}

do_install () {
	install -d ${D}${bindir}
	install -m 0755 ${S}/aesdsocket ${D}${bindir}/aesdsocket

	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${S}/aesdsocket-start-stop ${D}${sysconfdir}/init.d
}

FILES:${PN} += "${sysconfdir}/init.d/aesdsocket-start-stop"
