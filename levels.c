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
#include "levels.h"

/*
 * A  B  C  D  E  F  G  H  I  J  K  L  M
 * -- || /- -\ |\ /| ..  / \  \. ./ ## ..
 * -- || |/ \| \- -/ .. /. .\  \ /  ## ..
 */

const struct level levels[LEVEL_COUNT] = {
  {
    {
      "                                        ",
      "                                        ",
      "                                        ",
      "                                        ",
      "                                        ",
      "                                        ",
      "                                        ",
      "                                        ",
      "                 CD            CD       ",
      "      CAD CAD    BB    CAD     BB       ",
      "AAAAAAAAAAAAAAAAABBAAAABABAAAAAAAAAAAAAA"
    },
    {
      "              1 1 1 1                    ",
      "              2 2 2 2                2   ",
      "              3 3 3 3                3 4 "
    }
  },
  {
    {
      "            HGGGGGGGGGGGI               ",
      "           HGGGGGGGGGGGGGI              ",
      "          HGGGGLLLLLLLGGGGI             ",
      "         HGGGGGLLLLLLLMGGGGI            ",
      "         GGGGGGLLLLLLLMGGGGG            ",
      "         GGGGGGLLLLLLLMGGGGG            ",
      "         GGGGGGLLLLLLLMGGGGG            ",
      "         JGGGGGLLLLLLLMGGGGK            ",
      "          JGGGGLLLLLLLMGGGK             ",
      "           JGGGGMMMMMMMGGK              ",
      "            JGGGGGGGGGGGK               "
    },
    {
      "                        5                ",
      "                                         ",
      "                        6                "
    }
  }
};
