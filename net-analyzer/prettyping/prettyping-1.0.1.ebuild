# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Ping wrapper that produces coloured, easily readable output"
HOMEPAGE="https://denilson.sa.nom.br/prettyping/"
SRC_URI="https://github.com/denilsonsa/prettyping/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"

RDEPEND="app-shells/bash
	net-misc/iputils
	app-alternatives/awk"

src_install() {
	dobin prettyping
}
