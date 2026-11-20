# SPDX-License-Identifier: Apache-2.0
# Temporary Coral diagnostic USB ADB, never enabled by default on release/user builds.
# Mirrors HeckerOS development_adb.mk; disable for distribution with:
# LUNARIS_DEV_USB_ADB=false
LUNARIS_DEV_USB_ADB ?= $(if $(filter userdebug eng,$(TARGET_BUILD_VARIANT)),true,false)

# Avoid conflicting product property assignments when the feature is toggled.
PRODUCT_PRODUCT_PROPERTIES := $(filter-out \
    ro.adb.secure=% ro.adb.secure?=% \
    ro.lunaris.dev_usb_adb=% ro.lunaris.dev_usb_adb?=%, \
    $(PRODUCT_PRODUCT_PROPERTIES))

ifeq ($(strip $(LUNARIS_DEV_USB_ADB)),true)
ifeq ($(filter userdebug eng,$(TARGET_BUILD_VARIANT)),)
$(error LUNARIS_DEV_USB_ADB=true requires userdebug or eng)
endif
PRODUCT_PRODUCT_PROPERTIES := $(filter-out \
    persist.sys.usb.config=% persist.sys.usb.config?=%, \
    $(PRODUCT_PRODUCT_PROPERTIES))
PRODUCT_PRODUCT_PROPERTIES += \
    ro.lunaris.dev_usb_adb=1 \
    ro.adb.secure=0 \
    persist.sys.usb.config=adb
else ifeq ($(strip $(LUNARIS_DEV_USB_ADB)),false)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.lunaris.dev_usb_adb=0 \
    ro.adb.secure=1
else
$(error LUNARIS_DEV_USB_ADB must be true or false)
endif
