while ($true) {
    try {
        C:\Users\Offsec\Desktop\setup-uwu\attach-process.ps1 -path C:\Windows\System32\notepad.exe -process-name notepad -commands '.load pykd.pyd'
    }
    catch {
        Write-Error "An error occurred: $_"
        #break  # Optional: remove this line if you want the loop to continue despite errors
    }
    Start-Sleep -Seconds 3
}


# .\attach-process.ps1 -service-name 'Disk Pulse Enterprise' -process-name 'diskpls' -commands '.load pykd.pyd; bp 0x101576c0;g;t;t;t'
# .\attach-process.ps1 -service-name 'Sync Breeze Enterprise' -process-name 'syncbrs' -commands '.load pykd.pyd; bp 0x101576c0;g;t;t;t'
# .\attach-process.ps1 -process-name 'egghhunter_extra_mile' -commands '.load pykd.pyd;bp 0x66601113; g'

