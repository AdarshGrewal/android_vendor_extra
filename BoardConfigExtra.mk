# Google Apps
ifneq ($(BUILD_VANILLA), true)
include vendor/pixel/products/board.mk
endif

# Sepolicy
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
    vendor/extra/sepolicy/private

# MiuiCamera
-include vendor/xiaomi/$(PRODUCT_DEVICE)-miuicamera/products/board.mk
