// testoverlay's arguments list


// Arguments list
char* NXArgv[] = {
	(char*)"testoverlay.elf",
	(char*)"-delay",
	(char*)"1",
	(char*)"-width",
	(char*)"320",
	(char*)"-height",
	(char*)"240",
	(char*)"-bpp",
	(char*)"8",
	(char*)"-lum",
	(char*)"1",				// unknown values
	(char*)"-format",
	(char*)"YV12",			// YV12. IYUV, YUY2, UYVY, or YVYU
	(char*)"-hw",
	(char*)"-flip",
	(char*)"-scale",
	(char*)"-mono",
	(char*)"-h",			// can be -help
	(char*)"-fullscreen",
};

// Number of argument
int NXArgc = sizeof(NXArgv)/sizeof(char*);
