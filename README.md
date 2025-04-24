# Magisk Tailscaled

This repository contains a Magisk and KernelSU module for running Tailscale on rooted Android devices.

## Quick Start & Installation

1. Download the latest zip file from the [Releases](https://github.com/mgksu/tailscaled/releases/latest) page.
2. Install the downloaded zip file using Magisk & reboot your phone.
3. Open the Terminal.
4. Login with `su -c tailscale login`
5. Disable accept-dns `su -c tailscale set --accept-dns=false`
6. Run 'tailscale login' to login to your Tailscale account.
7. Open the URL in a browser to authorize your device.
8. Run 'tailscale ip' to retrieve your Tailscale IP.
9. Alternatively, you can open the [Tailscale Admin Dashboard](https://login.tailscale.com/admin/machines) to manage your devices.

After installation, the Tailscale daemon (`tailscaled`) will run automatically on boot.

## Limitation

- This module only support `arm64` architecture, you can download manually for other architecture.

## Available command

- `tailscale`: This command is execute tailscale operation.
- `tailscaled`: This command is execute tailscaled daemon operation.
- `tailscaled.service`: This command for manage tailscaled service, you can start,stop,restart daemon and view live logs the tailscaled operation.

### Cannot access other tailnet devices

1. Verify that `tailscaled.service` is running. If not, restart it with `tailscaled.service restart`.
2. Check if your device is connected to tailscaled and try a ping connection with `tailscale ping <your_tailnet_ip>`.
3. Verify the port you want to access is accessible. You can do this by accessing it with another tailscale device or using the Tailscale Android App.

### Other Error & Bugs

You can explore to the issue tab, if there not exists, you can open issue, for help me resolve the problem, you can include fresh log.

1. Restart tailscaled with `tailscaled.service restart`
2. Reproduce what are you doing which has problem.
3. Get log at `/data/adb/tailscale/run/tailscaled.log`

## Notes

This module is confirmed to be supported for KernelSU

## Credits

- [Tailscale Inc & AUTHORS](https://github.com/tailscale/tailscale). for the static binaries of tailscale & tailscaled
- [John Wu & Authors](https://github.com/topjohnwu/Magisk). for The Magic Mask for Android

- [ANASFANANI & AUTHORS](https://github.com/anasfanani/Magisk-Tailscaled). for the repo structure.