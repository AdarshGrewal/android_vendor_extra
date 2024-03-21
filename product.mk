ifneq ($(BUILD_VANILLA), true)
# Audio
TARGET_EXCLUDES_AUDIOFX := true

# Fonts
PRODUCT_COPY_FILES += \
    vendor/extra/prebuilt/common/fonts/GoogleSansClock-Regular.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/GoogleSansClock-Regular.ttf \
    vendor/extra/prebuilt/common/fonts/GoogleSans-Italic.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/GoogleSans-Italic.ttf \
    vendor/extra/prebuilt/common/fonts/GoogleSans-Regular.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/GoogleSans-Regular.ttf

# Google Apps
WITH_GMS := true
$(call inherit-product, vendor/gms/products/gms.mk)

PRODUCT_PRODUCT_PROPERTIES += \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural;com.google.android.systemui.gxoverlay

PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.kb_pad_port_l=4 \
    ro.com.google.ime.kb_pad_port_r=4 \
    ro.com.google.ime.kb_pad_land_l=64 \
    ro.com.google.ime.kb_pad_land_r=64

# Overlay
PRODUCT_PACKAGES += \
    ExtraFrameworksResTarget \
    ExtraLineageSDKOverlay \
    ExtraSettingsResTarget

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/extra/overlay
DEVICE_PACKAGE_OVERLAYS += vendor/extra/overlay/common

endif
