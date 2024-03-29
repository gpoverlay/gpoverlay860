# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library for MPEG TS/DVB PSI tables decoding and generation"
HOMEPAGE="https://www.videolan.org/libdvbpsi"
SRC_URI="https://download.videolan.org/pub/${PN}/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
# Sublot == libdvbpsi.so major
SLOT="0/10"
KEYWORDS="~alpha amd64 arm arm64 ~loong ppc ppc64 ~riscv sparc x86"
IUSE="doc static-libs"

BDEPEND="
	doc? (
		app-text/doxygen
		>=media-gfx/graphviz-2.26
	)"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	sed -e '/CFLAGS/s:-O2::' -e '/CFLAGS/s:-O6::' -e '/CFLAGS/s:-Werror::' -i configure || die
	default
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--enable-release
}

src_compile() {
	default
	use doc && emake doc
}

src_install() {
	use doc && local HTML_DOCS=( doc/doxygen/html/. )
	default
	find "${ED}" -name '*.la' -delete || die
}
