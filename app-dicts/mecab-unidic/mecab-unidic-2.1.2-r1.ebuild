# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="unidic-mecab-${PV}_src"

DESCRIPTION="IPA dictionary for MeCab"
HOMEPAGE="https://osdn.jp/projects/unidic/"
SRC_URI="mirror://sourceforge.jp/${PN#*-}/58338/${MY_P}.zip"
S="${WORKDIR}/${MY_P}"

LICENSE="|| ( BSD GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

DEPEND="app-text/mecab"
BDEPEND="app-arch/unzip"
