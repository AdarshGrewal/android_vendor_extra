#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

include $(CLEAR_VARS)

LOCAL_MODULE         := fonts_customization.google-sans
LOCAL_MODULE_SUFFIX  := .xml
LOCAL_MODULE_CLASS   := ETC
LOCAL_PRODUCT_MODULE := true

fonts_customization := $(TARGET_OUT_PRODUCT)/etc/fonts_customization.xml

_fonts_customization.google-sans_intermediates := $(call intermediates-dir-for,$(LOCAL_MODULE_CLASS),$(LOCAL_MODULE))
_fonts_customization.google-sans_xml := $(_fonts_customization.google-sans_intermediates)/$(LOCAL_MODULE)$(LOCAL_MODULE_SUFFIX)

$(_fonts_customization.google-sans_xml): $(fonts_customization)
	if ! grep -q "google-sans" $(fonts_customization); then \
		sed -i '/<\/fonts-modification>/d' $(fonts_customization); \
		cat vendor/extra/fonts/font.google-sans.xml >> $(fonts_customization); \
		echo "</fonts-modification>" >> $(fonts_customization); \
	fi
	touch $(_fonts_customization.google-sans_xml)


include $(BUILD_SYSTEM)/base_rules.mk
