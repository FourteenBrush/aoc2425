rwildcard = $(wildcard $1) $(foreach d,$1,$(call rwildcard,$(addsuffix /$(notdir $d),$(wildcard $(dir $d)*))))

SRC = src
DAY ?= invalid day
SOURCE_FILES = $(call rwildcard,$(SRC)/*.odin)
TESTS = tests

CC = odin
CFLAGS = -out:$(DAY) -strict-style -vet-semicolon -vet-cast -vet-using-param

all: release

release: CFLAGS += -vet-unused -o:speed -microarch:native
release: $(DAY)

debug: CFLAGS += -debug -o:none
debug: $(DAY)

test: CFLAGS += -define:ODIN_TEST_LOG_LEVEL=warning -debug
test: $(SOURCE_FILES)
	$(CC) test $(TESTS) $(CFLAGS)

$(DAY): $(SOURCE_FILES)
	$(CC) build $(SRC)/$(DAY) $(CFLAGS)

run: debug
	./$(DAY)

check: CFLAGS := $(filter-out -out:$(DAY),$(CFLAGS))
check:
	$(CC) check $(SRC) $(CFLAGS) -debug

clean:
	-@rm $(DAY) 2>/dev/null

.PHONY: release debug clean run test check
