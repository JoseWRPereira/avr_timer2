PROJECT=avr_timer2
DEVICE=ATmega328P
COM=/dev/ttyACM0
BAUDRATE=115200

FLASH=avrdude
CC_PATH=/opt/microchip/xc8/v3.00/bin
CC=$(CC_PATH)/xc8-cc
OBJCP=$(CC_PATH)/avr-objcopy
OBJDUMP=$(CC_PATH)/avr-objdump
BUILD=build/default/production
DIST=dist/default/production
HEX_PATH="./$(DIST)/$(PROJECT).X.production.hex"

SRCS=$(wildcard *.c)
HDRS=$(wildcard *.h)
BUILDS=$(SRCS:%.c=$(BUILD)/%.o)

all: build $(BUILDS)
	$(CC)  	-mcpu=$(DEVICE) \
			-Wl,-Map=$(DIST)/$(PROJECT).X.production.map  \
			-DXPRJ_default=default  \
			-Wl,--defsym=__MPLAB_BUILD=1 \
			-Wl,--gc-sections -O1 \
			-ffunction-sections \
			-fdata-sections \
			-fshort-enums \
			-fno-common \
			-funsigned-char \
			-funsigned-bitfields \
			-Wall \
			-gdwarf-3 \
			-mno-const-data-in-progmem      \
			-Wl,--memorysummary,$(DIST)/memoryfile.xml \
			-o $(DIST)/$(PROJECT).X.production.elf  \
			-o $(DIST)/$(PROJECT).X.production.elf  \
			$(BUILDS) \
			-Wl,--start-group  \
			-Wl,-lm -Wl,--end-group
	$(OBJCP) -O ihex "$(DIST)/$(PROJECT).X.production.elf" \
			"$(DIST)/$(PROJECT).X.production.hex"
	$(OBJDUMP) -Pmem-usage "$(DIST)/$(PROJECT).X.production.elf"

$(BUILD)/%.o: %.c
	$(CC)  	-mcpu=$(DEVICE) \
            -c  -x c -D__$(DEVICE)__ \
            -Wl,--gc-sections -O1 \
            -ffunction-sections \
            -fdata-sections \
            -fshort-enums \
            -fno-common \
            -funsigned-char \
            -funsigned-bitfields \
            -Wall -DXPRJ_default=default \
            -gdwarf-3 \
            -mno-const-data-in-progmem \
            -MD -MP -MF "$@.d" \
            -MT "$@.d" \
            -MT $@ \
            -o $@ \
            $<


build:
	mkdir -p "$(BUILD)"
	mkdir -p "$(DIST)"



flash:
	$(FLASH) -c arduino -p m328p -P $(COM) -b $(BAUDRATE) -U flash:w:$(HEX_PATH):a
