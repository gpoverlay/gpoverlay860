# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake cuda virtualx

MY_COMMIT="6848b3a17b359e03585e56dd1f37dc7c71136114"

DESCRIPTION="An auto-parallelizing library to speed up computer simulations"
HOMEPAGE="
	http://www.libgeodecomp.org
	https://github.com/STEllAR-GROUP/libgeodecomp"
SRC_URI="https://github.com/STEllAR-GROUP/libgeodecomp/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="Boost-1.0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="cuda doc hpx mpi opencl opencv qt5 silo"

BDEPEND="
	doc? (
		app-text/doxygen
		app-text/texlive
		media-gfx/graphviz
	)"
RDEPEND="dev-libs/boost"
DEPEND="${RDEPEND}
	~dev-libs/libflatarray-0.4.0_pre20201009
	cuda? ( dev-util/nvidia-cuda-toolkit )
	hpx? ( sys-cluster/hpx )
	mpi? ( virtual/mpi )
	opencl? ( virtual/opencl )
	opencv? ( media-libs/opencv )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtwidgets:5
	)
	silo? ( sci-libs/silo )"

S="${WORKDIR}/libgeodecomp-${MY_COMMIT}"

PATCHES=(
	"${FILESDIR}/${P}-mpi.patch"
	"${FILESDIR}/${P}-opencv.patch"
)

DOCS=( README )

src_prepare() {
	cmake_src_prepare
	use cuda && cuda_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_CUDA=$(usex cuda)
		-DWITH_HPX=$(usex hpx)
		-DWITH_MPI=$(usex mpi)
		-DWITH_OPENCL=$(usex opencl)
		-DWITH_OPENCV=$(usex opencv)
		-DWITH_QT5=$(usex qt5)
		-DWITH_SCOTCH=false
		-DWITH_SILO=$(usex silo)
		-DWITH_TYPEMAPS=false
		-DWITH_VISIT=false
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_build doc
}

src_install() {
	use doc && local HTML_DOCS=( doc/html/* )
	cmake_src_install
}

src_test() {
	virtx cmake_build check
}
