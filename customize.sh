#!/system/bin/sh
SKIPUNZIP=0
SKIPMOUNT=false

if [ "$BOOTMODE" != true ]; then
  ui_print "! Please install in Magisk Manager or KernelSU Manager"
  ui_print "! Install from recovery is NOT supported"
  abort "-----------------------------------------------------------"
elif [ "$KSU" = true ] && [ "$KSU_VER_CODE" -lt 10670 ]; then
  abort "error: Please update your KernelSU and KernelSU Manager"
fi

SERVICE_DIR="/data/adb/service.d"

INSTALL_DIR="/data/adb/tailscale"
INSTALL_BIN_DIR="$INSTALL_DIR/bin"

if [ -f "$INSTALL_DIR/scripts/tailscaled.service" ]; then
   ui_print "- Stopping tailscaled service"
   "$INSTALL_DIR/scripts/tailscaled.service" stop 2>&1 > /dev/null
fi

if [ "$ARCH" != "arm64" ]; then
  abort "! Unsupported architecture: $ARCH"
fi

ui_print "- Creating directories"

mkdir -p "$INSTALL_DIR" "$INSTALL_BIN_DIR" "$SERVICE_DIR"

cp -r $MODPATH/tailscale/* "$INSTALL_DIR/"
mv -f $MODPATH/files/tailscale.combined "$INSTALL_BIN_DIR/tailscale"
cp -f "$INSTALL_BIN_DIR/tailscale" "$INSTALL_BIN_DIR/tailscaled"
rm -rf $MODPATH/files $MODPATH/tailscale

ui_print "- Setting permissions"
set_perm_recursive $INSTALL_DIR 0 0 0755 0755
set_perm_recursive $MODPATH/system/bin 0 0 0755 0755
set_perm $MODPATH/service.sh 0 0 0755
mv -f "$MODPATH/service.sh" "$SERVICE_DIR/tailscaled_service.sh"

ui_print "-----------------------------------------------------------"
ui_print " Instructions       "
ui_print "-----------------------------------------------------------"
ui_print "- Reboot your device."
ui_print "- Start Tailscale service :"
ui_print "  su -c 'tailscaled.service start'"
ui_print "- Login to your Tailscale account :"
ui_print "  su -c 'tailscale login'"
ui_print "  su -c 'tailscale set --accept-dns=false'"