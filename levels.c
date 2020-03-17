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

#if 0
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
#else
const struct level levels[LEVEL_COUNT] = {
  /* 1 */
  {
    {
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    ",
      "               CD                                                                     CD            ",
      "               BB         CD                           CAD                 CAAD       BB            ",
      "      CAAD     BB         BB       CAAD       CAAAD    B B        CAAD     B  B       BB            ",
      "AAAAAABAABAAAAAAAAAAAAAAAABBAAAAAAAAAAAAAAAAAABAAABAAAAAAAAAAAAAAAAAAAAAAAABAABAAAAAAAAAAAAAAAAAAAAA"
    },
    {
      "                    1    1    1         1         1    1    1         1         1    1    1          ",
      "                    1              1         1         1         1         1         1               ",
      "                                                                                                     "
    }
  },
  /* 2 */
  {
    {
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                            CD                                      ",
      "                       CD                                   BB                                      ",
      "                       BB                                   BB                                      ",
      "                       BB                                   BB                                      ",
      "                       BB                                   BB                          CD          ",
      "            CAD        BB      CAD             CAAD         BB       CAAAD              BB          ",
      "            B B        BB      B B      CD     B  B         BB       B   B     CAAAD    BB          ",
      "AAAAAAAAAAAABABAAAAAAAAAAAAAAAAAAAAAAAAABBAAAAABAABAAAAAAAAABBAAAAAAAAAAAAAAAAAAAAAAAAAABBAAAAAAAAAA"
    },
    {
      "                    1    1    1    1    1    2    2    1    1    2    2    2    2         2          ",
      "                    1              1         1                             2         2               ",
      "                                                                                                     "
    }
  },
  /* 3 */
  {
    {
      "                                                      B        BB          B                        ",
      "                                                      B        BB          B                        ",
      "                                                      B        BF    CAAAAAF                        ",
      "                              CAAAAAAAAAD             B        B     B                              ",
      "                              B      B  B             EAAAD    B     B                              ",
      "                          CAAAF      B  B                 B    B     B                              ",
      "                          B          B  EAAAD             EAAAAAAAAAAF                              ",
      "                     CAAAAF        CAB      B                                                       ",
      "             CAD     B             B B      B                                 CAAD                  ",
      "             B B     B             B B      B                                 B  B                  ",
      "AAAAAAAAAAAAABABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAABAAAAAAAAAAAAAAAAAA"
    },
    {
      "                    2    2    1    1    1    1    1                                                  ",
      "                                                                                2    2    2          ",
      "                                                            1    1    1                              "
    }
  },
  /* 4 */
  {
    {
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    ",
      "                      CD                                 CD                                         ",
      "                      BB                                 BB                CAAD                     ",
      "              CD      BB         CAAAAD        CD        BB                B  B     CAAD            ",
      "              BB      BB         B    B        BB        BB      CAAAD     B  B     B  B            ",
      "AAAAAAAAAAAAAABBAAAAAAAAAAAAAAAAABAAAABAAAAAAAAAAAAAAAAAABBAAAAAAAAAAAAAAAAAAAAAAAAABAABAAAAAAAAAAAA"
    },
    {
      "                    3              3    3    3    3                   3         3  3  3  3           ",
      "                    3    3    3    3              3    3    3    3              3  3  3  3           ",
      "                                                                                                     "
    }
  },
  /* 5 */
  {
    {
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    ",
      "                                                                                                    "
    },
    {
      "                    3         4                   4    4              4         4  4  4  4           ",
      "                    3    3    3    4    4    4              4    4              4  4  4  4           ",
      "                    3         4                   4    4              4         4  4  4  4           "
    }
  },
  /* 6 */
  {
    {
      "                                 HGGGGGGGGGGGGGGGGGGGGGGGGGI                                        ",
      "                                HGGGGGGGGGGGGGGGGGGGGGGGGGGGI                                       ",
      "                               HGGGGGGGGGGGGGGGGGGGGGGGGGGGGGI                                      ",
      "                              HGGGGGLLLLLLLGGGGGGGLLLLLLLGGGGGI                                     ",
      "                             HGGGGGGLLLLLLLMGGGGGGLLLLLLLMGGGGGI                                    ",
      "                             GGGGGGGLLLLLLLMGGGGGGLLLLLLLMGGGGGG                                    ",
      "                             JGGGGGGLLLLLLLMGGGGGGLLLLLLLMGGGGGK                                    ",
      "                              JGGGGGLLLLLLLMGGGGGGLLLLLLLMGGGGK                                     ",
      "                               JGGGGGMMMMMMMGGGGGGGMMMMMMMGGGK                                      ",
      "                                JGGGGGGGGGGGGGGGGGGGGGGGGGGGK                                       ",
      "                                 JGGGGGGGGGGGGGGGGGGGGGGGGGK                                        "
    },
    {
      "                    4    4    4    3    3    3    3    3    3    4    4         4  4  4  4           ",
      "                    4         4                                                 4  4  4  4           ",
      "                    4    4    4    3    3    3    3    3    3    4    4         4  4  4  4           "
    }
  },
  /* 7 */
  {
    {
      "                   HGGGGGGGGGGGGGGGGGGLLLLLLLLLLMGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "                  HGGGGGGGGGGGGGGGGGGGLLLLLLLLLLMGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "                 HGGGGGGGGGGGGGGGGGGGGLLLLLLLLLLMGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "                HGGGGGGLLLLLLLLLLGGGGGLLLLLLLLLLMGGGGLLLLLLLLLLGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "               HGGGGGGGLLLLLLLLLLMGGGGGMMMMMMMMMMGGGGLLLLLLLLLLMGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "               GGGGGGGGLLLLLLLLLLMGGGGGGGGGGGGGGGGGGGLLLLLLLLLLMGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "               JGGGGGGGLLLLLLLLLLMGGGGGGGGGGGGGGGGGGGLLLLLLLLLLMGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "                JGGGGGGLLLLLLLLLLMGGGGLLLLLLLLLLGGGGGLLLLLLLLLLMGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "                 JGGGGGGMMMMMMMMMMGGGGLLLLLLLLLLMGGGGGMMMMMMMMMMGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "                  JGGGGGGGGGGGGGGGGGGGLLLLLLLLLLMGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "                   JGGGGGGGGGGGGGGGGGGLLLLLLLLLLMGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    },
    {
      "                    5    5    5    5                   1              5         5  5  5  5           ",
      "                    5                   2    2    2                             5  5  5  5           ",
      "                    5    5    5    5                   1              5         5  5  5  5           "
    }
  },
  /* 8 */
  {
    {
      "GGGGGGGGGGGGGGGGGGGI                                  HGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "GGGGGGGGGGGGGGGGGGGGI                                HGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "GGGGGGGGGGGGGGGGGGGGGI                              HGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "GGGGGGGGGGGGGGGGGGGGGGI                            HGGGGGLLLLLLLGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGLLLLLLLMGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGLLLLLLLMGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGLLLLLLLMGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "GGGGGGGGGGGGGGGGGGGGGGK                            JGGGGGLLLLLLLMGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "GGGGGGGGGGGGGGGGGGGGGK                              JGGGGGMMMMMMMGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "GGGGGGGGGGGGGGGGGGGGK                                JGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG",
      "GGGGGGGGGGGGGGGGGGGK                                  JGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    },
    {
      "                    6    6    6         6         6    6    5    5    5         6  6  6  6           ",
      "                    6    6    6    6    6    6         6                        6  6  6  6           ",
      "                    6    6    6         6         6    6    5    5    5         6  6  6  6           "
    }
  }
};
#endif
