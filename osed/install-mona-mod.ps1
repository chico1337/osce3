$share_path = "\\tsclient\osed-share\"
$install_dir = "C:\Users\Offsec\Desktop\install-mona"

# Create installation directory if it doesn't exist
if (!(Test-Path -Path $install_dir)) {
    echo "[+] creating installation directory: $install_dir"
    mkdir $install_dir
}

# Copy all files from the SMB share to the install directory
echo "[+] copying all files from $share_path to $install_dir"
Copy-Item -Path "$share_path*" -Destination $install_dir -Recurse -Force

# Install old C++ runtime, checking if the file exists
$vc_runtime = "$install_dir\vcredist_x86.exe"
if (Test-Path $vc_runtime) {
    echo "[+] installing old C++ runtime"
    Start-Process -FilePath $vc_runtime -Wait
} else {
    echo "[!] Error: vcredist_x86.exe not found in $install_dir"
}

# Backup pykd files only if they exist
$pykd_dir = "C:\Program Files\Windows Kits\10\Debuggers\x86\winext"
if (Test-Path "$pykd_dir\pykd.pyd") {
    echo "[+] backing up old pykd files"
    Move-Item -Path "$pykd_dir\pykd.pyd" -Destination "$pykd_dir\pykd.pyd.bak" -Force
    Move-Item -Path "$pykd_dir\pykd.dll" -Destination "$pykd_dir\pykd.dll.bak" -Force
} else {
    echo "[!] pykd.pyd or pykd.dll not found, skipping backup."
}

# Install Python 2.7 if the installer exists
$python_installer = "$install_dir\python-2.7.17.msi"
if (Test-Path $python_installer) {
    echo "[+] installing Python 2.7"
    Start-Process msiexec.exe -ArgumentList "/i $python_installer /qn" -Wait
} else {
    echo "[!] Python 2.7 installer not found in $install_dir"
}

# Add Python 2.7 to the PATH if the installation directory exists
if (Test-Path "C:\Python27") {
    echo "[+] adding Python 2.7 to the PATH"
    $p = [System.Environment]::GetEnvironmentVariable('Path',[System.EnvironmentVariableTarget]::User)
    [System.Environment]::SetEnvironmentVariable('Path',"C:\Python27\;C:\Python27\Scripts;"+$p,[System.EnvironmentVariableTarget]::User)
} else {
    echo "[!] Python 2.7 installation not found."
}

# Copy mona and pykd files
echo "[+] copying mona files and fresh pykd"
Copy-Item -Path "$install_dir\windbglib.py" -Destination "C:\Program Files\Windows Kits\10\Debuggers\x86" -Force
Copy-Item -Path "$install_dir\mona.py" -Destination "C:\Program Files\Windows Kits\10\Debuggers\x86" -Force
Copy-Item -Path "$install_dir\pykd.pyd" -Destination "$pykd_dir" -Force

# Register runtime debug DLL if it exists
$vc_shared = "C:\Program Files\Common Files\Microsoft Shared\VC"
if (Test-Path "$vc_shared\msdia90.dll") {
    echo "[+] registering runtime debug DLL"
    Start-Process regsvr32 -ArgumentList "/s msdia90.dll" -Wait
} else {
    echo "[!] msdia90.dll not found, skipping registration."
}

# Debug information
echo "[=] In case you see something about symbols when running mona, try executing the following:"
echo "regsvr32 'C:\Program Files\Common Files\Microsoft Shared\VC\msdia90.dll'"

