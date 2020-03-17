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
#include <6502.h>
#include <c64.h>
#include <cbm.h>
#include <conio.h>
#include <stddef.h>
#include <string.h>
#include "enemy_descs.h"
#include "game.h"
#include "graphics.h"
#include "high_scores.h"
#include "levels.h"
#include "sound_effects.h"
#include "util.h"

#define SHOOTING_INTERVAL       ((40 * 8 - 2 * 8 - 24 + 23) / 24 + 2) / 3

#define GAME_OVER_DELAY         (50 * 5)

unsigned char level_pos;
unsigned char block_pos;
unsigned char scroll_pos;
char is_scroll;
char is_scroll2;

unsigned char sprite_bg_coll;
unsigned char sprite_coll1;
unsigned char sprite_coll2;
unsigned char sprite_coll3;

unsigned char start_level_index;
unsigned char end_level_index;
unsigned char current_level_index;
struct level current_level;
struct player player;
struct shot shots[GAME_SHOT_COUNT_MAX];
unsigned char shot_alloc_index;
struct enemy enemies[GAME_ENEMY_COUNT_MAX];
unsigned char enemy_alloc_indices[3];
struct enemy_explosion enemy_explosion;

static struct high_score high_score;

void initialize_game(void)
{
  start_level_index = 0;
  end_level_index = LEVEL_COUNT;
}

void finalize_game(void) {}

static unsigned char tab_enemy_xs[3] = {
  SPRITE_Y_OFFSET + 12 + ((5 * 8) >> 1) - (22 >> 1),
  SPRITE_Y_OFFSET + 12 + 5 * 8 + 16 + ((5 * 8) >> 1) - (22 >> 1),
  SPRITE_Y_OFFSET + 12 + 5 * 8 + 16 + 5 * 8 + 16 + ((5 * 8) >> 1) - (22 >> 1)
};

static void alloc_enemy(unsigned char i, unsigned char j)
{
  if(current_level.enemies[i][j] != ' ') {
    unsigned char k = current_level.enemies[i][j] - '1';
    unsigned char l = enemy_alloc_indices[i] + i * 4;
    const struct enemy_desc *enemy_desc = &enemy_descs[k];
    struct enemy *enemy = &enemies[l];
    enemy->state = GAME_STATE_LIVE;
    enemy->x = SPRITE_X_OFFSET + j * 16 + 6;
    enemy->y = tab_enemy_xs[i];
    enemy->x_steps[0] = enemy_desc->x_step;
    enemy->x_steps[1] = enemy_desc->x_step + 2;
    enemy->y_steps = enemy_desc->y_steps;
    enemy->y_step_count = enemy_desc->y_step_count;
    enemy->y_step_index = 0;
    enemy->sprite = enemy_desc->sprite;
    enemy->points = enemy_desc->points;
    enemy_alloc_indices[i]++;
    if(enemy_alloc_indices[i] >= 4) enemy_alloc_indices[i] = 0;
  }
}

static void set_level(void)
{
  unsigned char i, j;
  player.state = GAME_STATE_LIVE;
  player.x = SPRITE_X_OFFSET + 8;
  player.y = SPRITE_Y_OFFSET + 11 * 8 - (24 >> 1);
  player.x_steps[0] = 2;
  player.x_steps[1] = 0;
  player.sprite = (((unsigned) (SPRITES + 64 * 0)) - (VIC_BANK << 14)) >> 6;
  player.start_explosion_sprite = (((unsigned) (SPRITES + 64 * 2)) - (VIC_BANK << 14)) >> 6;
  player.end_explosion_sprite = (((unsigned) (SPRITES + 64 * 18)) - (VIC_BANK << 14)) >> 6;
  for(i = 0; i < GAME_SHOT_COUNT_MAX; i++) {
    struct shot *shot = &shots[i];
    shot->is_enabled = 0;
    shot->x = 0;
    shot->y = 0;
    shot->x_steps[0] = 24 + 2;
    shot->x_steps[1] = 24;
    shot->sprite = (((unsigned) (SPRITES + 64 * 1)) - (VIC_BANK << 14)) >> 6;
  }
  shot_alloc_index = 0;
  for(i = 0; i < GAME_ENEMY_COUNT_MAX; i++) {
    struct enemy *enemy = &enemies[i];
    enemy->state = GAME_STATE_DISABLED;
    enemy->x = 0;
    enemy->y = 0;
    enemy->x_steps[0] = 0;
    enemy->x_steps[1] = 2;
    enemy->y_steps = NULL;
    enemy->y_step_count = 0;
    enemy->y_step_index = 0;
    enemy->sprite = (((unsigned) (SPRITES + 64 * 18)) - (VIC_BANK << 14)) >> 6;
    enemy->points = 0x10;
  }
  enemy_explosion.start_explosion_sprite = (((unsigned) (SPRITES + 64 * 24)) - (VIC_BANK << 14)) >> 6;
  enemy_explosion.end_explosion_sprite = (((unsigned) (SPRITES + 64 * 28)) - (VIC_BANK << 14)) >> 6;
  for(i = 0; i < 3; i++) {
    enemy_alloc_indices[i] = 0;
  }
  for(i = 0; i < 3; i++) {
    for(j = 0; j < 20; j++) alloc_enemy(i, j);
  }
  level_pos = 20;
  block_pos = 0;
  scroll_pos = 6;
}

static void draw_level(void)
{
  static char buf[32];
  char *s;
  unsigned char x, y;
  unsigned i;
  VIC.ctrl1 &= 0xef;
  for(y = 0; y < 11; y++) {
    for(x = 0; x < 20; x++) {
      char c = current_level.chars[y][x];
      if(c != ' ') {
        SCREEN1[((y << 1) + 0) * 40 + ((x << 1) + 0)] = c | 0x00;
        SCREEN1[((y << 1) + 0) * 40 + ((x << 1) + 1)] = c | 0x10;
        SCREEN1[((y << 1) + 1) * 40 + ((x << 1) + 0)] = c | 0x20;
        SCREEN1[((y << 1) + 1) * 40 + ((x << 1) + 1)] = c | 0x30;
      } else {
        SCREEN1[((y << 1) + 0) * 40 + ((x << 1) + 0)] = ' ';
        SCREEN1[((y << 1) + 0) * 40 + ((x << 1) + 1)] = ' ';
        SCREEN1[((y << 1) + 1) * 40 + ((x << 1) + 0)] = ' ';
        SCREEN1[((y << 1) + 1) * 40 + ((x << 1) + 1)] = ' ';
      }
      COLOR_RAM[((y << 1) + 0) * 40 + ((x << 1) + 0)] = COLOR_WHITE | 0x08;
      COLOR_RAM[((y << 1) + 0) * 40 + ((x << 1) + 1)] = COLOR_WHITE | 0x08;
      COLOR_RAM[((y << 1) + 1) * 40 + ((x << 1) + 0)] = COLOR_WHITE | 0x08;
      COLOR_RAM[((y << 1) + 1) * 40 + ((x << 1) + 1)] = COLOR_WHITE | 0x08;      
    }
  }
  for(i = 40 * 22; i < 40 * 25; i++) {
    SCREEN1[i] = ' ';
    SCREEN2[i] = ' ';
    COLOR_RAM[i] = COLOR_WHITE;
  }
  strcpy(buf, "lives: ");
  x8_to_dec_digits(player.lives, buf + strlen(buf), 1);
  s = buf;
  i = 0;
  while(*s != 0) {
    SCREEN1[40 * 23 + i] = petscii_to_char(*s);
    SCREEN2[40 * 23 + i] = petscii_to_char(*s);
    s++;
    i++;
  }
  strcpy(buf, "level: ");
  x8_to_dec_digits((current_level_index + 1), buf + strlen(buf), 1);
  s = buf;
  i = 0;
  while(*s != 0) {
    SCREEN1[40 * 23 + 20 - 4 + i] = petscii_to_char(*s);
    SCREEN2[40 * 23 + 20 - 4 + i] = petscii_to_char(*s);
    s++;
    i++;
  }
  strcpy(buf, "score: ");
  x32_to_dec_digits_for_dec_mode(player.score, buf + strlen(buf), 6);
  s = buf;
  i = 0;
  while(*s != 0) {
    SCREEN1[40 * 23 + 40 - 13 + i] = petscii_to_char(*s);
    SCREEN2[40 * 23 + 40 - 13 + i] = petscii_to_char(*s);
    s++;
    i++;
  }
  VIC.ctrl2 = 0xd6;
  VIC.spr_ena = 0x01;
  SPRITE_PTRS1[0] = player.sprite;
  SPRITE_PTRS2[0] = player.sprite;
  VIC.spr0_x = player.x & 0xff;
  VIC.spr0_y = player.y;
  VIC.spr_hi_x = player.x >> 8;
  VIC.spr_exp_x = 0x00;
  VIC.spr_exp_y = 0x00;
  VIC.spr_mcolor = 0xff;
  VIC.spr0_color = COLOR_WHITE;
  for(i = 0; i < 4; i++) {
    if(enemies[i].state == GAME_STATE_LIVE) {
      SPRITE_PTRS1[4 + i] = enemies[i].sprite;
      SPRITE_PTRS2[4 + i] = enemies[i].sprite;
    }
  }
  if(enemies[0].state == GAME_STATE_LIVE) {
    VIC.spr_ena |= 0x10;
    VIC.spr4_x = enemies[0].x;
    VIC.spr_hi_x |= (enemies[0].x >> 8) << 4;
    VIC.spr4_y = enemies[0].y;
    VIC.spr4_color = COLOR_WHITE;
  }
  if(enemies[1].state == GAME_STATE_LIVE) {
    VIC.spr_ena |= 0x20;
    VIC.spr5_x = enemies[1].x;
    VIC.spr_hi_x |= (enemies[1].x >> 8) << 5;
    VIC.spr5_y = enemies[1].y;
    VIC.spr5_color = COLOR_WHITE;
  }
  if(enemies[2].state == GAME_STATE_LIVE) {
    VIC.spr_ena |= 0x40;
    VIC.spr6_x = enemies[2].x;
    VIC.spr_hi_x |= (enemies[2].x >> 8) << 6;
    VIC.spr6_y = enemies[2].y;
    VIC.spr6_color = COLOR_WHITE;
  }
  if(enemies[3].state == GAME_STATE_LIVE) {
    VIC.spr_ena |= 0x80;
    VIC.spr7_x = enemies[3].x;
    VIC.spr_hi_x |= (enemies[3].x >> 8) << 7;
    VIC.spr7_y = enemies[3].y;
    VIC.spr7_color = COLOR_WHITE;
  }
  VIC.ctrl1 |= 0x10;
}

static char play_level(void)
{
  static char is_passed;
  static unsigned char shooting_count;
  static char is_shot;
  is_passed = 1;
  shooting_count = 0;
  is_shot = 0;
  sound_effect_start();
  SEI();
  while(1) {
    static unsigned char port_a;
    while(VIC.rasterline != ((RASTER_OFFSET + 25 * 8 + 32) & 0xff) || (VIC.ctrl1 & 0x80) != 0x80);
    game_scroll_screen();
    while(VIC.rasterline != RASTER_OFFSET - 16  || (VIC.ctrl1 & 0x80) != 0);
    port_a = CIA1.pra;
    if(player.state == GAME_STATE_LIVE) {
      if((port_a & 0x01) == 0) game_move_player_up();
      if((port_a & 0x02) == 0) game_move_player_down();
      if((port_a & 0x04) == 0) game_move_player_left();
      if((port_a & 0x08) == 0) game_move_player_right();
    }
    if(!game_move_player()) {
      is_passed = (player.state == GAME_STATE_LIVE);
      break;
    }
    game_move_shots();
    if(player.state == GAME_STATE_LIVE) {
      if((port_a & 0x10) == 0) {
        if(shooting_count == 0) {
          game_player_shoot();
          is_shot = 1;
        }
      }
    }
    if(is_shot) shooting_count++;
    if(shooting_count >= SHOOTING_INTERVAL) {
      shooting_count = 0;
      is_shot = 0;
    }
    game_set_player_sprite();
    game_set_shot_sprites();
    while(VIC.rasterline != RASTER_OFFSET);
    game_set_enemy_sprites_0_3();
    while(VIC.rasterline != RASTER_OFFSET + 12);
    game_move_enemies_0_3();
    game_change_enemy_states_0_3();
    game_add_enemy_points_0_3();
    while(VIC.rasterline != RASTER_OFFSET + 12 + 5 * 8);
    sprite_coll1 = VIC.spr_coll;
    game_set_enemy_sprites_4_7();
    while(VIC.rasterline != RASTER_OFFSET + 12 + 5 * 8 + 16);
    game_move_enemies_4_7();
    game_change_enemy_states_4_7();
    game_add_enemy_points_4_7();
    while(VIC.rasterline != RASTER_OFFSET + 12 + 5 * 8 + 16 + 5 * 8);
    sprite_coll2 = VIC.spr_coll;
    game_set_enemy_sprites_8_11();
    while(VIC.rasterline != RASTER_OFFSET + 12 + 5 * 8 + 16 + 5 * 8 + 16);
    game_move_enemies_8_11();
    game_change_enemy_states_8_11();
    game_add_enemy_points_8_11();
    while(VIC.rasterline != RASTER_OFFSET + 12 + 5 * 8 + 16 + 5 * 8 + 16 + 5 * 8);
    sprite_coll3 = VIC.spr_coll;
    while(VIC.rasterline != RASTER_OFFSET + 23 * 8 - 4);
    VIC.ctrl2 = 0xd8;
    sprite_bg_coll = VIC.spr_bg_coll;
    game_display_score();
    if(block_pos == 0 && scroll_pos == 0 && is_scroll) {
      game_alloc_enemy1();
      game_alloc_enemy2();
      game_alloc_enemy3();
    }
    if(!game_change_player_state()) {
      is_passed = 0;
      break;
    }
    game_change_shot_states();
    while(VIC.rasterline != RASTER_OFFSET + 25 * 8);
    sound_effect_play();
  }
  CLI();
  sound_effect_stop();
  return is_passed;
}

static void draw_blank_screen(void)
{
  unsigned i;
  VIC.ctrl1 &= 0xef;
  VIC.spr_ena = 0x00;
  VIC.addr = (VIC.addr & 0x0f) | (((((unsigned) SCREEN) - (VIC_BANK << 14)) >> 10) << 4);
  for(i = 0; i < 40 * 25; i++) {
    SCREEN[i] = ' ';
    COLOR_RAM[i] = COLOR_WHITE;
  }
  VIC.ctrl1 |= 0x10;
}

static void draw_game_over(void)
{
  char *s;
  unsigned i;
  unsigned char x;
  VIC.ctrl1 &= 0xef;
  for(i = 0; i < 40 * 25; i++) {
    SCREEN[i] = ' ';
    COLOR_RAM[i] = COLOR_WHITE;
  }
  s = "game over";
  x = 20 - ((strlen(s) + 1) >> 1);
  i = 0;
  while(*s != 0) {
    SCREEN[40 * 12 + x + i] = petscii_to_char(*s);
    s++;
    i++;
  }
  VIC.ctrl1 |= 0x10;
}

static void loop_game_over(void)
{
  unsigned char i;
  SEI();
  for(i = 0; i < GAME_OVER_DELAY; i++) {
    while(VIC.rasterline != RASTER_OFFSET - 8 || (VIC.ctrl1 & 0x80) != 0);   
  }
  CLI();
}

void draw_name(void)
{
  char *s = high_score.name;
  unsigned char i, x;
  x = 20 - ((6 + 9 + 1) >> 1) + 6;
  i = 0;
  while(*s != 0) {
    SCREEN[40 * 12 + x + i] = petscii_to_char(*s);
    s++;
    i++;
  }
  SCREEN[40 * 12 + x + i] = '<';
  for(i++; i < 9; i++) {
    SCREEN[40 * 12 + x + i] = ' ';
  }
}

static void draw_name_input(void)
{
  char *s;
  unsigned i;
  unsigned char x;
  VIC.ctrl1 &= 0xef;
  for(i = 0; i < 40 * 25; i++) {
    SCREEN[i] = ' ';
    COLOR_RAM[i] = COLOR_WHITE;
  }
  s = "name: ";
  x = 20 - ((6 + 9 + 1) >> 1);
  i = 0;
  while(*s != 0) {
    SCREEN[40 * 12 + x + i] = petscii_to_char(*s);
    s++;
    i++;
  }
  draw_name();
  VIC.ctrl1 |= 0x10;
}

void loop_name_input(void)
{
  char is_exit = 0;
  unsigned char len;
  while(!is_exit) {
    char c = cgetc();
    switch(c) {
    case '\n':
      is_exit = 1;
      break;
    case CH_DEL:
      len = strlen(high_score.name);
      if(len > 0) {
        high_score.name[len - 1] = 0;
        draw_name();
      }
      break;
    default:
      if(c >= 0x20 && c <= 0x5f) {
        len = strlen(high_score.name);
        if(len < 8) {
          high_score.name[len] = c;
          high_score.name[len + 1] = 0;
          draw_name();
        }
      }
      break;
    }
  }
}

void game_loop(void)
{
  unsigned char i;
  player.lives = 3;
  player.score = 0;
  for(i = start_level_index; i < end_level_index; i++) {
    char is_game_over = 0;
    current_level_index = i;
    current_level = levels[i];
    while(1) {
      set_level();
      draw_level();
      if(play_level()) {
        draw_blank_screen();
        break;
      }
      draw_blank_screen();
      if(player.lives > 0) {
        player.lives--;
      } else {
        is_game_over = 1;
        break;
      }
    }
    if(is_game_over) break;
  }
  draw_game_over();
  loop_game_over();
  if(high_scores_can_add_high_score(player.score)) {
    high_score.is_selected = 1;
    high_score.name[0] = 0;
    high_score.score = player.score;
    draw_name_input();
    loop_name_input();
    high_scores_add_high_score(&high_score);
    high_scores_draw();
    high_scores_loop();
    high_scores_unselect();
  }
}
