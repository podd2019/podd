CC=gcc
CFLAGS= -Wall
LIBS=-lm
SRCS= RaplSetPower.c RaplPowerMonitor_1s_serverID.c RaplPowerMonitor_1s.c
#OBJS= $(SRCS:.c=)
all: RaplSetPower RaplPowerMonitor_1s_serverID RaplPowerMonitor_1s

RaplSetPower: RaplSetPower.c
	$(CC) $(CFLAGS) -o RaplSetPower -c RaplSetPower.c $(LIBS)
RaplPowerMonitor_1s_serverID: RaplPowerMonitor_1s_serverID.c
	$(CC) $(CFLAGS) -o RaplPowerMonitor_1s_serverID -c RaplPowerMonitor_1s_serverID.c $(LIBS)
RaplPowerMonitor_1s: RaplPowerMonitor_1s.c
	$(CC) $(CFLAGS) -o RaplPowerMonitor_1s -c RaplPowerMonitor_1s.c $(LIBS)
clean:
	rm -f RaplSetPower RaplPowerMonitor_1s_serverID RaplPowerMonitor_1s
