#!/bin/bash

# Copied from qemu-kvm.spec.

PATCHLIST=$(grep '^ *Patch' <<'EOF'
    Patch0004: 0004-Initial-redhat-build.patch
    Patch0005: 0005-Enable-disable-devices-for-RHEL.patch
    Patch0006: 0006-Machine-type-related-general-changes.patch
    Patch0007: 0007-meson-temporarily-disable-Wunused-function.patch
    Patch0008: 0008-Remove-upstream-machine-types-for-aarch64-s390x-and-.patch
    Patch0009: 0009-Adapt-versioned-machine-type-macros-for-RHEL.patch
    Patch0010: 0010-Increase-deletion-schedule-to-4-releases.patch
    Patch0011: 0011-Add-downstream-aarch64-versioned-virt-machine-types.patch
    Patch0012: 0012-Add-downstream-s390x-versioned-s390-ccw-virtio-machi.patch
    Patch0013: 0013-Add-downstream-x86_64-versioned-pc-q35-machine-types.patch
    Patch0014: 0014-Disable-virtio-net-pci-romfile-loading-on-riscv64.patch
    Patch0015: 0015-Revert-meson-temporarily-disable-Wunused-function.patch
    Patch0016: 0016-Enable-make-check.patch
    Patch0017: 0017-vfio-cap-number-of-devices-that-can-be-assigned.patch
    Patch0018: 0018-Add-support-statement-to-help-output.patch
    Patch0019: 0019-Use-qemu-kvm-in-documentation-instead-of-qemu-system.patch
    Patch0020: 0020-qcow2-Deprecation-warning-when-opening-v2-images-rw.patch
    Patch0021: 0021-file-posix-Define-DM_MPATH_PROBE_PATHS.patch
    # For RHEL-112882 - [DEV Task]: Assertion `core->delayed_causes == 0' failed with e1000e NIC
    Patch22: kvm-e1000e-Prevent-crash-from-legacy-interrupt-firing-af.patch
    # For RHEL-119368 - [rhel10] Backport "arm/kvm: report registers we failed to set"
    Patch23: kvm-arm-kvm-report-registers-we-failed-to-set.patch
    # For RHEL-116443 - qemu crash after hot-unplug disk from the multifunction enabled bus,crash point PCIDevice *vf = dev->exp.sriov_pf.vf[i]
    Patch24: kvm-pcie_sriov-make-pcie_sriov_pf_exit-safe-on-non-SR-IO.patch
    # For RHEL-120253 - Backport fixes for PDCM and ARCH_CAPABILITIES migration incompatibility
    Patch25: kvm-target-i386-add-compatibility-property-for-arch_capa.patch
    # For RHEL-120253 - Backport fixes for PDCM and ARCH_CAPABILITIES migration incompatibility
    Patch26: kvm-target-i386-add-compatibility-property-for-pdcm-feat.patch
    # For RHEL-104009 - [IBM 10.2 FEAT] KVM: Enhance machine type definition to include CPI and PCI passthru capabilities (qemu)
    # For RHEL-105823 - Add new -rhel10.2.0 machine type to qemu-kvm [s390x]
    # For RHEL-73008 - [IBM 10.2 FEAT] KVM: Implement Control Program Identification (qemu)
    Patch27: kvm-qapi-machine-s390x-add-QAPI-event-SCLP_CPI_INFO_AVAI.patch
    # For RHEL-104009 - [IBM 10.2 FEAT] KVM: Enhance machine type definition to include CPI and PCI passthru capabilities (qemu)
    # For RHEL-105823 - Add new -rhel10.2.0 machine type to qemu-kvm [s390x]
    # For RHEL-73008 - [IBM 10.2 FEAT] KVM: Implement Control Program Identification (qemu)
    Patch28: kvm-tests-functional-add-tests-for-SCLP-event-CPI.patch
    # For RHEL-104009 - [IBM 10.2 FEAT] KVM: Enhance machine type definition to include CPI and PCI passthru capabilities (qemu)
    # For RHEL-105823 - Add new -rhel10.2.0 machine type to qemu-kvm [s390x]
    # For RHEL-73008 - [IBM 10.2 FEAT] KVM: Implement Control Program Identification (qemu)
    Patch29: kvm-redhat-Add-new-rhel9.8.0-and-rhel10.2.0-machine-type.patch
    # For RHEL-118810 - [RHEL 10.2] Windows 11 VM fails to boot up with ramfb='on' with QEMU 10.1
    Patch30: kvm-vfio-rename-field-to-num_initial_regions.patch
    # For RHEL-118810 - [RHEL 10.2] Windows 11 VM fails to boot up with ramfb='on' with QEMU 10.1
    Patch31: kvm-vfio-only-check-region-info-cache-for-initial-region.patch
    # For RHEL-105826 - Add new -rhel10.2.0 machine type to qemu-kvm [aarch64]
    # For RHEL-105828 - Add new -rhel10.2.0 machine type to qemu-kvm [x86_64]
    Patch32: kvm-arm-create-new-rhel-10.2-specific-virt-machine-type.patch
    # For RHEL-105826 - Add new -rhel10.2.0 machine type to qemu-kvm [aarch64]
    # For RHEL-105828 - Add new -rhel10.2.0 machine type to qemu-kvm [x86_64]
    Patch33: kvm-arm-create-new-rhel-9.8-specific-virt-machine-type.patch
    # For RHEL-105826 - Add new -rhel10.2.0 machine type to qemu-kvm [aarch64]
    # For RHEL-105828 - Add new -rhel10.2.0 machine type to qemu-kvm [x86_64]
    Patch34: kvm-x86-create-new-rhel-10.2-specific-pc-q35-machine-typ.patch
    # For RHEL-105826 - Add new -rhel10.2.0 machine type to qemu-kvm [aarch64]
    # For RHEL-105828 - Add new -rhel10.2.0 machine type to qemu-kvm [x86_64]
    Patch35: kvm-x86-create-new-rhel-9.8-specific-pc-q35-machine-type.patch
    # For RHEL-101929 - enable 'usb-bot' device for proper support of USB CD-ROM drives via libvirt  
    Patch36: kvm-rh-enable-CONFIG_USB_STORAGE_BOT.patch
    # For RHEL-120116 - CVE-2025-11234 qemu-kvm: VNC WebSocket handshake use-after-free [rhel-10.2]
    Patch37: kvm-io-move-websock-resource-release-to-close-method.patch
    # For RHEL-120116 - CVE-2025-11234 qemu-kvm: VNC WebSocket handshake use-after-free [rhel-10.2]
    Patch38: kvm-io-fix-use-after-free-in-websocket-handshake-code.patch
    # For RHEL-126573 - VFIO migration using multifd should be disabled by default
    Patch39: kvm-vfio-Disable-VFIO-migration-with-MultiFD-support.patch
    # For RHEL-67323 - [aarch64] Support ACPI based PCI hotplug on ARM
    Patch40: kvm-hw-arm-virt-Use-ACPI-PCI-hotplug-by-default-from-10..patch
    # For RHEL-73800 - NVIDIA:Grace-Hopper:Backport support for user-creatable nested SMMUv3 - RHEL 10.1
    Patch41: kvm-hw-arm-smmu-common-Check-SMMU-has-PCIe-Root-Complex-.patch
    # For RHEL-73800 - NVIDIA:Grace-Hopper:Backport support for user-creatable nested SMMUv3 - RHEL 10.1
    Patch42: kvm-hw-arm-virt-acpi-build-Re-arrange-SMMUv3-IORT-build.patch
    # For RHEL-73800 - NVIDIA:Grace-Hopper:Backport support for user-creatable nested SMMUv3 - RHEL 10.1
    Patch43: kvm-hw-arm-virt-acpi-build-Update-IORT-for-multiple-smmu.patch
    # For RHEL-73800 - NVIDIA:Grace-Hopper:Backport support for user-creatable nested SMMUv3 - RHEL 10.1
    Patch44: kvm-hw-arm-virt-Factor-out-common-SMMUV3-dt-bindings-cod.patch
    # For RHEL-73800 - NVIDIA:Grace-Hopper:Backport support for user-creatable nested SMMUv3 - RHEL 10.1
    Patch45: kvm-hw-arm-virt-Add-an-SMMU_IO_LEN-macro.patch
    # For RHEL-73800 - NVIDIA:Grace-Hopper:Backport support for user-creatable nested SMMUv3 - RHEL 10.1
    Patch46: kvm-hw-pci-Introduce-pci_setup_iommu_per_bus-for-per-bus.patch
    # For RHEL-73800 - NVIDIA:Grace-Hopper:Backport support for user-creatable nested SMMUv3 - RHEL 10.1
    Patch47: kvm-hw-arm-virt-Allow-user-creatable-SMMUv3-dev-instanti.patch
    # For RHEL-73800 - NVIDIA:Grace-Hopper:Backport support for user-creatable nested SMMUv3 - RHEL 10.1
    Patch48: kvm-qemu-options.hx-Document-the-arm-smmuv3-device.patch
    # For RHEL-73800 - NVIDIA:Grace-Hopper:Backport support for user-creatable nested SMMUv3 - RHEL 10.1
    Patch49: kvm-bios-tables-test-Allow-for-smmuv3-test-data.patch
    # For RHEL-73800 - NVIDIA:Grace-Hopper:Backport support for user-creatable nested SMMUv3 - RHEL 10.1
    Patch50: kvm-qtest-bios-tables-test-Add-tests-for-legacy-smmuv3-a.patch
    # For RHEL-73800 - NVIDIA:Grace-Hopper:Backport support for user-creatable nested SMMUv3 - RHEL 10.1
    Patch51: kvm-qtest-bios-tables-test-Update-tables-for-smmuv3-test.patch
    Patch52: kvm-qtest-Do-not-run-bios-tables-test-on-aarch64.patch
EOF
)

while read -r NUM FILE; do
    #echo "NUM: $NUM FILE: $FILE"
    patch -p1 < "../$FILE"
done <<< "$PATCHLIST"

