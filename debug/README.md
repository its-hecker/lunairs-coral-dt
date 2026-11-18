# LunarisOS Coral temporary bootloop ADB diagnostics

The Coral product includes `lunaris_development_adb.mk` to match the temporary
USB debugging behavior used for HeckerOS test images.

## Default modes

- `userdebug` and `eng`: `LUNARIS_DEV_USB_ADB=true` by default. Enables
  `persist.sys.usb.config=adb` and sets `ro.adb.secure=0`, allowing a
  USB-connected computer to use ADB without a new RSA authorization prompt.
  `ro.lunaris.dev_usb_adb=1` identifies this diagnostic mode.
- `user`: secure mode by default. Builds reject
  `LUNARIS_DEV_USB_ADB=true`. Normal ADB authorization applies.
- Set `LUNARIS_DEV_USB_ADB=false` for any release or general-purpose test
  build; this explicitly sets `ro.adb.secure=1`.

**Security:** In diagnostic mode any computer physically connected to this
phone's USB port may get ADB access without asking the user. Use it only on a
dedicated testing phone with trusted physical access, and build secure images
for distribution. This does not turn on network ADB or change SELinux.

## Build

From the synced LunarisOS checkout:

```bash
LUNARIS_BUILD_VARIANT=userdebug bash .repo/local_manifests/build.sh
```

To restore standard authorization:

```bash
LUNARIS_DEV_USB_ADB=false LUNARIS_BUILD_VARIANT=userdebug bash .repo/local_manifests/build.sh
```

`userdebug` normally allows the `adb root` command, depending on ROM
configuration; ADB root is not forced by this feature.

## Capture boot logs

Connect USB and start capture on the computer **before** booting:

```bash
adb wait-for-device
adb logcat -b all -v threadtime > lunaris-live-boot.txt
```

Check the flashed image after ADB connects:

```bash
adb shell getprop ro.adb.secure
adb shell getprop ro.lunaris.dev_usb_adb
adb shell getprop sys.usb.config
adb root
```

The first two values should be `0` and `1` on the diagnostic image.
ADB can appear once Android init and USB gadget configuration are running;
this cannot capture a failure before that stage. A persistent USB setting
from a previous install may also override the initial USB default.
