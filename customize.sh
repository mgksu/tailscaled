#!/system/bin/sh
SKIPUNZIP=1
SKIPMOUNT=false

if [ "$BOOTMODE" != true ]; then
  ui_print "! Please install in Magisk Manager or KernelSU Manager"
  ui_print "! Install from recovery is NOT supported"
  abort "-----------------------------------------------------------"
elif [ "$KSU" = true ] && [ "$KSU_VER_CODE" -lt 10670 ]; then
  abort "error: Please update your KernelSU and KernelSU Manager"
fi

SERVICE_DIR="/data/adb/service.d"

CUSTOM_DIR="/data/adb/tailscale"
CUSTOM_BIN_DIR="$CUSTOM_DIR/bin"
CUSTOM_SCRIPTS_DIR="$CUSTOM_DIR/scripts"
CUSTOM_TMP_DIR="$CUSTOM_DIR/tmp"

case $ARCH in
    arm64)   F_ARCH=$ARCH;;
    *)     ui_print "Unsupported architecture: $ARCH"; abort;;
esac

ui_print "- Extracting module files"
unzip -qqo "$ZIPFILE" -x 'META-INF/*' 'tailscale/*' 'files/*' -d "$MODPATH"

if [ -d "$CUSTOM_DIR" ]; then
    ui_print "- Cleaning up old files"
    for dir in "$CUSTOM_DIR/*"; do
        if [ "$(basename "$dir")" != "tmp" ]; then
            rm -rf "$dir"
        fi
    done
fi

ui_print "- Creating directories"
mkdir -p "$CUSTOM_DIR" "$CUSTOM_BIN_DIR" "$CUSTOM_TMP_DIR" "$CUSTOM_SCRIPTS_DIR" "$SERVICE_DIR"

ui_print "- Extracting scripts"
unzip -qqjo "$ZIPFILE" 'tailscale/bin/*' -d "$CUSTOM_BIN_DIR"
unzip -qqjo "$ZIPFILE" 'tailscale/scripts/*' -d "$CUSTOM_SCRIPTS_DIR"
unzip -qqjo "$ZIPFILE" 'tailscale/settings.ini' -d "$CUSTOM_DIR"

ui_print "- Extracting tailscale & tailscaled binaries"
unzip -qqjo "$ZIPFILE" "files/tailscaled" -d "$TMPDIR"
unzip -qqjo "$ZIPFILE" "files/tailscale" -d "$TMPDIR"
mv -f "$TMPDIR/tailscaled" "$CUSTOM_BIN_DIR/tailscaled"
mv -f "$TMPDIR/tailscale" "$CUSTOM_BIN_DIR/tailscale"

ui_print "- Setting permissions"
set_perm_recursive $CUSTOM_BIN_DIR 0 0 0755 0755
set_perm_recursive $CUSTOM_SCRIPTS_DIR 0 0 0755 0755
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
ui_print "- Read the README.md"
ui_print "- Logs :"
ui_print "  '$CUSTOM_DIR/run/'"