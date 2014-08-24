SOURCEDIR = .
BUILDDIR = obj
SOURCES := $(shell find $(SOURCEDIR) -iname '*.c'|grep -v "_template.c")
OBJECTS := $(addprefix $(BUILDDIR)/,$(SOURCES:.c=.o))
DEPENDS := $(addprefix $(BUILDDIR)/,$(SOURCES:.c=.d))

INCLUDE := \
	-I . \
	-include libavutil/internal.h \

CC_FLAGS += -O0
CC_FLAGS += -std=c99
CC_FLAGS += -MMD
CC_FLAGS += -D_BSD_SOURCE=1
CC_FLAGS += -g -rdynamic
CC_FLAGS += $(INCLUDE)
CC_FLAGS += `sdl-config --cflags`
LD_FLAGS += `sdl-config --libs`
LD_FLAGS += -lm -lz

ffplay: $(OBJECTS)
	gcc $^ -o $@ $(LD_FLAGS)


$(BUILDDIR)/%.o: %.c
	mkdir -p $(@D)
	gcc $(CC_FLAGS) -c $< -o $@

-include $(DEPENDS)

.PHONY:clean
clean:
	rm -rf ffplay obj/*
	
