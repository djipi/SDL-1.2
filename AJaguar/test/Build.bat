@ECHO off
cls
echo.
echo Build SDL 1.2 Atari Jaguar tests library
echo.

IF %1.==. GOTO usage
if %1.==HELP. goto usage
IF %2.==. GOTO usage
make -f makefile %1 cmd=%1 mode=%2
goto end

:usage
echo:build HELP
echo -- or --
ECHO Usage
ECHO "build <all | assemble | clean[_...] | compile | config | HELP | link | makedirs | rebuild | Runtime> <Debug | Release>"
if %1.==HELP. goto HELP
goto end

:HELP
echo -----
echo all : incremental build source and assets
echo -----
echo assemble : assemble build source
echo -----
echo clean[_...] can be empty or be completed with:
echo exes : remove all executables
echo cobjs : remove the *.o files from the project (Runtime included)
echo config : remove the configuration file
ecgo CtoS : remove the asm source file generated from compilation
echo -----
echo compile : compile build source
echo -----
echo config : display the makefile configuration
echo -----
echo link : incremental build test applications
echo -----
echo makedirs : create the necessary directories
echo -----
echo rebuild : clean, rebuild sources and assets to make a fresh new library
echo -----
echo Runtime : handle the Runtime
goto end

:end
echo.
@ECHO on
