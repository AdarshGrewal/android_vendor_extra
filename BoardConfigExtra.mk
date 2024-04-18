# Google Apps
ifneq ($(BUILD_VANILLA), true)
include vendor/gms/products/board.mk
include vendor/gms-pixel/products/board.mk

SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
	vendor/extra/sepolicy/common/dynamic

endif
