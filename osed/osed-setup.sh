#!/bin/bash

# Temporary directory and share setup
TMPDIR=$(mktemp -d)
SHARENAME="setup-uwu"
SHARE="\\\\tsclient\\$SHARENAME"

# Hardcoded RDP credentials
RDP_USER="offsec"
RDP_PASS="lab"

# Check if the IP address was provided as an argument
if [ -z "$1" ]; then
    # If no argument, prompt the user for an IP address
    read -p "Please enter the IP address of the target: " IP
else
    IP=$1
fi

# Move into the temporary directory
cd $TMPDIR

# Clone the repository and handle errors
echo "[=] Cloning repository https://github.com/chico1337/osce3.git"
if ! git clone https://github.com/chico1337/osce3.git; then
    echo "[!] Error: Failed to clone the repository. Exiting."
    exit 1
fi

# Display instructions for executing the command
echo "[+] Once the RDP window opens, execute the following command in an Administrator cmd:"
echo
echo "============================================================"
echo "powershell -c \"cat $SHARE\\osed-setup-win.ps1 | powershell -\""
echo "============================================================"
echo

# Use rdesktop to connect, passing in the provided IP address and hardcoded credentials
# Redirect stdout to /dev/null but keep stderr for errors, run in background using "&"
rdesktop ${IP} -u "$RDP_USER" -p "$RDP_PASS" -r disk:$SHARENAME=$TMPDIR/osce3/osed/ &

# Inform the user that the SMB share will remain attached
echo "[+] The SMB share is mounted at $TMPDIR and will remain attached."

# Provide instructions for manual cleanup
echo "[+] To unmount the SMB share and clean up the temporary files, press Ctrl+C or run the following command:"
echo "============================================================"
echo "rm -rf $TMPDIR"
echo "============================================================"

# Trap to clean up temporary files on Ctrl+C
trap "echo '[+] Unmounting SMB share and cleaning up...'; rm -rf $TMPDIR; exit 0" SIGINT

# Keep the script running indefinitely until Ctrl+C is pressed
while true; do
    sleep 1
done

