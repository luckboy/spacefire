CC = cl65
CFLAGS = -Or
ASFLAGS =
LDFLAGS =
C1541 = c1541
SYS = c64

OBJS = chars.o graphics.o main.o main_menu.o util.o

.c.o:
	$(CC) -c -t $(SYS) $(CFLAGS) -o $@ $<

.s.o:
	$(CC) -c -t $(SYS) $(ASFLAGS) -o $@ $<

all: spacefire

spacefire: $(OBJS)
	$(CC) -t $(SYS) -o $@ $^
	
spacefire.d64: all
	$(C1541) -format spacefire,AA  d64 $@
	$(C1541) -attach $@ -write spacefire spacefire

clean:
	rm -f spacefire $(OBJS) *.d64 *~

graphics.o: graphics.c graphics.h
main.o: main.c graphics.h
main_menu.o: main_menu.c main_menu.h graphics.h util.h
util.o: util.c util.h
