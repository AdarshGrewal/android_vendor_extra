# Google Apps
ifneq ($(BUILD_VANILLA), true)
include vendor/pixel/products/board.mk

SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
	vendor/extra/sepolicy/common/dynamic

endif

# MiuiCamera
-include vendor/xiaomi/$(PRODUCT_DEVICE)-miuicamera/products/board.mk
