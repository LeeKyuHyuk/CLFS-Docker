#!/bin/bash
#
# qNux image build script
# Optional parameteres below:
set -o nounset
set -o errexit

# End of optional parameters
function step() {
    echo -e "\e[7m\e[1m>>> $1\e[0m"
}

function success() {
    echo -e "\e[1m\e[32m$1\e[0m"
}

function extract() {
    case $1 in
        *.tgz) tar -zxf $1 -C $2 ;;
        *.tar.gz) tar -zxf $1 -C $2 ;;
        *.tar.bz2) tar -jxf $1 -C $2 ;;
        *.tar.xz) tar -Jxf $1 -C $2 ;;
    esac
}

function timer {
    if [[ $# -eq 0 ]]; then
        echo $(date '+%s')
    else
        local stime=$1
        etime=$(date '+%s')
        if [[ -z "$stime" ]]; then stime=$etime; fi
        dt=$((etime - stime))
        ds=$((dt % 60))
        dm=$(((dt / 60) % 60))
        dh=$((dt / 3600))
        printf '%02d:%02d:%02d' $dh $dm $ds
    fi
}

total_build_time=$(timer)

step "[1/1] Generate Root File System File"
rm -rf $BUILD_DIR $IMAGES_DIR
mkdir -pv $BUILD_DIR $IMAGES_DIR
rm -rf $IMAGES_DIR $BUILD_DIR
mkdir -pv $IMAGES_DIR $BUILD_DIR
echo '#!/bin/sh' > $BUILD_DIR/_fakeroot.fs
echo "set -e" >> $BUILD_DIR/_fakeroot.fs
echo "chown -h -R 0:0 $ROOTFS_DIR" >> $BUILD_DIR/_fakeroot.fs
echo "cd $ROOTFS_DIR" >> $BUILD_DIR/_fakeroot.fs
echo "tar -cvzf $IMAGES_DIR/qNux-$CONFIG_QNUX_VERSION.tar.gz bin boot dev etc lib lib64 linuxrc media mnt opt proc root run sbin sys tmp usr var" >> $BUILD_DIR/_fakeroot.fs
chmod a+x $BUILD_DIR/_fakeroot.fs
$TOOLS_DIR/usr/bin/fakeroot -- $BUILD_DIR/_fakeroot.fs

success "\nTotal image build time: $(timer $total_build_time)\n"
