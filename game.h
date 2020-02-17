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
#ifndef _GAME_H
#define _GAME_H

#include "levels.h"

#define GAME_PLAYER_DISABLED    0
#define GAME_PLAYER_LIVE        1
#define GAME_PLAYER_DESTROYING  2

#define GAME_SHOT_COUNT_MAX     3

struct player
{
  unsigned char state;
  unsigned x;
  unsigned char y;
  unsigned char x_steps[2];
  unsigned char sprite;
  unsigned char lives;
  unsigned long score;
};

struct shot
{
  char is_enabled;
  unsigned x;
  unsigned char y;
  unsigned char x_steps[2];
  unsigned char sprite;
};

extern unsigned char level_pos;
extern unsigned char block_pos;
extern unsigned char scroll_pos;
extern char is_scroll;

extern unsigned char start_level_index;
extern unsigned char current_level_index;
extern struct level current_level;
extern struct player player;
extern struct shot shots[GAME_SHOT_COUNT_MAX];
extern unsigned char shot_alloc_index;

void initialize_game(void);
void finalize_game(void);

void game_loop(void);

void game_move_player_up(void);
void game_move_player_down(void);
void game_move_player_left(void);
void game_move_player_right(void);
void game_set_player_sprite(void);
void game_scroll_screen(void);
char game_move_player(void);
void game_player_shoot(void);
void game_move_shots(void);
void game_set_shot_sprites(void);

#endif
