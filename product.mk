ifneq ($(BUILD_VANILLA), true)
# Fonts
PRODUCT_PACKAGES += \
    FontGoogleSansOverlay

PRODUCT_PACKAGES += \
	fonts_customization.google-sans

PRODUCT_COPY_FILES += \
    vendor/extra/prebuilt/common/fonts/GoogleSansClock-Regular.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/GoogleSansClock-Regular.ttf \
    vendor/extra/prebuilt/common/fonts/GoogleSans-Italic.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/GoogleSans-Italic.ttf \
    vendor/extra/prebuilt/common/fonts/GoogleSans-Regular.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/GoogleSans-Regular.ttf

$(call inherit-product, vendor/pixel/products/gms.mk)

# Overlay
PRODUCT_PACKAGES += \
    ExtraFrameworksResTarget \
    ExtraLineageSDKOverlay \
    ExtraSettingsResTarget

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/extra/overlay
DEVICE_PACKAGE_OVERLAYS += vendor/extra/overlay/common

endif

PRODUCT_PACKAGES += \
    ExtraPIFrameworksResTarget

# MiuiCamera
$(call inherit-product-if-exists, vendor/xiaomi/$(shell echo -n $(TARGET_PRODUCT) | sed -e 's/^[a-z]*_//g')-miuicamera/products/miuicamera.mk)
