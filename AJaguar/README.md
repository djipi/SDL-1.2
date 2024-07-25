# SDL 1.2 Atari Jaguar library

## Port
- [x] cpuinfo
No particular port has been made, the M68000 has nothing in comparison with modern cpus.
- [x] joystick
Standard joypad only (including Atari Team Tap), use of The Removers' library.
- [x] stdlib
No particular port has been made, these are C library functions.
- [x] timer
Only ticks are supported.

## Stand-by
- [ ] Audio
- [ ] cdrom
- [ ] events
- [ ] file
- [ ] video

## Not supported
- [ ] loadso
A code sharing emulation could be done with overlays.
- [ ] main
There are no particular reasons to have a specific main function for SDL. The port follows the SDL initisalizations requirements.
- [ ] thread
There is no multi-threading on the M68000. But may be, a such things could be possible with some GPU/DSP coding.