#!/bin/bash

# Getting IP Address
IP_ADDR=$(hostname -I | awk '{print $1}')

# Instructions
echo "[+] Once SMB is mounted, execute the following command in an Administrator cmd:"
echo
echo "============================================================"
echo "powershell -c \"cat \\\\$IP_ADDR\\setup-uwu\\osed-setup-win-local.ps1 | powershell -\""
echo "============================================================"
echo

# Mount the SMB share
echo "[+] Mounting SMB share in current dir"
impacket-smbserver setup-uwu . -smb2support &> /dev/null &


if [ $? -ne 0 ]; then
    echo "[!] Error: Failed to mount SMB share. Exiting."
    exit 1
fi


# Keep the script running indefinitely until Ctrl+C is pressed
while true; do
    sleep 1
done

