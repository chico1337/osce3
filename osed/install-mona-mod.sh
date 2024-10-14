#!/bin/bash

# List of tools to download
TOOLS=("https://github.com/corelan/windbglib/raw/master/pykd/pykd.zip" "https://github.com/corelan/windbglib/raw/master/windbglib.py" "https://github.com/corelan/mona/raw/master/mona.py" "https://www.python.org/ftp/python/2.7.17/python-2.7.17.msi" "https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x86.exe" "https://raw.githubusercontent.com/epi052/osed-scripts/main/install-mona.ps1")

# Temporary directory and share setup
TMPDIR=$(mktemp -d)
SHARENAME="mona-share"
SHARE="\\\\tsclient\\$SHARENAME"

# Check if the IP address was provided as an argument
if [ -z "$1" ]; then
    # If no argument, prompt the user for an IP address
    read -p "Please enter the IP address of the target: " IP
else
    # If an argument is provided, use it as the IP address
    IP=$1
fi

# Trap to clean up temporary files on SIGINT (Ctrl+C)
trap "rm -rf $TMPDIR" SIGINT 

# Move into the temporary directory
pushd $TMPDIR >/dev/null

# Display instructions for executing the command
echo "[+] Once the RDP window opens, execute the following command in an Administrator terminal:"
echo
echo "powershell -c \"cat $SHARE\\install-mona.ps1 | powershell -\""
echo

# Download all the tools
for tool in "${TOOLS[@]}"; do
    echo "[=] Downloading $tool"
    wget -q "$tool"
done

# Unzip the downloaded pykd.zip quietly
unzip -qqo pykd.zip

# Use rdesktop to connect, passing in the provided IP address
rdesktop ${IP} -u offsec -p lab -r disk:$SHARENAME=.
