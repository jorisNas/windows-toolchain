@echo off

if not exist ".\out\" mkdir out
pushd out

:: root path of the toolchain and installer archive
set BASEDIR=%~dp0..\

pushd %BASEDIR%
echo Base driectory to create the installer for: %CD%
popd

:: convert symbolic links to a format that is preseved
:: in the cap archive inside the installation
:: opposite is done after installation
echo.Symlinks: Backing up
call %BASEDIR%\toolchain\symlinks-backup-before-install.bat

..\wix311-binaries\heat.exe ^
dir %BASEDIR% ^
-out heat.wxs ^
-dr INSTALLDIR ^
-cg MainComponents ^
-gg -g1 -sreg -srd -sfrag -ke ^
-t ..\exclude.xlst

..\wix311-binaries\candle.exe ..\PX4.wxs ..\ui.wxs heat.wxs

..\wix311-binaries\light.exe ^
-ext WixUIExtension ^
heat.wixobj PX4.wixobj ui.wixobj ^
-b %BASEDIR% ^
-loc ..\custom_ui_text.wxl ^
-out "PX4 Toolchain.msi"

echo.Symlinks: Removing Backup
call %BASEDIR%\toolchain\symlinks-remove-backup.bat

:: go out of install folder
popd

pause