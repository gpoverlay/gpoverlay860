# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit go-module

DESCRIPTION="A pager for grep, git-grep and similar grep implementations"
HOMEPAGE="https://github.com/vrothberg/vgrep"
SRC_URI="https://github.com/vrothberg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD GPL-3 MIT"
SLOT="0"
KEYWORDS="amd64"

# golangci-lint is required to run tests which is not yet packaged
RESTRICT="strip test"

BDEPEND="dev-go/go-md2man"

DOCS=( README.md )

src_compile() {
	emake build
}

src_install() {
	emake PREFIX="${D}/usr" install
	einstalldocs
}
