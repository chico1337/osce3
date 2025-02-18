# Quickstart local VM
On Kali
```
git clone https://github.com/chico1337/osce3.git && cd osce3/osed && chmod +x ./osed-setup-local.sh && ./osed-setup-local.sh
```
```
└─$ git clone https://github.com/chico1337/osce3.git && cd osce3/osed && chmod +x ./osed-setup-local.sh && ./osed-setup-local.sh
Cloning into 'osce3'...
remote: Enumerating objects: 113, done.
remote: Counting objects: 100% (113/113), done.
remote: Compressing objects: 100% (75/75), done.
remote: Total 113 (delta 45), reused 65 (delta 21), pack-reused 0 (from 0)
Receiving objects: 100% (113/113), 24.11 MiB | 10.80 MiB/s, done.
Resolving deltas: 100% (45/45), done.
[+] Once SMB is mounted, execute the following command in an Administrator cmd:

============================================================
powershell -c "cat \\192.168.219.128\setup-uwu\osed-setup-win-local.ps1 | powershell -"
============================================================

[+] Mounting SMB share in current dir
```



# Quickstart exam

On Kali
```
git clone https://github.com/chico1337/osce3.git; cd osce3/osed; chmod +x ./osed-setup.sh
```
Results
```
./osed-setup.sh $IP_WindowsVM
[=] Cloning repository https://github.com/chico1337/osce3.git
Cloning into 'osce3'...
remote: Enumerating objects: 104, done.
remote: Counting objects: 100% (104/104), done.
remote: Compressing objects: 100% (67/67), done.
remote: Total 104 (delta 41), reused 67 (delta 22), pack-reused 0 (from 0)
Receiving objects: 100% (104/104), 24.11 MiB | 11.92 MiB/s, done.
Resolving deltas: 100% (41/41), done.
[+] Once the RDP window opens, execute the following command in an Administrator cmd:

============================================================
powershell -c "cat \\tsclient\setup-uwu\osed-setup-win.ps1 | powershell -"
============================================================

[+] The SMB share is mounted at /tmp/tmp.VaBCSxBbh6 and will remain attached.
[+] To unmount the SMB share and clean up the temporary files, press Ctrl+C or run the following command:
============================================================
rm -rf /tmp/tmp.VaBCSxBbh6
============================================================
Autoselecting keyboard map 'en-us' from locale
```


On Windows VM, open adminstrator cmd and
```
powershell -c "cat \\tsclient\setup-uwu\osed-setup-win.ps1 | powershell -"

```

















# osed-scripts
bespoke tooling for offensive security's Windows Usermode Exploit Dev course (OSED)

## Table of Contents

- [Standalone Scripts](#standalone-scripts)
    - [egghunter.py](#egghunterpy)
    - [find-gadgets.py](#find-gadgetspy)
    - [shellcoder.py](#shellcoderpy)
    - [install-mona.sh](#install-monash)
    - [attach-process.ps1](#attach-processps1)
- [WinDbg Scripts](#windbg-scripts)
    - [find-ppr.py](#find-pprpy)
    - [find-bad-chars.py](#find-bad-charspy)
    - [search.py](#searchpy)

### install-mona.sh

downloads all components necessary to install mona and prompts you to use an admin shell on the windows box to finish installation.

```
❯ ./install-mona.sh 192.168.XX.YY
[+] once the RDP window opens, execute the following command in an Administrator terminal:

powershell -c "cat \\tsclient\mona-share\install-mona.ps1 | powershell -"

[=] downloading https://github.com/corelan/windbglib/raw/master/pykd/pykd.zip
[=] downloading https://github.com/corelan/windbglib/raw/master/windbglib.py
[=] downloading https://github.com/corelan/mona/raw/master/mona.py
[=] downloading https://www.python.org/ftp/python/2.7.17/python-2.7.17.msi
[=] downloading https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x86.exe
[=] downloading https://raw.githubusercontent.com/epi052/osed-scripts/main/install-mona.ps1
Autoselecting keyboard map 'en-us' from locale
Core(warning): Certificate received from server is NOT trusted by this system, an exception has been added by the user to trust this specific certificate.
Failed to initialize NLA, do you have correct Kerberos TGT initialized ?
Core(warning): Certificate received from server is NOT trusted by this system, an exception has been added by the user to trust this specific certificate.
Connection established using SSL.
Protocol(warning): process_pdu_logon(), Unhandled login infotype 1
Clipboard(error): xclip_handle_SelectionNotify(), unable to find a textual target to satisfy RDP clipboard text request

```

### attach-process.ps1

Credit to discord user @SilverStr for the inspiration! 

One-shot script to perform the following actions:
- start a given service (if `-service-name` is provided)
- start a given executable path (if `-path` is provided)
- start windbg and attach to the given process
- run windbg commands after attaching (if `-commands` is provided)
- restart a given service when windbg exits (if `-service-name` is provided)

The values for `-service-name`, `-process-name`, and `-path` are tab-completable.

```
.\attach-process.ps1 -service-name fastbackserver -process-name fastbackserver -commands '.load pykd; bp fastbackserver!recvfrom'
```

```
\\tsclient\shared\osed-scripts\attach-process.ps1 -service-name 'Sync Breeze Enterprise' -process-name syncbrs
```

```
 \\tsclient\share\osed-scripts\attach-process.ps1 -path C:\Windows\System32\notepad.exe -process-name notepad                       
 ```

This script can be run inside a while loop for maximum laziness! Also, you can do things like `g` to start the process, followed by commands you'd like to run once the next break is hit. 

```
while ($true) {\\tsclient\shared\osed-scripts\attach-process.ps1 -process-name PROCESS_NAME -commands '.load pykd; bp SOME_ADDRESS; g; !exchain' ;}
```

Below, the process will load pykd, set a breakpoint (let's assume a pop-pop-ret gadget) and then resume execution. Once it hits the first access violation, it will run `!exchain` and then `g` to allow execution to proceed until it hits PPR gadget, after which it steps thrice using `p`, bringing EIP to the instruction directly following the pop-pop-ret. 

```
while ($true) {\\tsclient\shared\osed-scripts\attach-process.ps1 -process-name PROCESS_NAME -commands '.load pykd; bp PPR_ADDRESS; g; !exchain; g; p; p; p;' ;}
```

