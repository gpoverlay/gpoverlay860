# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/dropbear.asc
inherit savedconfig pam python-any-r1 verify-sig

DESCRIPTION="Small SSH 2 client/server designed for small memory environments"
HOMEPAGE="https://matt.ucc.asn.au/dropbear/dropbear.html"
SRC_URI="https://matt.ucc.asn.au/dropbear/releases/${P}.tar.bz2
	https://matt.ucc.asn.au/dropbear/testing/${P}.tar.bz2"
SRC_URI+=" verify-sig? (
		https://matt.ucc.asn.au/dropbear/releases/${P}.tar.bz2.asc
		https://matt.ucc.asn.au/dropbear/testing/${P}.tar.bz2.asc
	)"

LICENSE="MIT GPL-2" # (init script is GPL-2 #426056)
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="bsdpty minimal multicall pam +shadow static +syslog test zlib"
RESTRICT="!test? ( test ) test"

LIB_DEPEND="
	virtual/libcrypt[static-libs(+)]
	zlib? ( sys-libs/zlib[static-libs(+)] )
"
RDEPEND="
	acct-group/sshd
	acct-user/sshd
	!static? (
		>=dev-libs/libtomcrypt-1.18.2-r2[libtommath]
		>=dev-libs/libtommath-1.2.0
		${LIB_DEPEND//\[static-libs(+)]}
	)
	pam? ( sys-libs/pam )
"
DEPEND="
	${RDEPEND}
	static? ( ${LIB_DEPEND} )
"
RDEPEND+=" pam? ( >=sys-auth/pambase-20080219.1 )"
BDEPEND="
	test? (
		$(python_gen_any_dep '
			dev-python/attrs[${PYTHON_USEDEP}]
			dev-python/iniconfig[${PYTHON_USEDEP}]
			dev-python/packaging[${PYTHON_USEDEP}]
			dev-python/pluggy[${PYTHON_USEDEP}]
			dev-python/py[${PYTHON_USEDEP}]
			dev-python/pyparsing[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
		')
	)
	verify-sig? ( sec-keys/openpgp-keys-dropbear )
"

REQUIRED_USE="pam? ( !static )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.46-dbscp.patch
	"${FILESDIR}"/${PN}-2022.82-tests.patch
)

set_options() {
	progs=(
		dropbear dbclient dropbearkey
		$(usex minimal "" "dropbearconvert scp")
	)
	makeopts=(
		MULTI=$(usex multicall 1 0)
	)
}

python_check_deps() {
	python_has_version "dev-python/attrs[${PYTHON_USEDEP}]" && \
		python_has_version "dev-python/iniconfig[${PYTHON_USEDEP}]" && \
		python_has_version "dev-python/packaging[${PYTHON_USEDEP}]" && \
		python_has_version "dev-python/pluggy[${PYTHON_USEDEP}]" && \
		python_has_version "dev-python/py[${PYTHON_USEDEP}]" && \
		python_has_version "dev-python/pyparsing[${PYTHON_USEDEP}]" && \
		python_has_version "dev-python/pytest[${PYTHON_USEDEP}]" && \
		python_has_version "dev-python/psutil[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup

	if use static ; then
		ewarn "Using bundled copies of libtommath and libtomcrypt"
	fi
}

src_prepare() {
	default
	sed \
		-e '/SFTPSERVER_PATH/s:".*":"/usr/lib/misc/sftp-server":' \
		default_options.h > localoptions.h || die
	sed \
		-e '/pam_start/s:sshd:dropbear:' \
		-i svr-authpam.c || die
	restore_config localoptions.h
}

src_configure() {
	# Notes:
	# 1) We use bundled libtom* when static build is enabled because
	#    libtomcrypt lacks it and we don't particularly want to add it.
	# 2) We disable the hardening flags as our compiler already enables them
	#    by default as is appropriate for the target.
	local myeconfargs=(
		--disable-harden

		# bug #836900
		$(use_enable !elibc_musl lastlog)
		$(use_enable !elibc_musl wtmp)

		$(use_enable static bundled-libtom)
		$(use_enable zlib)
		$(use_enable pam)
		$(use_enable !bsdpty openpty)
		$(use_enable shadow)
		$(use_enable static)
		$(use_enable syslog)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	set_options
	emake "${makeopts[@]}" PROGRAMS="${progs[*]}"
}

src_install() {
	set_options
	emake "${makeopts[@]}" PROGRAMS="${progs[*]}" DESTDIR="${D}" install
	doman *.8
	newinitd "${FILESDIR}"/dropbear.init.d dropbear
	newconfd "${FILESDIR}"/dropbear.conf.d dropbear
	dodoc CHANGES README SMALL MULTI

	# The multi install target does not install the links right.
	if use multicall ; then
		cd "${ED}"/usr/bin || die
		local x
		for x in "${progs[@]}" ; do
			ln -sf dropbearmulti ${x} || die "ln -s dropbearmulti to ${x} failed"
		done
		rm -f dropbear
		dodir /usr/sbin
		dosym ../bin/dropbearmulti /usr/sbin/dropbear
		cd "${S}" || die
	fi
	save_config localoptions.h

	if ! use minimal ; then
		mv "${ED}"/usr/bin/{,db}scp || die
	fi

	if use pam; then
		pamd_mimic system-remote-login dropbear auth account password session
	fi
}