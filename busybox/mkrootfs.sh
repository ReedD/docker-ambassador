#!/bin/sh
tarmaker=tarmaker-ubuntu
[ -f $tarmaker/rootfs.tar ] && mv $tarmaker/rootfs.tar $tarmaker/rootfs.tar.old
docker run tarmaker cat /rootfs.tar > $tarmaker/rootfs.tar
rm -f rootfs.tar
# We use cp rather than ln because ln doesn't work well on VBox shared folders.
cp $tarmaker/rootfs.tar rootfs.tar
ls -ltr rootfs.tar */rootfs.tar*
echo "You can now build the busybox image, with:"
echo "docker build -t busybox ."
