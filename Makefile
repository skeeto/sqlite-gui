CROSS    = x86_64-w64-mingw32-
CC       = $(CROSS)gcc
CXX      = $(CROSS)g++
CFLAGS   = -g3
CXXFLAGS = -g3 -fsanitize=undefined -fsanitize-undefined-trap-on-error \
 -Wall -Wextra -Wno-unused-parameter -Wno-unused-but-set-variable \
 -Wno-class-memaccess -Wno-missing-field-initializers -Wno-address \
 -Wno-cast-function-type -Wno-unused-variable
LDFLAGS  = -mwindows
WINDRES  = $(CROSS)windres
LDLIBS   = -lshell32 -lgdi32 -lgdiplus -lws2_32 -lshlwapi -lcomdlg32 \
 -lcomctl32 -lmsimg32 -lole32 -luuid

sqlite-gui.exe: unity.o sqlite3.o resource.o
	$(CXX) $(LDFLAGS) -o $@ unity.o sqlite3.o resource.o $(LDLIBS)

cpp = unity.cpp extensions/inja.cpp extensions/xml.cpp include/pugixml.cpp \
 src/dialogs.cpp src/http.cpp src/main.cpp src/prefs.cpp src/tools.cpp \
 src/utils.cpp include/inja.hpp include/json.hpp include/pugiconfig.hpp \
 include/pugixml.hpp include/sqlite3.h include/sqlite3ext.h include/dmp.h \
 include/tom.h include/uthash.h src/dialogs.h src/global.h src/http.h \
 src/prefs.h src/resource.h src/tools.h src/utils.h
unity.o: $(cpp)
	$(CXX) -c -Iinclude $(CXXFLAGS) unity.cpp

sqlite3.o: include/sqlite3.c include/sqlite3.h
	$(CC) -c -DSQLITE_ENABLE_COLUMN_METADATA $(CFLAGS) include/sqlite3.c

res = src/resource.rc resources/toolbar.bmp resources/toolbar_data.bmp \
 resources/toolbar_diagram.bmp resources/toolbar_functions.bmp \
 resources/tab.bmp resources/help.sql resources/template.xlsx
resource.o: $(res)
	$(WINDRES) -o $@ src/resource.rc

clean:
	rm -f resource.o sqlite3.o unity.o sqlite-gui.exe
