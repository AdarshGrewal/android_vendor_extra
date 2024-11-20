ifneq ($(BUILD_VANILLA), true)
# Fonts
PRODUCT_PACKAGES += \
    FontGoogleSansOverlay

PRODUCT_PACKAGES += \
	fonts_customization.google-sans

PRODUCT_COPY_FILES += \
    vendor/extra/prebuilt/common/fonts/GoogleSansClock-Regular.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/GoogleSansClock-Regular.ttf \
    vendor/extra/prebuilt/common/fonts/GoogleSansFlex-Regular.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/GoogleSansFlex-Regular.ttf \
    vendor/extra/prebuilt/common/fonts/GoogleSans-Italic.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/GoogleSans-Italic.ttf \
    vendor/extra/prebuilt/common/fonts/GoogleSans-Regular.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/GoogleSans-Regular.ttf

$(call inherit-product, vendor/pixel/products/gms.mk)

# Overlay
PRODUCT_PACKAGES += \
    ExtraLineageSDKOverlay \
    ExtraSettingsResTarget \
    ExtraUpdaterOverlay_GMS

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
    ExtraPIFrameworksResTarget \
    ExtraUpdaterOverlay_GMS

# MiuiCamera
$(call inherit-product-if-exists, vendor/xiaomi/$(shell echo -n $(TARGET_PRODUCT) | sed -e 's/^[a-z]*_//g')-miuicamera/products/miuicamera.mk)
