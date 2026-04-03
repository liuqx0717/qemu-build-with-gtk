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
    # For RHEL-126708 - [RHEL 10]snp guest fail to boot with hugepage
    Patch53: kvm-ram-block-attributes-fix-interaction-with-hugetlb-me.patch
    # For RHEL-126708 - [RHEL 10]snp guest fail to boot with hugepage
    Patch54: kvm-ram-block-attributes-Unify-the-retrieval-of-the-bloc.patch
    # For RHEL-128085 - VM crashes during boot when virtio device is attached through vfio_ccw
    Patch55: kvm-hw-s390x-Fix-a-possible-crash-with-passed-through-vi.patch
    # For RHEL-130704 - [rhel10] Fix the typo under vfio-pci device's enable-migration option 
    Patch56: kvm-Fix-the-typo-of-vfio-pci-device-s-enable-migration-o.patch
    # For RHEL-120115 - The vf nic created using the IGB emulated nic can not obtain ip address 
    Patch57: kvm-pcie_sriov-Fix-broken-MMIO-accesses-from-SR-IOV-VFs.patch
    # For RHEL-130478 - Migration from RHEL 10.2 to RHEL 10.1 with virt-rhel10.0.0 machine type fails on Grace
    Patch58: kvm-arm-fix-oob-access-in-compat-handling.patch
    # For RHEL-129540 - Assertion failure on drain with iothread and I/O load
    Patch59: kvm-block-backend-Fix-race-when-resuming-queued-requests.patch
    # For RHEL-121543 - The VM hit io error when do S3-PR integration on the pass-through  failover multipath device
    Patch60: kvm-file-posix-Handle-suspended-dm-multipath-better-for-.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch61: kvm-accel-Add-Meson-and-config-support-for-MSHV-accelera.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch62: kvm-target-i386-emulate-Allow-instruction-decoding-from-.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch63: kvm-target-i386-mshv-Add-x86-decoder-emu-implementation.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch64: kvm-hw-intc-Generalize-APIC-helper-names-from-kvm_-to-ac.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch65: kvm-include-hw-hyperv-Add-MSHV-ABI-header-definitions.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch66: kvm-linux-headers-linux-Add-mshv.h-headers.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch67: kvm-accel-mshv-Add-accelerator-skeleton.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch68: kvm-accel-mshv-Register-memory-region-listeners.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch69: kvm-accel-mshv-Initialize-VM-partition.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch70: kvm-treewide-rename-qemu_wait_io_event-qemu_wait_io_even.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch71: kvm-accel-mshv-Add-vCPU-creation-and-execution-loop.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch72: kvm-accel-mshv-Add-vCPU-signal-handling.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch73: kvm-target-i386-mshv-Add-CPU-create-and-remove-logic.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch74: kvm-target-i386-mshv-Implement-mshv_store_regs.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch75: kvm-target-i386-mshv-Implement-mshv_get_standard_regs.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch76: kvm-target-i386-mshv-Implement-mshv_get_special_regs.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch77: kvm-target-i386-mshv-Implement-mshv_arch_put_registers.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch78: kvm-target-i386-mshv-Set-local-interrupt-controller-stat.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch79: kvm-target-i386-mshv-Register-CPUID-entries-with-MSHV.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch80: kvm-target-i386-mshv-Register-MSRs-with-MSHV.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch81: kvm-target-i386-mshv-Integrate-x86-instruction-decoder-e.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch82: kvm-target-i386-mshv-Write-MSRs-to-the-hypervisor.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch83: kvm-target-i386-mshv-Implement-mshv_vcpu_run.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch84: kvm-accel-mshv-Handle-overlapping-mem-mappings.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch85: kvm-qapi-accel-Allow-to-query-mshv-capabilities.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch86: kvm-target-i386-mshv-Use-preallocated-page-for-hvcall.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch87: kvm-docs-Add-mshv-to-documentation.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch88: kvm-MAINTAINERS-Add-maintainers-for-mshv-accelerator.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch89: kvm-accel-mshv-initialize-thread-name.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch90: kvm-accel-mshv-use-return-value-of-handle_pio_str_read.patch
    # For RHEL-134212 - [RHEL10.2] L1VH qemu downstream initial merge RHEL10.2
    Patch91: kvm-monitor-generalize-query-mshv-info-mshv-to-query-acc.patch
    # For RHEL-110003 - Expose block limits of block nodes in QMP and qemu-img
    Patch92: kvm-block-Improve-comments-in-BlockLimits.patch
    # For RHEL-110003 - Expose block limits of block nodes in QMP and qemu-img
    Patch93: kvm-block-Expose-block-limits-for-images-in-QMP.patch
    # For RHEL-110003 - Expose block limits of block nodes in QMP and qemu-img
    Patch94: kvm-qemu-img-info-Optionally-show-block-limits.patch
    # For RHEL-110003 - Expose block limits of block nodes in QMP and qemu-img
    Patch95: kvm-qemu-img-info-Add-cache-mode-option.patch
    # For RHEL-111853 - [Intel 10.0 FEAT] [SPR] TDX: Virt-QEMU: QEMU Support [rhel-10]
    Patch96: kvm-rh-configs-enable-CONFIG_TDX-for-x86_64.patch
    # For RHEL-108142 - QEMU crashes when stopping source VM during live migration
    Patch97: kvm-block-Fix-BDS-use-after-free-during-shutdown.patch
    # For RHEL-126707 - [qemu, rhel-10] increase default TSEG size
    Patch98: kvm-fix-pc_rhel_10_2_compat_len.patch
    # For RHEL-126707 - [qemu, rhel-10] increase default TSEG size
    Patch99: kvm-q35-increase-default-tseg-size.patch
    # For RHEL-139028 - Intel IOMMU VM freezes: "call_irq_handler: 3.37 No irq handler for vector"[rhel-10.2]
    Patch100: kvm-hw-intc-ioapic-Fix-ACCEL_KERNEL_GSI_IRQFD_POSSIBLE-t.patch
    # For RHEL-111853 - [Intel 10.0 FEAT] [SPR] TDX: Virt-QEMU: QEMU Support [rhel-10]
    Patch101: kvm-redhat-allow-5-level-paging-for-TDX-VMs.patch
    # For RHEL-79118 - [network-storage][rbd][core-dump]installation of guest failed sometimes with multiqueue enabled [rhel10]
    Patch102: kvm-rbd-Run-co-BH-CB-in-the-coroutine-s-AioContext.patch
    # For RHEL-79118 - [network-storage][rbd][core-dump]installation of guest failed sometimes with multiqueue enabled [rhel10]
    Patch103: kvm-curl-Fix-coroutine-waking.patch
    # For RHEL-79118 - [network-storage][rbd][core-dump]installation of guest failed sometimes with multiqueue enabled [rhel10]
    Patch104: kvm-block-io-Take-reqs_lock-for-tracked_requests.patch
    # For RHEL-79118 - [network-storage][rbd][core-dump]installation of guest failed sometimes with multiqueue enabled [rhel10]
    Patch105: kvm-qcow2-Re-initialize-lock-in-invalidate_cache.patch
    # For RHEL-79118 - [network-storage][rbd][core-dump]installation of guest failed sometimes with multiqueue enabled [rhel10]
    Patch106: kvm-qcow2-Fix-cache_clean_timer.patch
    # For RHEL-143785 - backport support for GSO over UDP tunnel offload
    Patch107: kvm-net-bundle-all-offloads-in-a-single-struct.patch
    # For RHEL-143785 - backport support for GSO over UDP tunnel offload
    Patch108: kvm-linux-headers-deal-with-counted_by-annotation.patch
    # For RHEL-143785 - backport support for GSO over UDP tunnel offload
    Patch109: kvm-linux-headers-Update-to-Linux-v6.17-rc1.patch
    # For RHEL-143785 - backport support for GSO over UDP tunnel offload
    Patch110: kvm-virtio-introduce-extended-features-type.patch
    # For RHEL-143785 - backport support for GSO over UDP tunnel offload
    Patch111: kvm-virtio-serialize-extended-features-state.patch
    # For RHEL-143785 - backport support for GSO over UDP tunnel offload
    Patch112: kvm-virtio-add-support-for-negotiating-extended-features.patch
    # For RHEL-143785 - backport support for GSO over UDP tunnel offload
    Patch113: kvm-virtio-pci-implement-support-for-extended-features.patch
    # For RHEL-143785 - backport support for GSO over UDP tunnel offload
    Patch114: kvm-vhost-add-support-for-negotiating-extended-features.patch
    # For RHEL-143785 - backport support for GSO over UDP tunnel offload
    Patch115: kvm-qmp-update-virtio-features-map-to-support-extended-f.patch
    # For RHEL-143785 - backport support for GSO over UDP tunnel offload
    Patch116: kvm-vhost-backend-implement-extended-features-support.patch
    # For RHEL-143785 - backport support for GSO over UDP tunnel offload
    Patch117: kvm-vhost-net-implement-extended-features-support.patch
    # For RHEL-143785 - backport support for GSO over UDP tunnel offload
    Patch118: kvm-virtio-net-implement-extended-features-support.patch
    # For RHEL-143785 - backport support for GSO over UDP tunnel offload
    Patch119: kvm-net-implement-tunnel-probing.patch
    # For RHEL-143785 - backport support for GSO over UDP tunnel offload
    Patch120: kvm-net-implement-UDP-tunnel-features-offloading.patch
    # For RHEL-147425 - virtiofs: processes become stuck in request_wait_answer on virtiofs mounts
    Patch121: kvm-vhost-user-make-vhost_set_vring_file-synchronous.patch
    # For RHEL-132749 - Migrate SCSI PR state and preempt reservation upon live migration
    Patch122: kvm-scsi-generalize-scsi_SG_IO_FROM_DEV-to-scsi_SG_IO.patch
    # For RHEL-132749 - Migrate SCSI PR state and preempt reservation upon live migration
    Patch123: kvm-scsi-add-error-reporting-to-scsi_SG_IO.patch
    # For RHEL-132749 - Migrate SCSI PR state and preempt reservation upon live migration
    Patch124: kvm-scsi-track-SCSI-reservation-state-for-live-migration.patch
    # For RHEL-132749 - Migrate SCSI PR state and preempt reservation upon live migration
    Patch125: kvm-scsi-save-load-SCSI-reservation-state.patch
    # For RHEL-132749 - Migrate SCSI PR state and preempt reservation upon live migration
    Patch126: kvm-docs-add-SCSI-migrate-pr-documentation.patch
    # For RHEL-134989 - Hotplugged interface device can not be shown in the guest
    # For RHEL-146584 - [RHEL-10.2][ARM]: Unable to Check the mem prefetched size on Guest
    Patch127: kvm-Revert-hw-arm-virt-Use-ACPI-PCI-hotplug-by-default-f.patch
    # For RHEL-153058 - Qemu crashes with "double free" during restore --reset-nvram with uefi-vars secure boot
    Patch128: kvm-hw-uefi-add-variable-digest-to-vmstate.patch
    # For RHEL-144004 - [rhel-10] Regression in BLOCK_IO_ERROR event delivery with (w|r)error setting of 'stop' or 'enospc' due to event rate limiting
    Patch129: kvm-block-Never-drop-BLOCK_IO_ERROR-with-action-stop-for.patch
EOF
)

while read -r NUM FILE; do
    #echo "NUM: $NUM FILE: $FILE"
    patch -p1 < "../$FILE"
done <<< "$PATCHLIST"

