# Build QEMU with GTK VirGL support on CentOS Stream 10

The official qemu-kvm package on CentOS Stream 10 doesn't have gtk/virgl
support. We can build QEMU by ourselves with the same source/flags as the
official build, while adding 2 additional flags to enable gtk/virgl.

The QEMU binaries will be installed into ~/.local/qemu, so it won't
interfere with the official QEMU packages.

1. Download the source code of the qemu-kvm package:
   ```
   dnf download --source qemu-kvm-core-10.1.0-6.el10
   rpm -i qemu-kvm-10.1.0-6.el10.src.rpm   # Extract to ~/rpmbuild
   ```

2. Install build dependencies:
   ```
   sudo dnf config-manager --set-enabled crb
   sudo dnf builddep qemu-kvm
   sudo dnf install gtk3-devel
   ```

3. Install [virglrenderer](https://gitlab.freedesktop.org/virgl/virglrenderer/-/releases)
   into ~/.local/virglrenderer:
   ```
   # To enable egl support in virglrenderer, these packages are needed.
   sudo dnf install mesa-libEGL-devel mesa-libgbm-devel libepoxy-devel libdrm-devel
   # git clone the repository, then cd into it.
   cd virglrenderer
   git checkout 1.2.0

   # Build a static library for simplicity.
   meson setup build --prefix=~/.local/virglrenderer --default-library=static -Dplatforms=egl
   # Verify the output shows `egl: true`.
   # Video decoding is new and experimental, by default it's `false`.
   cd build
   ninja
   ninja install     # Install into ~/.local/virglrenderer
   ```

4. Prepare source code:
   ```
   cd ~/rpmbuild/SOURCES
   tar -xJf qemu-10.1.0.tar.xz
   cd qemu-10.1.0
   # Run apply-patch.sh of this repo (CWD is `qemu-10.1.0`)
   /path/to/apply-patch.sh
   # Verify that the patches are applied cleanly
   find ./ -type f -name '*.rej'   # Shouldn't find any .rej files
   ```

5. Build:
   ```
   # CWD: ~/rpmbuild/SOURCES/qemu-10.1.0
   mkdir build
   cd build
   # Run qemu-configure.sh of this repo (CWD is `build`)
   /path/to/qemu-configure.sh
   # Verify `GTK support` and `VirGL support` is `YES` in the output.
   make -j12
   make install    # Install into ~/.local/qemu
   ```

6. `~/.local/qemu/bin/qemu-system-x86_64` can be used now. To enable virgl:
   ```
   -display gtk,gl=on -vga none -device virtio-gpu-gl-pci
   ```

