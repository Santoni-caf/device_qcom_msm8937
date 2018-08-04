ALLOW_MISSING_DEPENDENCIES=true
# Enable AVB 2.0
ifneq ($(wildcard kernel/msm-4.9),)
BOARD_AVB_ENABLE := true
endif

TARGET_USES_AOSP := true
TARGET_USES_AOSP_FOR_AUDIO := false
TARGET_USES_QCOM_BSP := false

ifeq ($(TARGET_USES_AOSP),true)
TARGET_DISABLE_DASH := true
endif

DEVICE_PACKAGE_OVERLAYS := device/qcom/msm8937_64/overlay
# Default vendor configuration.
ifeq ($(ENABLE_VENDOR_IMAGE),)
ENABLE_VENDOR_IMAGE :=true
endif

# Disable QTIC until it's brought up in split system/vendor
# configuration to avoid compilation breakage.
ifeq ($(ENABLE_VENDOR_IMAGE), true)
#TARGET_USES_QTIC := false
endif


TARGET_USES_NQ_NFC := true

ifeq ($(TARGET_USES_NQ_NFC),true)
PRODUCT_COPY_FILES += \
    device/qcom/common/nfc/libnfc-brcm.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nci.conf
endif

ENABLE_AB ?= false

ifneq ($(wildcard kernel/msm-3.18),)
    TARGET_KERNEL_VERSION := 3.18
    $(warning "Build with 3.18 kernel.")
else ifneq ($(wildcard kernel/msm-4.9),)
    TARGET_KERNEL_VERSION := 4.9
    $(warning "Build with 4.9 kernel")
else
    $(warning "Unknown kernel")
endif

TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

-include $(QCPATH)/common/config/qtic-config.mk

# Enable features in video HAL that can compile only on this platform
TARGET_USES_MEDIA_EXTENSIONS := true

# media_profiles and media_codecs xmls for msm8937
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
PRODUCT_COPY_FILES += device/qcom/msm8937_32/media/media_profiles_8937.xml:system/etc/media_profiles.xml \
                      device/qcom/msm8937_32/media/media_profiles_8937.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_vendor.xml \
                      device/qcom/msm8937_32/media/media_profiles_8956.xml:system/etc/media_profiles_8956.xml \
                      device/qcom/msm8937_32/media/media_profiles_8956.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_8956.xml \
                      device/qcom/msm8937_32/media/media_codecs_8937.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
                      device/qcom/msm8937_32/media/media_codecs_8956.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_8956.xml \
                      device/qcom/msm8937_32/media/media_codecs_performance_8937.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
                      device/qcom/msm8937_32/media/media_codecs_vendor_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_vendor_audio.xml
endif

PRODUCT_COPY_FILES += device/qcom/msm8937_64/whitelistedapps.xml:system/etc/whitelistedapps.xml \
                      device/qcom/msm8937_64/gamedwhitelist.xml:system/etc/gamedwhitelist.xml

# video seccomp policy files
PRODUCT_COPY_FILES += \
    device/qcom/msm8937_32/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/qcom/msm8937_32/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

PRODUCT_PROPERTY_OVERRIDES += \
    vendor.vidc.disable.split.mode=1

PRODUCT_PROPERTY_OVERRIDES += \
           dalvik.vm.heapminfree=4m \
           dalvik.vm.heapstartsize=16m
$(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)
$(call inherit-product, device/qcom/common/common64.mk)

PRODUCT_NAME := msm8937_64
PRODUCT_DEVICE := msm8937_64
PRODUCT_BRAND := Android
PRODUCT_MODEL := msm8937 for arm64

PRODUCT_BOOT_JARS += tcmiface

# Kernel modules install path
KERNEL_MODULES_INSTALL := dlkm
KERNEL_MODULES_OUT := out/target/product/$(PRODUCT_NAME)/$(KERNEL_MODULES_INSTALL)/lib/modules

ifneq ($(strip $(QCPATH)),)
PRODUCT_BOOT_JARS += WfdCommon
#PRODUCT_BOOT_JARS += com.qti.dpmframework
#PRODUCT_BOOT_JARS += dpmapi
#PRODUCT_BOOT_JARS += com.qti.location.sdk
#Android oem shutdown hook
PRODUCT_BOOT_JARS += oem-services
endif

DEVICE_MANIFEST_FILE := device/qcom/msm8937_64/manifest.xml
DEVICE_MATRIX_FILE   := device/qcom/common/compatibility_matrix.xml
DEVICE_FRAMEWORK_MANIFEST_FILE := device/qcom/msm8937_64/framework_manifest.xml

# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard

# When can normal compile this module, need module owner enable below commands
# font rendering engine feature switch
#-include $(QCPATH)/common/config/rendering-engine.mk
#ifneq (,$(strip $(wildcard $(PRODUCT_RENDERING_ENGINE_REVLIB))))
#    MULTI_LANG_ENGINE := REVERIE
#    MULTI_LANG_ZAWGYI := REVERIE
#endif

ifneq ($(TARGET_DISABLE_DASH), true)
    PRODUCT_BOOT_JARS += qcmediaplayer
endif

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

# Audio configuration file
-include $(TOPDIR)hardware/qcom/audio/configs/msm8937/msm8937.mk

#Audio DLKM
ifeq ($(TARGET_KERNEL_VERSION), 4.9)
AUDIO_DLKM := audio_apr.ko
AUDIO_DLKM += audio_q6_notifier.ko
AUDIO_DLKM += audio_adsp_loader.ko
AUDIO_DLKM += audio_q6.ko
AUDIO_DLKM += audio_usf.ko
AUDIO_DLKM += audio_pinctrl_wcd.ko
AUDIO_DLKM += audio_swr.ko
AUDIO_DLKM += audio_wcd_core.ko
AUDIO_DLKM += audio_swr_ctrl.ko
AUDIO_DLKM += audio_wsa881x.ko
AUDIO_DLKM += audio_wsa881x_analog.ko
AUDIO_DLKM += audio_platform.ko
AUDIO_DLKM += audio_cpe_lsm.ko
AUDIO_DLKM += audio_hdmi.ko
AUDIO_DLKM += audio_stub.ko
AUDIO_DLKM += audio_wcd9xxx.ko
AUDIO_DLKM += audio_mbhc.ko
AUDIO_DLKM += audio_wcd9335.ko
AUDIO_DLKM += audio_wcd_cpe.ko
AUDIO_DLKM += audio_digital_cdc.ko
AUDIO_DLKM += audio_analog_cdc.ko
AUDIO_DLKM += audio_native.ko
AUDIO_DLKM += audio_machine_sdm450.ko
AUDIO_DLKM += audio_machine_ext_sdm450.ko
PRODUCT_PACKAGES += $(AUDIO_DLKM)
endif

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml

PRODUCT_PACKAGES += android.hardware.media.omx@1.0-impl

#ANT+ stack
PRODUCT_PACKAGES += \
    AntHalService \
    libantradio \
    antradio_app

# Display/Graphics
 PRODUCT_PACKAGES += \
     android.hardware.graphics.allocator@2.0-impl \
     android.hardware.graphics.allocator@2.0-service \
     android.hardware.graphics.mapper@2.0-impl \
     android.hardware.graphics.composer@2.1-impl \
     android.hardware.graphics.composer@2.1-service \
     android.hardware.memtrack@1.0-impl \
     android.hardware.memtrack@1.0-service \
     android.hardware.light@2.0-impl \
     android.hardware.light@2.0-service \
     android.hardware.configstore@1.0-service

PRODUCT_PACKAGES += wcnss_service

# FBE support
PRODUCT_COPY_FILES += \
    device/qcom/msm8937_64/init.qti.qseecomd.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qti.qseecomd.sh

# VB xml
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.verified_boot.xml:system/etc/permissions/android.software.verified_boot.xml

# MSM IRQ Balancer configuration file
PRODUCT_COPY_FILES += \
    device/qcom/msm8937_64/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf

#wlan driver
PRODUCT_COPY_FILES += \
    device/qcom/msm8937_64/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini \
    device/qcom/msm8937_32/WCNSS_wlan_dictionary.dat:persist/WCNSS_wlan_dictionary.dat \
    device/qcom/msm8937_64/WCNSS_qcom_wlan_nv.bin:persist/WCNSS_qcom_wlan_nv.bin

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf

#for wlan
PRODUCT_PACKAGES += \
    wificond \
    wifilogd
# Feature definition files for msm8937
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml

PRODUCT_PACKAGES += telephony-ext
PRODUCT_BOOT_JARS += telephony-ext

# Defined the locales
PRODUCT_LOCALES += th_TH vi_VN tl_PH hi_IN ar_EG ru_RU tr_TR pt_BR bn_IN mr_IN ta_IN te_IN zh_HK \
        in_ID my_MM km_KH sw_KE uk_UA pl_PL sr_RS sl_SI fa_IR kn_IN ml_IN ur_IN gu_IN or_IN

# When can normal compile this module, need module owner enable below commands
# Add the overlay path
#PRODUCT_PACKAGE_OVERLAYS := $(QCPATH)/qrdplus/Extension/res \
#        $(QCPATH)/qrdplus/globalization/multi-language/res-overlay \
#        $(PRODUCT_PACKAGE_OVERLAYS)
#PRODUCT_PACKAGE_OVERLAYS := $(QCPATH)/qrdplus/Extension/res \
        $(PRODUCT_PACKAGE_OVERLAYS)

# Powerhint configuration file
PRODUCT_COPY_FILES += \
     device/qcom/msm8937_64/powerhint.xml:system/etc/powerhint.xml

#Healthd packages
PRODUCT_PACKAGES += android.hardware.health@2.0-impl \
                   android.hardware.health@2.0-service \
                   libhealthd.msm

PRODUCT_FULL_TREBLE_OVERRIDE := true

PRODUCT_VENDOR_MOVE_ENABLED := true

#for android_filesystem_config.h
PRODUCT_PACKAGES += \
    fs_config_files

# Sensor HAL conf file
 PRODUCT_COPY_FILES += \
     device/qcom/msm8937_64/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf


# Enable logdumpd service only for non-perf bootimage
ifeq ($(findstring perf,$(KERNEL_DEFCONFIG)),)
    ifeq ($(TARGET_BUILD_VARIANT),user)
        PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
            ro.logdumpd.enabled=0
    else
        #PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
            ro.logdumpd.enabled=1
    endif
else
    PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
        ro.logdumpd.enabled=0
endif

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-impl \
    android.hardware.vibrator@1.0-service

# Power
PRODUCT_PACKAGES += \
    android.hardware.power@1.0-service \
    android.hardware.power@1.0-impl

PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

# Camera configuration file. Shared by passthrough/binderized camera HAL
PRODUCT_PACKAGES += camera.device@3.2-impl
PRODUCT_PACKAGES += camera.device@1.0-impl
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-impl
# Enable binderized camera HAL
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-service

PRODUCT_PACKAGES += \
    vendor.display.color@1.0-service \
    vendor.display.color@1.0-impl

PRODUCT_PACKAGES += \
    libandroid_net \
    libandroid_net_32

#Enable Lights Impl HAL Compilation
PRODUCT_PACKAGES += android.hardware.light@2.0-impl

#Thermal
PRODUCT_PACKAGES += android.hardware.thermal@1.0-impl \
                    android.hardware.thermal@1.0-service

TARGET_SUPPORT_SOTER := true

#set KMGK_USE_QTI_SERVICE to true to enable QTI KEYMASTER and GATEKEEPER HIDLs
ifeq ($(ENABLE_VENDOR_IMAGE), true)
KMGK_USE_QTI_SERVICE := true
endif

#Enable AOSP KEYMASTER and GATEKEEPER HIDLs
ifneq ($(KMGK_USE_QTI_SERVICE), true)
PRODUCT_PACKAGES += android.hardware.gatekeeper@1.0-impl \
                    android.hardware.gatekeeper@1.0-service \
                    android.hardware.keymaster@3.0-impl \
                    android.hardware.keymaster@3.0-service
endif

#Enable KEYMASTER 4.0 for Android P not for OTA's
ifeq ($(strip $(TARGET_KERNEL_VERSION)), 4.9)
    ENABLE_KM_4_0 := true
endif

ifeq ($(ENABLE_KM_4_0), true)
    DEVICE_MANIFEST_FILE += device/qcom/msm8937_64/keymaster.xml
else
    DEVICE_MANIFEST_FILE += device/qcom/msm8937_64/keymaster_ota.xml
endif

PRODUCT_PROPERTY_OVERRIDES += rild.libpath=/vendor/lib64/libril-qc-qmi-1.so
PRODUCT_PROPERTY_OVERRIDES += vendor.rild.libpath=/vendor/lib64/libril-qc-qmi-1.so

ifeq ($(TARGET_HAS_LOW_RAM), true)
PRODUCT_PROPERTY_OVERRIDES += persist.radio.multisim.config=ssss
endif

ifeq ($(ENABLE_AB),true)
#A/B related packages
PRODUCT_PACKAGES += update_engine \
                   update_engine_client \
                   update_verifier \
                   bootctrl.msm8937 \
                   brillo_update_payload \
                   android.hardware.boot@1.0-impl \
                   android.hardware.boot@1.0-service
#Boot control HAL test app
PRODUCT_PACKAGES_DEBUG += bootctl
endif

TARGET_MOUNT_POINTS_SYMLINKS := false

SDM660_DISABLE_MODULE := true
# When AVB 2.0 is enabled, dm-verity is enabled differently,
# below definitions are only required for AVB 1.0
ifeq ($(BOARD_AVB_ENABLE),false)
# dm-verity definitions
  PRODUCT_SUPPORTS_VERITY := true
endif

ifeq ($(strip $(TARGET_KERNEL_VERSION)), 4.9)
    # Enable vndk-sp Libraries
    PRODUCT_PACKAGES += vndk_package
    PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true
    TARGET_USES_MKE2FS := true
    $(call inherit-product, build/make/target/product/product_launched_with_p.mk)
endif
