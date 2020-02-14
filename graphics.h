/*
 * Space Fire - Game for Commodore 64.
 * Copyright (C) 2020 Łukasz Szpakowski
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#ifndef _GRAPHICS_H
#define _GRAPHICS_H

#include <c64.h>

#define SPRITE_X_OFFSET 24
#define SPRITE_Y_OFFSET 50

#define RASTER_OFFSET   51

#define VIC_BANK        1
#define SCREEN1         ((unsigned char *) 0x6000)
#define SCREEN2         ((unsigned char *) 0x6400)
#define SPRITE_PTRS1    (SCREEN1 + 0x3f8)
#define SPRITE_PTRS2    (SCREEN2 + 0x3f8)
#define SCREEN          SCREEN1
#define SPRITE_PTRS     SPRITE_PTRS1
#define CHARS           ((unsigned char *) 0x6800)
#define SPRITES         ((unsigned char *) 0x7000)
#define SPRITE_COUNT    1

extern const char petscii_chars[8 * 64];
extern const char level_chars[8 * 64];
extern const char sprites[64 * SPRITE_COUNT];

void initialize_graphics(void);
void finalize_graphics(void);

#endif
