@ECHO off
cls
echo.
echo Build SDL 1.2 Atari Jaguar library
echo.

IF %1.==. GOTO usage
if %1.==HELP. goto usage
IF %2.==. GOTO usage
make -f makefile %1 cmd=%1 mode=%2
goto end

:usage
echo Usage:
echo:build HELP
echo -- or --
ECHO "build <all | clean[_...] | compile[_...] | config | HELP | library | makedirs | rebuild> <Debug | Release>"
if %1.==HELP. goto HELP
goto end

:HELP
echo -----
echo all : incremental build source and assets
echo -----
echo clean[_...] can be empty or be completed with:
echo objs : remove the *.o files from the project (Runtime included)
echo d : remove the *.d files from the project
echo libs : remove the libraries files from the project
echo -----
echo compile[_...] can be empty or be completed with:
echo audio : audio module
echo cdrom : CD-Rom module
echo cpuinfo : CPU information module
echo events : Events module
echo file : File module
echo joystick : Joystick module
echo loadso : Loadso mobile
echo main : Main module
echo root : Root module
echo runtime : Runtime
echo stdlib : Stdlib module
echo thread: Thread moduke
echo timer : Timer module
echo video : Video module
echo -----
echo config : display the makefile configuration
echo -----
echo library : incremental build library
echo -----
echo makedirs : create the necessary directories
echo -----
echo rebuild : clean, rebuild sources and assets to make a fresh new library
goto end

:end
echo.
@ECHO on
