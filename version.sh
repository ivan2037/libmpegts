#!/bin/bash
git rev-list HEAD | sort > config.git-hash
LOCALVER=`wc -l config.git-hash | awk '{print $1}'`
if [ $LOCALVER \> 1 ] ; then
    VER=`git rev-list origin/master | sort | join config.git-hash - | wc -l | awk '{print $1}'`
    if [ $VER != $LOCALVER ] ; then
        VER="$VER+$(($LOCALVER-$VER))"
    fi
    if git status | grep -q "modified:" ; then
        VER="${VER}M"
    fi
    VER="$VER $(git rev-list HEAD -n 1 | cut -c 1-7)"
    echo "#define LIBMPEGTS_VERSION \" r$VER\""
else
    echo "#define LIBMPEGTS_VERSION \"\""
    VER="x"
fi
rm -f config.git-hash
API=`grep '#define LIBMPEGTS_API_VERSION_MAJOR' < libmpegts.h | sed -e 's/.* \([0-9]*\).*/\1/'`
echo "#define LIBMPEGTS_POINTVER \"0.$API.$VER\""
