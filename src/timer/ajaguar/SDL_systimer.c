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

#if defined(SDL_TIMER_AJAGUAR) || defined(SDL_TIMERS_DISABLED)

#include "SDL_timer.h"
#include "../SDL_timer_c.h"
#include "IRQHandler.h"

void SDL_StartTicks(void)
{
#if 0
	SDL_Unsupported();
#else
	init_interrupts();
#endif
}

// Get the number of milliseconds since the SDL library initialization
Uint32 SDL_GetTicks (void)
{
#if 0
	SDL_Unsupported();
	return 0;
#else
	return ajag_mstimer;
#endif
}

void SDL_Delay (Uint32 ms)
{
#if 0
	SDL_Unsupported();
#else
	ms += ajag_mstimer;
	while (ajag_mstimer < ms);
#endif
}

#if 0
#include "SDL_thread.h"

/* Data to handle a single periodic alarm */
static int timer_alive = 0;
static SDL_Thread *timer = NULL;

static int RunTimer(void *unused)
{
	while ( timer_alive ) {
		if ( SDL_timer_running ) {
			SDL_ThreadedTimerCheck();
		}
		SDL_Delay(1);
	}
	return(0);
}
#endif

/* This is only called if the event thread is not running */
int SDL_SYS_TimerInit(void)
{
#if 0
	timer_alive = 1;
	timer = SDL_CreateThread(RunTimer, NULL);
	if ( timer == NULL )
		return(-1);
	return(SDL_SetTimerThreaded(1));
#else
	// return (ajag_mstimer = 0);
	return 0;
#endif
}

void SDL_SYS_TimerQuit(void)
{
#if 0
	timer_alive = 0;
	if ( timer ) {
		SDL_WaitThread(timer, NULL);
		timer = NULL;
	}
#endif
}

int SDL_SYS_StartTimer(void)
{
	SDL_SetError("Internal logic error: threaded timer in use");
	return(-1);
}

void SDL_SYS_StopTimer(void)
{
	return;
}

#endif /* SDL_TIMER_AJAGUAR || SDL_TIMERS_DISABLED */
