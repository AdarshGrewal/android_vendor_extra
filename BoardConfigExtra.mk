# Google Apps
ifneq ($(BUILD_VANILLA), true)
# Gsans
include vendor/google_sans/board.mk

# Pixel clocks
include vendor/pixel_clocks/board.mk

# Pixel Launcher
include vendor/pixel_launcher/board.mk

endif

# Sepolicy
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
    vendor/extra/sepolicy/private

# MiuiCamera
-include device/xiaomi/$(PRODUCT_DEVICE)-miuicamera/BoardConfig.mk
