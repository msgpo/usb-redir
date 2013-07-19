RELEASE=3.0

PACKAGE=libusbredirparser
PKGVERSION=0.6
PKGRELEASE=2

PKGDIR=usbredir-${PKGVERSION}
PKGSRC=usbredir-${PKGVERSION}.tar.bz2
DEBSRC=usbredir_${PKGVERSION}-${PKGRELEASE}.debian.tar.gz

ARCH:=$(shell dpkg-architecture -qDEB_BUILD_ARCH)

DEBS=								\
	${PACKAGE}1_${PKGVERSION}-${PKGRELEASE}_${ARCH}.deb  	\
	${PACKAGE}-dev_${PKGVERSION}-${PKGRELEASE}_${ARCH}.deb


all: ${DEBS}
	echo ${DEBS}

${DEBS}: ${PKGSRC}
	echo ${DEBS}
	rm -rf ${PKGDIR} debian
	tar xf ${PKGSRC}
	tar xf ${DEBSRC}

	cp -a debian ${PKGDIR}/debian
	cd ${PKGDIR}; dpkg-buildpackage -rfakeroot -b -us -uc

.PHONY: download
download:
	rm -rf ${PKGSRC} ${PKGDIR}
	git clone git://anongit.freedesktop.org/spice/usbredir ${PKGDIR}
	cd ${PKGDIR}; ./autogen.sh; make dist
	mv ${PKGDIR}/${PKGSRC} ${PKGSRC}

distclean: clean

.PHONY: clean
clean:
	rm -rf *~ debian *_${ARCH}.deb *.changes *.dsc ${PKGDIR}

.PHONY: dinstall
dinstall: ${DEBS}
	dpkg -i ${DEBS}
