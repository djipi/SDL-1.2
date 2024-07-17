// testoverlay2's arguments list


// Arguments list
char* NXArgv[] = {
	(char*)"testoverlay2.elf",
	(char*)"-fps",
	(char*)"1",		// value range from 1 to 1000
	(char*)"-format",
	(char*)"YV12",		// YV12, IYUV, YUY2, UYVY, or YVYU
	(char*)"-scale",
	(char*)"1",		// range from 1 to 50
	(char*)"-h"		// can be -help
};

// Number of argument
int NXArgc = sizeof(NXArgv)/sizeof(char*);
