rwildcard = $(wildcard $1) $(foreach d,$1,$(call rwildcard,$(addsuffix /$(notdir $d),$(wildcard $(dir $d)*))))

SRC = src
SOURCE_FILES = $(call rwildcard,$(SRC)/*.odin)
TESTS = tests

CC = odin
CFLAGS = -out:$(DAY) -strict-style -vet-semicolon -vet-cast -vet-using-param

ifndef DAY
$(error env variable DAY must be set; e.g. day1)
endif

all: release

release: CFLAGS += -vet-unused -o:aggressive -microarch:native -no-bounds-check -disable-assert
release: $(DAY)

debug: CFLAGS += -debug -o:none
debug: $(DAY)

$(DAY): $(SOURCE_FILES)
	$(CC) build $(SRC)/$(DAY) $(CFLAGS)

run: debug
	./$(DAY)

check: CFLAGS := $(filter-out -out:$(DAY),$(CFLAGS))
check:
	$(CC) check $(SRC)/$(DAY) $(CFLAGS) -debug

clean:
	-@rm $(DAY) 2>/dev/null

.PHONY: release debug clean run test check
