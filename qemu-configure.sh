#!/bin/bash

# Copied from qemu-kvm.spec with the variables directly defined.
# It keeps the flags used in the official rpm package, then adds
# additional flags (related to gtk and virgl) at the end.

NAME=qemu
CC=/bin/clang
KVM_TARGET=x86_64
TARGET_LIST=$KVM_TARGET-softmmu
BLOCK_DRV_RW_WHITELIST=qcow2,raw,file,host_device,nbd,iscsi,rbd,blkdebug,luks,null-co,nvme,copy-on-read,throttle,compress,virtio-blk-vhost-vdpa,virtio-blk-vfio-pci,virtio-blk-vhost-user,io_uring,nvme-io_uring
BLOCK_DRIVERS_RO_LIST=vdi,vmdk,vhdx,vpc,https
PREFIX=~/.local/qemu
# This is the folder for runtime plugins (e.g. loaded when using -device).
LIBDIR="$PREFIX/lib64"
DATADIR="$PREFIX/share"
DOCDIR="$DATADIR/doc"
SYSCONFDIR="/etc"
LIBEXECDIR="$PREFIX/libexec"
LOCALSTATEDIR="/var"
BUILD_LDFLAGS=""
OPTFLAGS=""
# Runtime search dirs (won't generate build artifacts into it).
SYSDATADIR=/usr/share
FIRMWAREDIRS="$SYSDATADIR/qemu-firmware:$SYSDATADIR/ipxe/qemu:$SYSDATADIR/seavgabios:$SYSDATADIR/seabios"

export PKG_CONFIG_PATH=~/.local/virglrenderer/lib64/pkgconfig:$PKG_CONFIG_PATH

DISABLE_EVERYTHING=(
  --audio-drv-list=
  --disable-alsa
  --disable-asan
  --disable-attr
  --disable-auth-pam
  --disable-blkio
  --disable-block-drv-whitelist-in-tools
  --disable-bochs
  --disable-bpf
  --disable-brlapi
  --disable-bsd-user
  --disable-bzip2
  --disable-cap-ng
  --disable-capstone
  --disable-cfi
  --disable-cfi-debug
  --disable-cloop
  --disable-cocoa
  --disable-coreaudio
  --disable-coroutine-pool
  --disable-crypto-afalg
  --disable-curl
  --disable-curses
  --disable-dbus-display
  --disable-debug-info
  --disable-debug-mutex
  --disable-debug-tcg
  --disable-dmg
  --disable-docs
  --disable-download
  --disable-dsound
  --disable-fdt
  --disable-fuse
  --disable-fuse-lseek
  --disable-gcrypt
  --disable-gettext
  --disable-gio
  --disable-glusterfs
  --disable-gnutls
  --disable-gtk
  --disable-guest-agent
  --disable-guest-agent-msi
  --disable-hvf
  --disable-iconv
  --disable-jack
  --disable-kvm
  --disable-l2tpv3
  --disable-libdaxctl
  --disable-libdw
  --disable-libiscsi
  --disable-libnfs
  --disable-libpmem
  --disable-libssh
  --disable-libudev
  --disable-libusb
  --disable-libvduse
  --disable-linux-aio
  --disable-linux-io-uring
  --disable-linux-user
  --disable-lto
  --disable-lzfse
  --disable-lzo
  --disable-malloc-trim
  --disable-membarrier
  --disable-modules
  --disable-module-upgrades
  --disable-mpath
  --disable-multiprocess
  --disable-netmap
  --disable-nettle
  --disable-numa
  --disable-nvmm
  --disable-opengl
  --disable-oss
  --disable-pa
  --disable-parallels
  --disable-pie
  --disable-plugins
  --disable-pvg
  --disable-qcow1
  --disable-qed
  --disable-qga-vss
  --disable-qom-cast-debug
  --disable-rbd
  --disable-rdma
  --disable-replication
  --disable-rng-none
  --disable-safe-stack
  --disable-sdl
  --disable-sdl-image
  --disable-seccomp
  --disable-selinux
  --disable-slirp
  --disable-slirp-smbd
  --disable-smartcard
  --disable-snappy
  --disable-sndio
  --disable-sparse
  --disable-spice
  --disable-spice-protocol
  --disable-strip
  --disable-system
  --disable-tcg
  --disable-tools
  --disable-tpm
  --disable-u2f
  --disable-ubsan
  --disable-usb-redir
  --disable-user
  --disable-valgrind
  --disable-vde
  --disable-vdi
  --disable-vduse-blk-export
  --disable-vhost-crypto
  --disable-vhost-kernel
  --disable-vhost-net
  --disable-vhost-user
  --disable-vhost-user-blk-server
  --disable-vhost-vdpa
  --disable-virglrenderer
  --disable-virtfs
  --disable-vnc
  --disable-vnc-jpeg
  --disable-png
  --disable-vnc-sasl
  --disable-vte
  --disable-vvfat
  --disable-werror
  --disable-whpx
  --disable-xen
  --disable-xen-pci-passthrough
  --disable-xkbcommon
  --disable-zstd
  --without-default-devices
)

ARGS=(
        --cc="$CC"
        --cxx=/bin/false
        --prefix="$PREFIX"
        --libdir="$LIBDIR"
        --datadir="$DATADIR"
        --sysconfdir="$SYSCONFDIR"
        --interp-prefix="$PREFIX/qemu-%M"
        --localstatedir="$LOCALSTATEDIR"
        --docdir="$DOCDIR"
        --libexecdir="$LIBEXECDIR"
        --extra-ldflags="$BUILD_LDFLAGS"
        --extra-cflags="$OPTFLAGS -Wno-string-plus-int"
        #--with-pkgversion="%{name}-%{version}-%{release}"
        #--with-suffix="$NAME"
        --firmwarepath="$FIRMWAREDIRS"
        --enable-trace-backends=dtrace
        --with-coroutine=ucontext
        --tls-priority=@QEMU,SYSTEM
        "${DISABLE_EVERYTHING[@]}"
#%ifarch aarch64 s390x x86_64 riscv64
        --with-devices-$KVM_TARGET=$KVM_TARGET-rh-devices
#%endif
    --rhel-version=10

    --target-list="$TARGET_LIST"
    --block-drv-rw-whitelist="$BLOCK_DRV_RW_WHITELIST"
    --block-drv-ro-whitelist="$BLOCK_DRIVERS_RO_LIST"

  --enable-attr
  --enable-blkio
  --enable-cap-ng
  --enable-capstone
  --enable-coroutine-pool
  --enable-curl
  --enable-dbus-display
  --enable-debug-info
  --enable-docs
#%if %{have_fdt}
  --enable-fdt=system
#%endif
  --enable-gio
  --enable-gnutls
  --enable-guest-agent
  --enable-iconv
  --enable-kvm
#%if %{have_pmem}
  #--enable-libpmem
#%endif
  --enable-libusb
  --enable-libudev
  --enable-linux-aio
  --enable-linux-io-uring
  --enable-lzo
  --enable-malloc-trim
  --enable-modules
  --enable-mpath
#%if %{have_numactl}
  --enable-numa
#%endif
#%if %{have_opengl}
  --enable-opengl
#%endif
  --enable-pa
  --enable-pie
#%if %{have_block_rbd}
  --enable-rbd
#%endif
#%if %{have_librdma}
  #--enable-rdma
#%endif
  --enable-seccomp
  --enable-selinux
  --enable-slirp
  --enable-snappy
  --enable-spice-protocol
  --enable-system
  --enable-tcg
  --enable-tools
  --enable-tpm
#%if %{have_usbredir}
  --enable-usb-redir
#%endif
#%ifarch %{valgrind_arches}
  #--enable-valgrind
#%endif
  --enable-vdi
  --enable-vhost-kernel
  --enable-vhost-net
  --enable-vhost-user
  --enable-vhost-user-blk-server
  --enable-vhost-vdpa
  --enable-vnc
  --enable-png
  --enable-vnc-sasl
#%if %{enable_werror}
  --enable-werror
#%endif
  --enable-xkbcommon
  --enable-zstd
#%if %{have_safe_stack}
  --enable-safe-stack
#%endif

# The flags above should be exactly the same as the official rpm package.
# Below are the additional flags we add.
  --enable-gtk
  --enable-virglrenderer

)

../configure "${ARGS[@]}"

