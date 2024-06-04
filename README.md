## powershell_cmder_cfg

The repository for settings and modules in PowerShell

## Modules

[CompressVDI](https://github.com/Serhii5465/powershell_cmder_cfg/blob/main/CompressVDI/CompressVDI.psm1) used for compressing VDI disks.


[DeployCygwin](https://github.com/Serhii5465/powershell_cmder_cfg/tree/main/DeployCygwin) - downloading Cygwin to a local directory. Script launch parameters:

* cygwin mirror: https://sunsite.icm.edu.pl/pub/cygnus/cygwin/
* arch: x86-64
* packages: [link](https://github.com/Serhii5465/powershell_cmder_cfg/blob/main/RestoreCygwin/list_packages.dat)
* --no-startmenu
* --no-desktop
* --quiet-mode


[ZeroSpace](https://github.com/Serhii5465/powershell_cmder_cfg/blob/main/ZeroSpace/ZeroSpace.psm1) - compresses free space on virtual disks in the Windows OS using the [SDelete](https://learn.microsoft.com/en-gb/sysinternals/downloads/sdelete).
