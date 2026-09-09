# Pixel
$(call inherit-product, vendor/pixel/clocks/products/clocks.mk)

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED ?= true

ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)
PRODUCT_PACKAGES += \
    FaceUnlock

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.face.sense_service=true

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif

# MiuiCamera
$(call inherit-product-if-exists, device/xiaomi/$(shell echo -n $(TARGET_PRODUCT) | sed -e 's/^[a-z]*_//g')-miuicamera/device.mk)

# Overlay
ifeq ($(WITH_GMS), true)
PRODUCT_PACKAGES += \
    ExtraUpdaterOverlay_GMS
endif

PRODUCT_PACKAGES += \
    ExtraSettingsResTarget \
    ExtraUpdaterOverlay

# Spoofify
PRODUCT_PACKAGES += \
    Spoofify
