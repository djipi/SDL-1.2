// testcdrom's arguments list


// Arguments list
char* NXArgv[] = {
	(char*)"testcdrom.elf",
	(char*)"0",			// drive #
	(char*)"-status",
	(char*)"-list",
	(char*)"-play",
	(char*)"0",			// first track
	(char*)"0",			// first frame
	(char*)"0",			// num tracks
	(char*)"0",			// num frames
	(char*)"-pause",
	(char*)"-resume",
	(char*)"-stop",
	(char*)"-eject",
	(char*)"-sleep",
	(char*)"100"			// milliseconds
};

// Number of argument
int NXArgc = sizeof(NXArgv)/sizeof(char*);
