// testsprite's arguments list


// Arguments list
char* NXArgv[] = {
	(char*)"testsprite.elf",
	(char*)"-width",
	(char*)"320",
	(char*)"-height",
	(char*)"240",
	(char*)"-bpp",
	(char*)"8",
	(char*)"-fast",
	(char*)"-hw",
	(char*)"-flip",
	(char*)"-debugflip",
//	(char*)"-fullscreen",
//	(char*)"-noframe",
	(char*)"1"			// num sprites
};

// Number of arguments
int NXArgc = sizeof(NXArgv)/sizeof(char*);
