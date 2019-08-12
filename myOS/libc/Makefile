DEFAULT_HOST!=../default-host.sh
HOST?=DEFAULT_HOST
HOSTARCH!=../target-triplet-to-arch.sh $(HOST)

CFLAGS?=-O2 -g
CPPFLAGS?=
LDFLAGS?=
LIBS?=

DESTDIR?=
PREFIX?=/usr/local
EXEC_PREFIX?=$(PREFIX)
INCLUDEDIR?=$(PREFIX)/include
LIBDIR?=$(EXEC_PREFIX)/lib

CFLAGS:=$(CFLAGS) -ffreestanding -Wall -Wextra
CPPFLAGS:=$(CPPFLAGS) -D__is_libc -Iinclude
LIBK_CFLAGS:=$(CFLAGS)
LIBK_CPPFLAGS:=$(CPPFLAGS) -D__is_libk

ARCHDIR=arch/$(HOSTARCH)

include $(ARCHDIR)/make.config

CFLAGS:=$(CFLAGS) $(ARCH_CFLAGS)
CPPFLAGS:=$(CPPFLAGS) $(ARCH_CPPFLAGS)
LIBK_CFLAGS:=$(LIBK_CFLAGS) $(KERNEL_ARCH_CFLAGS)
LIBK_CPPFLAGS:=$(LIBK_CPPFLAGS) $(KERNEL_ARCH_CPPFLAGS)

FREEOBJS=\
$(ARCH_FREEOBJS) \
stdio/printf.o \
stdio/putchar.o \
stdio/puts.o \
stdlib/abort.o \
string/memcmp.o \
string/memcpy.o \
string/memmove.o \
string/memset.o \
string/strlen.o \

HOSTEDOBJS=\
$(ARCH_HOSTEDOBJS) \

OBJS=\
$(FREEOBJS) \
$(HOSTEDOBJS) \

LIBK_OBJS=$(FREEOBJS:.o=.libk.o)

BINARIES=libk.a

DEPFILES :=\
$(OBJS:.o=.d)\
$(LIBK_OBJS:.o=.d)\

.PHONY: all clean install install-headers install-libs

all: $(BINARIES)

libc.a: $(OBJs)
		$(AR) rcs $@ $(OBJS)

libk.a: $(LIBK_OBJS)
		$(AR) rcs $@ $(LIBK_OBJS)

%.o: %.c %.d
		$(CC) -MD -MP -c $< -o $@ -std=gnu11 $(CFLAGS) $(CPPFLAGS)

%.S: %.c %.d
		$(CC) -MD -MP -c $< -o $@ $(CFLAGS) $(CPPFLAGS)

%.libk.o: %.c %.d
		$(CC) -MD -MP -c $< -o $@ -std=gnu11 $(LIBK_CFLAGS) $(LIBK_CPPFLAGS)

%.libk.o: %.S %.d
		$(CC) -MD -MP -c $< -o $@ $(LIBK_CFLAGS) $(LIBK_CPPFLAGS)

$(DEPFILES): ;

clean:
		rm -f $(BINARIES) *.a
		rm -f $(OBJS) $(LIBK_OBJS) *.o */*.o */*/*.o
		rm -f $(OBJS:.o=.d) $(LIBK_OBJS:.o=.d) *.d */*.d */*/*.d

install: install-headers install-libs

install-headers:
		mkdir -p $(DESTDIR)$(INCLUDEDIR)
		cp -R --preserve=timestamps include/. $(DESTDIR)$(INCLUDEDIR)/.

install-libs: $(BINARIES)
		mkdir -p $(DESTDIR)$(LIBDIR)
		cp $(BINARIES) $(DESTDIR)$(LIBDIR)

include $(wildcard $(DEPFILES))
