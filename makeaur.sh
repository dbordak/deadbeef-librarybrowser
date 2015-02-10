#!/bin/bash

PACKAGENAME=deadbeef-fb

DATE=$1
if [ -z "$DATE" ]; then
    DATE=`date +%Y%m%d`
fi

FLAG=$2

BUILDROOT=`pwd`

BINTARGET=${BUILDROOT}/../${PACKAGENAME}${FLAG}_${DATE}.tar.gz
SRCTARGET=${BUILDROOT}/../${PACKAGENAME}${FLAG}_${DATE}_src.tar.gz

MD5SUM=$(md5sum ${SRCTARGET} | cut -c -32)
SHA1SUM=$(sha1sum ${SRCTARGET} | cut -c -40)

function make_package
{
    AURPACKAGENAME=$1
    AURPACKAGEFLAG=$2
    AURPACKAGEREL=$3
    AURPACKAGEDEPS=$4
    AURPACKAGECONFIG=$5

    echo "=============================================================================="
    echo "Building AUR package ${AURPACKAGENAME}${AURPACKAGEFLAG}-${DATE}-${AURPACKAGEREL} ..."

    cat PKGBUILD.in \
        | sed s/@PACKAGENAME@/${AURPACKAGENAME}/g \
        | sed s/@PACKAGEFLAG@/${AURPACKAGEFLAG}/g \
        | sed s/@PACKAGEREL@/${AURPACKAGEREL}/g \
        | sed s/@PACKAGEVER@/${DATE}/g \
        | sed s/@PACKAGEDEPS@/${AURPACKAGEDEPS}/g \
        | sed s/@PACKAGECONFIG@/${AURPACKAGECONFIG}/g \
        | sed s/@SOURCENAME@/${PACKAGENAME}${FLAG}_${DATE}/g \
        | sed s/@MD5SUM@/${MD5SUM}/g \
        | sed s/@SHA1SUM@/${SHA1SUM}/g \
        > PKGBUILD
    mkaurball
    rm -f PKGBUILD
    mv -v ${AURPACKAGENAME}${AURPACKAGEFLAG}-${DATE}-${AURPACKAGEREL}.src.tar.gz ${BUILDROOT}/../

    echo "=============================================================================="
    echo "Testing AUR package ${AURPACKAGENAME}${AURPACKAGEFLAG}-${DATE}-${AURPACKAGEREL} ..."

    cd ${BUILDROOT}/../
    rm -rf ${AURPACKAGENAME}${AURPACKAGEFLAG}
    tar -xzf ${AURPACKAGENAME}${AURPACKAGEFLAG}-${DATE}-${AURPACKAGEREL}.src.tar.gz
    cd ${AURPACKAGENAME}${AURPACKAGEFLAG}
    makepkg -f
    namcap PKGBUILD
    namcap ${AURPACKAGENAME}${AURPACKAGEFLAG}-${DATE}-${AURPACKAGEREL}-any.pkg.tar.xz
    cd ${BUILDROOT}
}

make_package "deadbeef-plugin-fb" ""      1 "gtk2" "--disable-gtk3"
make_package "deadbeef-plugin-fb" "-gtk3" 1 "gtk3" "--disable-gtk2"
