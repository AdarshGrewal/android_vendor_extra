ifneq ($(BUILD_VANILLA), true)

# Gsans
$(call inherit-product, vendor/google_sans/product.mk)

# Pixel clocks
$(call inherit-product, vendor/pixel_clocks/product.mk)

# Pixel launcher
$(call inherit-product, vendor/pixel_launcher/product.mk)

# Overlay
PRODUCT_PACKAGES += \
    ExtraLineageSDKOverlay \
    ExtraSettingsResTarget \
    ExtraUpdaterOverlay_GMS
else
PRODUCT_PACKAGES += \
    ExtraUpdaterOverlay
endif

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

# Overlay
PRODUCT_PACKAGES += \
    ExtraPIFrameworksResTarget

# MiuiCamera
$(call inherit-product-if-exists, device/xiaomi/$(shell echo -n $(TARGET_PRODUCT) | sed -e 's/^[a-z]*_//g')-miuicamera/device.mk)
