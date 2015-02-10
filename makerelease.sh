#!/bin/bash

PACKAGENAME=deadbeef-lb

DATE=$1
if [ -z "$DATE" ]; then
    DATE=`date +%Y%m%d`
fi

FLAG=$2

BUILDROOT=`pwd`

DISTPACKAGENAME=${PACKAGENAME}-devel
INSTALLDIR=${BUILDROOT}/../install

DATE=`date +%Y%m%d`
BINTARGET=${BUILDROOT}/../${PACKAGENAME}${FLAG}_${DATE}.tar.gz
SRCTARGET=${BUILDROOT}/../${PACKAGENAME}${FLAG}_${DATE}_src.tar.gz

rm -rf ${INSTALLDIR}
mkdir -p ${INSTALLDIR}/${PACKAGENAME}
make DESTDIR=${INSTALLDIR} install
if [ -d ${INSTALLDIR} ]; then
    cd ${INSTALLDIR}
    for file in ./usr/local/lib/deadbeef/*.so.0.0.0; do
        cp -v $file ./${PACKAGENAME}/`basename $file .0.0.0`
    done
    cp -v ${BUILDROOT}/README ./${PACKAGENAME}/
    cp -v ${BUILDROOT}/*install.sh ./${PACKAGENAME}/
    cp -v ${BUILDROOT}/*remove.sh ./${PACKAGENAME}/
    tar -czf $BINTARGET ${PACKAGENAME}
    cd ${BUILDROOT}
fi

rm -f ${DISTPACKAGENAME}.tar.gz
make dist PACKAGE=${PACKAGENAME} && mv ${DISTPACKAGENAME}.tar.gz ${SRCTARGET}

ls -lh ${SRCTARGET} ${BINTARGET}
