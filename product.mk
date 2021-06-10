# Google Apps
ifneq ($(BUILD_VANILLA), true)
WITH_GMS := true
$(call inherit-product, vendor/gms/products/gms.mk)
endif
