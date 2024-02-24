# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PHAYLON
DIST_VERSION=0.004
inherit perl-module

DESCRIPTION="Activate syntax extensions"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Data-OptList-0.104.0
	dev-perl/namespace-clean
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=virtual/perl-Test-Simple-0.940.0
	)
"

PERL_RM_FILES=( "t/release-eol.t" "t/release-distmeta.t" "t/release-no-tabs.t"
	"t/release-pod-syntax.t" )