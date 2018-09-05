# config.mk
#
# Product-specific compile-time definitions.
#

TARGET_BOARD_PLATFORM := msm8937
# This value will be shown on fastboot menu
TARGET_BOOTLOADER_BOARD_NAME := QC_Reference_Phone

TARGET_COMPILE_WITH_MSM_KERNEL := true
TARGET_KERNEL_APPEND_DTB := true
BOARD_USES_GENERIC_AUDIO := true

-include $(QCPATH)/common/msm8937_64/BoardConfigVendor.mk

# bring-up overrides
BOARD_USES_GENERIC_AUDIO := true

# Force camera module to be compiled only in 32-bit mode on 64-bit systems
# Once camera module can run in the native mode of the system (either
# 32-bit or 64-bit), the following line should be deleted
BOARD_QTI_CAMERA_32BIT_ONLY := true

# Enables CSVT
TARGET_USES_CSVT := true

NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53
#USE_CLANG_PLATFORM_BUILD := true
TARGET_CPU_CORTEX_A53 := true

TARGET_NO_BOOTLOADER := false
TARGET_NO_KERNEL := false
BOOTLOADER_GCC_VERSION := arm-eabi-4.8
BOOTLOADER_PLATFORM := msm8952 # use msm8937 LK configuration
#MALLOC_IMPL := dlmalloc
MALLOC_SVELTE := true

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 0x04000000

ifeq ($(ENABLE_AB),true)
#A/B related defines
AB_OTA_UPDATER := true
# Full A/B partiton update set
#   AB_OTA_PARTITIONS := xbl rpm tz hyp pmic modem abl boot keymaster cmnlib cmnlib64 system bluetooth
# Subset A/B partitions for Android-only image update
AB_OTA_PARTITIONS ?= boot system
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
TARGET_NO_RECOVERY := true
BOARD_USES_RECOVERY_AS_BOOT := true
else
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x04000000
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_RECOVERY_UPDATER_LIBS += librecovery_updater_msm
# Enable System As Root even for non-A/B from P onwards
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
endif

ifneq ($(wildcard kernel/msm-3.18),)
    ifeq ($(ENABLE_AB),true)
      ifeq ($(ENABLE_VENDOR_IMAGE), true)
        TARGET_RECOVERY_FSTAB := device/qcom/msm8937_64/fstabs-3.18/recovery_AB_split_variant.fstab
      else
        TARGET_RECOVERY_FSTAB := device/qcom/msm8937_64/fstabs-3.18/recovery_AB_non-split_variant.fstab
      endif
    else
      ifeq ($(ENABLE_VENDOR_IMAGE), true)
        TARGET_RECOVERY_FSTAB := device/qcom/msm8937_64/fstabs-3.18/recovery_non-AB_split_variant.fstab
      else
        TARGET_RECOVERY_FSTAB := device/qcom/msm8937_64/fstabs-3.18/recovery_non-AB_non-split_variant.fstab
      endif
    endif
else ifneq ($(wildcard kernel/msm-4.9),)
    ifeq ($(ENABLE_AB),true)
      ifeq ($(ENABLE_VENDOR_IMAGE), true)
        TARGET_RECOVERY_FSTAB := device/qcom/msm8937_64/fstabs-4.9/recovery_AB_split_variant.fstab
      else
        TARGET_RECOVERY_FSTAB := device/qcom/msm8937_64/fstabs-4.9/recovery_AB_non-split_variant.fstab
      endif
    else
      ifeq ($(ENABLE_VENDOR_IMAGE), true)
        TARGET_RECOVERY_FSTAB := device/qcom/msm8937_64/fstabs-4.9/recovery_non-AB_split_variant.fstab
      else
        TARGET_RECOVERY_FSTAB := device/qcom/msm8937_64/fstabs-4.9/recovery_non-AB_non-split_variant.fstab
      endif
    endif
else
    $(warning "Unknown kernel")
endif

BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
BOARD_USERDATAIMAGE_PARTITION_SIZE := 1971322880
BOARD_PERSISTIMAGE_PARTITION_SIZE := 33554432
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_OEMIMAGE_PARTITION_SIZE := 268435456
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)
ifeq ($(TARGET_KERNEL_VERSION), 4.9)
BOARD_DTBOIMG_PARTITION_SIZE := 0x0800000
endif

ifeq ($(ENABLE_VENDOR_IMAGE), true)
BOARD_VENDORIMAGE_PARTITION_SIZE := 1073741824
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
endif

# Enable kaslr seed support
ifeq ($(TARGET_KERNEL_VERSION), 4.9)
KASLRSEED_SUPPORT := true
endif

# Enable suspend during charger mode
BOARD_CHARGER_ENABLE_SUSPEND := true
BOARD_CHARGER_DISABLE_INIT_BLANK := true

# Added to indicate that protobuf-c is supported in this build
PROTOBUF_SUPPORTED := false

TARGET_USES_ION := true
TARGET_USES_QCOM_DISPLAY_BSP := true
TARGET_USES_NEW_ION_API :=true
TARGET_USES_HWC2 := true
TARGET_USES_GRALLOC1 := true
TARGET_USES_COLOR_METADATA := true
TARGET_NO_RPC := true

ifeq ($(TARGET_KERNEL_VERSION), 4.9)
BOARD_VENDOR_KERNEL_MODULES := \
    $(KERNEL_MODULES_OUT)/audio_apr.ko \
    $(KERNEL_MODULES_OUT)/pronto_wlan.ko \
    $(KERNEL_MODULES_OUT)/audio_q6_notifier.ko \
    $(KERNEL_MODULES_OUT)/audio_adsp_loader.ko \
    $(KERNEL_MODULES_OUT)/audio_q6.ko \
    $(KERNEL_MODULES_OUT)/audio_usf.ko \
    $(KERNEL_MODULES_OUT)/audio_pinctrl_wcd.ko \
    $(KERNEL_MODULES_OUT)/audio_swr.ko \
    $(KERNEL_MODULES_OUT)/audio_wcd_core.ko \
    $(KERNEL_MODULES_OUT)/audio_swr_ctrl.ko \
    $(KERNEL_MODULES_OUT)/audio_wsa881x.ko \
    $(KERNEL_MODULES_OUT)/audio_wsa881x_analog.ko \
    $(KERNEL_MODULES_OUT)/audio_platform.ko \
    $(KERNEL_MODULES_OUT)/audio_cpe_lsm.ko \
    $(KERNEL_MODULES_OUT)/audio_hdmi.ko \
    $(KERNEL_MODULES_OUT)/audio_stub.ko \
    $(KERNEL_MODULES_OUT)/audio_wcd9xxx.ko \
    $(KERNEL_MODULES_OUT)/audio_mbhc.ko \
    $(KERNEL_MODULES_OUT)/audio_wcd9335.ko \
    $(KERNEL_MODULES_OUT)/audio_wcd_cpe.ko \
    $(KERNEL_MODULES_OUT)/audio_digital_cdc.ko \
    $(KERNEL_MODULES_OUT)/audio_analog_cdc.ko \
    $(KERNEL_MODULES_OUT)/audio_native.ko \
    $(KERNEL_MODULES_OUT)/audio_machine_sdm450.ko \
    $(KERNEL_MODULES_OUT)/audio_machine_ext_sdm450.ko
endif

ifeq ($(strip $(TARGET_KERNEL_VERSION)), 4.9)
    BOARD_KERNEL_CMDLINE := console=ttyMSM0,115200,n8 androidboot.console=ttyMSM0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 androidboot.bootdevice=7824900.sdhci earlycon=msm_serial_dm,0x78B0000 firmware_class.path=/vendor/firmware_mnt/image androidboot.usbconfigfs=true loop.max_part=7
else ifeq ($(strip $(TARGET_KERNEL_VERSION)), 3.18)
    BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 androidboot.bootdevice=7824900.sdhci earlycon=msm_hsl_uart,0x78B0000 firmware_class.path=/vendor/firmware_mnt/image loop.max_part=7
endif
#BOARD_KERNEL_SEPARATED_DT := true

BOARD_SECCOMP_POLICY := device/qcom/msm8937_32/seccomp

BOARD_KERNEL_BASE        := 0x80000000
BOARD_KERNEL_PAGESIZE    := 2048
BOARD_KERNEL_TAGS_OFFSET := 0x01E00000
BOARD_RAMDISK_OFFSET     := 0x02000000

TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_CROSS_COMPILE_PREFIX := aarch64-linux-android-
TARGET_USES_UNCOMPRESSED_KERNEL := false

# Shader cache config options
# Maximum size of the  GLES Shaders that can be cached for reuse.
# Increase the size if shaders of size greater than 12KB are used.
MAX_EGL_CACHE_KEY_SIZE := 12*1024

# Maximum GLES shader cache size for each app to store the compiled shader
# binaries. Decrease the size if RAM or Flash Storage size is a limitation
# of the device.
MAX_EGL_CACHE_SIZE := 2048*1024

BOARD_EGL_CFG := device/qcom/msm8937_64/egl.cfg
TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/
# Add NON-HLOS files for ota upgrade
ADD_RADIO_FILES := true
TARGET_INIT_VENDOR_LIB := libinit_msm

#add suffix variable to uniquely identify the board
TARGET_BOARD_SUFFIX := _64

#Enable SSC Feature
TARGET_USES_SSC := true

#PCI RCS
TARGET_USES_PCI_RCS := false

# Enable sensor multi HAL
USE_SENSOR_MULTI_HAL := true

#Enable peripheral manager
TARGET_PER_MGR_ENABLED := true

TARGET_HW_DISK_ENCRYPTION := true

TARGET_CRYPTFS_HW_PATH := device/qcom/common/cryptfs_hw

TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true

DEX_PREOPT_DEFAULT := nostripping

# Enable dex pre-opt to speed up initial boot
ifneq ($(TARGET_USES_AOSP),true)
  ifeq ($(HOST_OS),linux)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT := true
      WITH_DEXPREOPT_PIC := true
      ifneq ($(TARGET_BUILD_VARIANT),user)
        # Retain classes.dex in APK's for non-user builds
        DEX_PREOPT_DEFAULT := nostripping
      endif
    endif
  endif
endif

FEATURE_QCRIL_UIM_SAP_SERVER_MODE := true

BOARD_HAL_STATIC_LIBRARIES := libhealthd.msm

ifeq ($(strip $(TARGET_KERNEL_VERSION)), 4.9)
PMIC_QG_SUPPORT := true
endif

#Generate DTBO image
ifeq ($(TARGET_KERNEL_VERSION), 4.9)
BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_SYSTEMSDK_VERSIONS :=28
BOARD_VNDK_VERSION := current
endif

TARGET_ENABLE_MEDIADRM_64 := true

ifeq ($(TARGET_KERNEL_VERSION), 4.9)
TARGET_USES_LM := true
endif
