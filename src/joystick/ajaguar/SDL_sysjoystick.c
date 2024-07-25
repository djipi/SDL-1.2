/*
    SDL - Simple DirectMedia Layer
    Copyright (C) 1997-2012 Sam Lantinga

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

    Sam Lantinga
    slouken@libsdl.org
*/
#include "SDL_config.h"

#if defined(SDL_JOYSTICK_AJAGUAR) || defined(SDL_JOYSTICK_DISABLED)

/* This is the system specific header for the SDL joystick API */

#include "SDL_joystick.h"
#include "../SDL_sysjoystick.h"
#include "../SDL_joystick_c.h"
#include "joypad.h"

// List of possible joystick devices
// Controller (17 buttons, 1 axis/D-Pad)
// Pro controller (22 buttons, 1 axis/D-Pad)
// Modified (default or Pro) with a rotary device instead of the D-Pad one
// Hypothetical analogue controller (requires spcific chipset in the console), none is known to existence

// Defines information for the joystick part
#define MAX_JOYSTICKS 8
#define MAX_BUTTONS 17
#define MAX_AXES 1
//#define MAX_HATS 0

static SDL_Joystick TabJoysticks[MAX_JOYSTICKS];
static joypad_state JoystickState;

/* Function to scan the system for joysticks.
 * This function should set SDL_numjoysticks to the number of available
 * joysticks.  Joystick 0 should be the system default joystick.
 * It should return number of available of joystick, or -1 on an unrecoverable fatal error.
 */
int SDL_SYS_JoystickInit(void)
{
#if 0
	SDL_numjoysticks = 0;
	return(0);
#else
  // there is no possibility to enumerate the connected joystick, but 8 devices can be connected via teamtap
  SDL_memset(&TabJoysticks, 0, sizeof(TabJoysticks));
  short i = 0;
  for (;i < MAX_JOYSTICKS; i++)
  {
     TabJoysticks[i].index = i;
    TabJoysticks[i].name = SDL_malloc(8);
    SDL_snprintf((char*)TabJoysticks[i].name, 8, "joypad%i", (i + 1));
  }
   
	return (SDL_numjoysticks = MAX_JOYSTICKS);
#endif
}

/* Function to get the device-dependent name of a joystick */
const char *SDL_SYS_JoystickName(int index)
{
  #if 0
	SDL_SetError("Logic error: No joysticks available");
	return(NULL);
  #else
  short i;
  for (i = 0; i < MAX_JOYSTICKS; i++)
  {
    if (index == TabJoysticks[i].index)
    {
    return TabJoysticks[i].name;
    }
  }
  return NULL;
  #endif
}

/* Function to open a joystick for use.
   The joystick to open is specified by the index field of the joystick.
   This should fill the nbuttons and naxes fields of the joystick structure.
   It returns 0, or -1 if there is an error.
 */
int SDL_SYS_JoystickOpen(SDL_Joystick *joystick)
{
#if 0
	SDL_SetError("Logic error: No joysticks available");
	return(-1);
#else
  // fill nbuttons, naxes, and nhats fields
	joystick->nbuttons = MAX_BUTTONS;
	joystick->naxes = MAX_AXES;
	//joystick->nhats = MAX_HATS;
  // open count increase
  joystick->ref_count++;
  return 0;
#endif
}

/* Function to update the state of a joystick - called as a device poll.
 * This function shouldn't update the joystick structure directly,
 * but instead should call SDL_PrivateJoystick*() to deliver events
 * and update joystick device state.
 */
void SDL_SYS_JoystickUpdate(SDL_Joystick *joystick)
{
  #if 0
	return;
  #else
  // read joystick's value
  read_joypad_state(&JoystickState);
  unsigned long s = *(unsigned long*)(&JoystickState + (joystick->index * sizeof(unsigned long)));
  // get axis's value
  long ax = s & (JOYPAD_UP | JOYPAD_DOWN | JOYPAD_RIGHT | JOYPAD_LEFT);
  SDL_PrivateJoystickAxis(joystick, 0, ax);
  // get button's value
  long bt = (s >> 4);
  SDL_PrivateJoystickButton(joystick, 0, bt);
  #endif
}

/* Function to close a joystick after use */
void SDL_SYS_JoystickClose(SDL_Joystick *joystick)
{
  #if 0
	return;
  #else
  joystick->ref_count--;
  #endif
}

/* Function to perform any system-specific joystick related cleanup */
void SDL_SYS_JoystickQuit(void)
{
  #if 0
	return;
  #else
  short i = 0;
  for (;i < MAX_JOYSTICKS; i++)
  {
    SDL_free((void*)TabJoysticks[i].name);
  }
  #endif
}

#endif /* SDL_JOYSTICK_AJAGUAR || SDL_JOYSTICK_DISABLED */
