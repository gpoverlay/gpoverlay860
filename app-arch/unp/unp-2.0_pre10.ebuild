# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 strip-linguas

DESCRIPTION="Script for unpacking various file formats"
HOMEPAGE="https://packages.qa.debian.org/u/unp.html"
MY_PV="${PV/_pre/$'\x7e'pre}"
SRC_URI="mirror://debian/pool/main/u/unp/${PN}_${MY_PV}.tar.xz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="nls"

DEPEND="nls? ( sys-devel/gettext )"

RDEPEND="${DEPEND}
	dev-lang/perl"

# tests in upstream tarball are missing sample files
RESTRICT="test"

src_compile() {
	if use nls; then
		strip-linguas -i .
		if [ -n "$LINGUAS" ]; then
			emake -C po MOFILES="${LINGUAS// /.po }.po"
		else
			emake -C po
		fi
	fi
}

src_install() {
	dobin unp
	dosym unp /usr/bin/ucat
	doman debian/unp.1
	dodoc debian/changelog debian/README.Debian
	newbashcomp debian/unp.bash-completion unp

	if use nls; then
		if [ -n "$LINGUAS" ]; then
			emake -C po MOFILES="${LINGUAS// /.mo }.mo" DESTDIR="${D}" install
		else
			emake -C po DESTDIR="${D}" install
		fi
	fi
}
