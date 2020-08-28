#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source.  A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
#

#
# Copyright 2020 Oxide Computer Company
#

TOP :=			$(PWD)

PROG =			cpp
INSTALL_DIR =		/usr/lib

OBJS =			cpp.o y.tab.o
OBJDIR =		obj

CERRWARN =		-Wall -Wextra -Werror \
			-Wno-unknown-pragmas \
			-Wno-sign-compare \
			-Wno-unused-label
CFLAGS +=		-m32 -O2 $(CERRWARN) -I$(TOP)/src

CC =			gcc
YACC =			yacc

.PHONY: all
all: $(PROG)

.PHONY: install
install: all
	/usr/bin/mkdir -p $(DESTDIR)$(INSTALL_DIR)
	/usr/bin/rm -f $(DESTDIR)$(INSTALL_DIR)/$(PROG)
	/usr/bin/cp cpp $(DESTDIR)$(INSTALL_DIR)/$(PROG)
	/usr/bin/chmod 0755 $(DESTDIR)$(INSTALL_DIR)/$(PROG)

.PHONY: clean
clean:
	/usr/bin/rm -rf $(PROG) $(OBJDIR)

$(PROG): $(OBJS:%=$(OBJDIR)/%)
	$(CC) $(CFLAGS) -o $@ $^

$(OBJDIR)/%.o: src/%.c | $(OBJDIR)
	$(CC) -c $(CFLAGS) -o $@ $^

$(OBJDIR)/%.o: obj/%.c | $(OBJDIR)
	$(CC) -c $(CFLAGS) -o $@ $^

$(OBJDIR):
	@/usr/bin/mkdir -p $@

$(OBJDIR)/y.tab.c: $(TOP)/src/cpy.y
	cd $(@D) && $(YACC) $<
