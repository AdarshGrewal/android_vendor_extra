#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

ifneq ($(BUILD_VANILLA), true)
fonts_customization := $(TARGET_OUT_PRODUCT)/etc/fonts_customization.xml
fonts_customization_dummy := $(TARGET_OUT_PRODUCT)/etc/fonts_customization.dummy.xml

$(fonts_customization_dummy): $(fonts_customization)
	if ! grep -Fq "google-sans" $(fonts_customization); then \
		sed -i 's|</fonts-modification>||' $(fonts_customization); \
		cat vendor/extra/fonts/font.google-sans.xml >> $(fonts_customization); \
		echo "</fonts-modification>" >> $(fonts_customization); \
	fi

ALL_DEFAULT_INSTALLED_MODULES += $(fonts_customization_dummy)
endif
