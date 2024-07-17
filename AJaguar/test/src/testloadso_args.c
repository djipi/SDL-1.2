// testloadso's arguments list


// Arguments list
char* NXArgv[] = {
	(char*)"testloadso.elf",
	(char*)"--hello",
	(char*)"essai",			// library name
	(char*)"library",		// library
	(char*)"function",		// library function name
};

// Number of arguments
int NXArgc = sizeof(NXArgv)/sizeof(char*);
