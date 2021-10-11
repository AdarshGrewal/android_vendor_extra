# Gboard side padding
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.kb_pad_port_l=4 \
    ro.com.google.ime.kb_pad_port_r=4 \
    ro.com.google.ime.kb_pad_land_l=64 \
    ro.com.google.ime.kb_pad_land_r=64

# Google Apps
ifneq ($(BUILD_VANILLA), true)
WITH_GMS := true
$(call inherit-product, vendor/gms/products/gms.mk)
endif

# Fonts
PRODUCT_COPY_FILES += \
    vendor/extra/prebuilt/common/etc/fonts_customization.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/fonts_customization.xml \
    vendor/extra/prebuilt/common/fonts/GoogleSans-Italic.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/GoogleSans-Italic.ttf \
    vendor/extra/prebuilt/common/fonts/GoogleSans-Regular.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/GoogleSans-Regular.ttf

# Overlay
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/extra/overlay
DEVICE_PACKAGE_OVERLAYS += vendor/extra/overlay/common
