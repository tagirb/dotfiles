#!/bin/bash

uuid=$(blkid -o value -s UUID /dev/nvme0n1p2)
root=$(findmnt -no SOURCE -r /)
major_versions=$(pacman -Qe | awk '$1 ~ /^linux[0-9]+/ {split($2,v,"."); print v[1] "." v[2];}')
arch=$(uname -m)

# generate entries
for major in $major_versions; do
    version="$major-$arch"
    # main
    cat > /boot/loader/entries/manjaro-$version.conf <<EOF
title	Manjaro Linux $major
linux	/vmlinuz-$version
initrd	/intel-ucode.img
initrd	/initramfs-$version.img
options	cryptdevice=UUID=$uuid:cryptroot root=$root rw
EOF
    # fallback
    cat > /boot/loader/entries/manjaro-$version-fallback.conf <<EOF
title	Manjaro Linux $major
linux	/vmlinuz-$version
initrd	/intel-ucode.img
initrd	/initramfs-$version-fallback.img
options	cryptdevice=UUID=$uuid:cryptroot root=$root rw
EOF
done

# generate loader.conf
cat > /boot/loader/loader.conf << EOF
default  manjaro-$major-$arch
timeout  1
EOF

# clean up the obsolete entries
for f in /boot/loader/entries/manjaro-*.conf; do
    major=${${f#*manjaro-}%-$arch*}
    # iterate over all installed versions
    for m in $major_versions; do
        [[ $major == $m ]] && continue 2
    done
    # if no matching version is installed, remove the entry
    rm $f
done
