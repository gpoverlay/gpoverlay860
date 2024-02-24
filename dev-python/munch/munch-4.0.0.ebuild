# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="A dot-accessible dictionary (a la JavaScript objects)"
HOMEPAGE="
	https://github.com/Infinidat/munch/
	https://pypi.org/project/munch/
"

LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
SLOT="0"

BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest