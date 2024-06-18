# Google Apps
ifneq ($(BUILD_VANILLA), true)
include vendor/pixel/products/board.mk
endif

# MiuiCamera
-include vendor/xiaomi/$(PRODUCT_DEVICE)-miuicamera/products/board.mk
