# Copyright 2005-2010 Intel Corporation.  All Rights Reserved.
#
# This file is part of Threading Building Blocks.
#
# Threading Building Blocks is free software; you can redistribute it
# and/or modify it under the terms of the GNU General Public License
# version 2 as published by the Free Software Foundation.
#
# Threading Building Blocks is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Threading Building Blocks; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
# As a special exception, you may use this file as part of a free software
# library without restriction.  Specifically, if other files instantiate
# templates or use macros or inline functions from this file, or you compile
# this file and link it with other files to produce an executable, this
# file does not by itself cause the resulting executable to be covered by
# the GNU General Public License.  This exception does not however
# invalidate any other reasons why the executable file might be covered by
# the GNU General Public License.

# GNU Makefile that builds and runs example.
PROG=game_of_life
ARGS=2:4 -t 5
ifneq (,$(shell which icc 2>/dev/null))
CXX=icc
endif # icc

all:	release test

release: src/Evolution.cpp src/Update_state.cpp src/Game_of_life.cpp
	$(CXX) -O1 -DNDEBUG -D_CONSOLE $(CXXFLAGS) -o $(PROG) $^ -ltbb $(LIBS)

debug: src/Evolution.cpp src/Update_state.cpp src/Game_of_life.cpp
	$(CXX) -O0 -D_CONSOLE -g -DTBB_DO_ASSERT $(CXXFLAGS) -o $(PROG) $^ -ltbb_debug $(LIBS)

clean:
	rm -f $(PROG) *.o *.d

test:
	./$(PROG) $(ARGS)
