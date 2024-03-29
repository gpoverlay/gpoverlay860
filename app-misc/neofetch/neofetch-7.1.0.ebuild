# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit prefix

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/dylanaraps/${PN}/archive/${PV}/${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 ~ppc64 x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dylanaraps/neofetch.git"
fi

DESCRIPTION="Simple information system script"
HOMEPAGE="https://github.com/dylanaraps/neofetch"
LICENSE="MIT"
SLOT="0"
IUSE="X"

RDEPEND="sys-apps/pciutils
	X? (
		media-gfx/imagemagick
		media-libs/imlib2
		www-client/w3m[imlib]
		x11-apps/xprop
		x11-apps/xrandr
		x11-apps/xwininfo
	)"

PATCHES=(
	"${FILESDIR}"/${P}-fix-arm-riscv-loongarch-cpu-model-detection.patch
)

src_prepare() {
	if use prefix; then
		# bug #693526
		hprefixify neofetch
		sed -e "/has emerge/s:\${br_prefix}:${EPREFIX}:" -i neofetch \
			|| die "Failed to adjust for Prefix"
	fi

	default
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
