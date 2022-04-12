PROJECT = stm32g491_coremark
STM32CUBE = ./STM32CubeG4

CC = arm-none-eabi-gcc
OPTFLAGS += -O3 -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS += $(OPTFLAGS)
CFLAGS += -DFLAGS_STR=\""$(OPTFLAGS)\"" -DITERATIONS=0

CFLAGS += -DUSE_HAL_DRIVER
CFLAGS += -DSTM32G491xx
CFLAGS += -DDEBUG

CFLAGS += -I./Inc
CFLAGS += -I$(STM32CUBE)/Drivers/STM32G4xx_HAL_Driver/Inc
CFLAGS += -I$(STM32CUBE)/Drivers/STM32G4xx_HAL_Driver/Inc/Legacy
CFLAGS += -I$(STM32CUBE)/Drivers/CMSIS/Device/ST/STM32G4xx/Include
CFLAGS += -I$(STM32CUBE)/Drivers/CMSIS/Include
CFLAGS += -I$(STM32CUBE)/Drivers/BSP/STM32G4xx_Nucleo

LFLAGS  = -Wl,-T$(LINKERSCRIPT) --specs=nano.specs

LOCALOBJS = core_list_join.o core_main.o core_matrix.o core_portme.o core_state.o core_util.o cvt.o ee_printf.o 
LOCALOBJS += main.o stm32g4xx_hal_msp.o stm32g4xx_it.o system_stm32g4xx.o syscalls.o sysmem.o
HALOBJS   = stm32g4xx_hal.hal.o stm32g4xx_hal_cortex.hal.o stm32g4xx_hal_dma.hal.o stm32g4xx_hal_dma_ex.hal.o
HALOBJS  += stm32g4xx_hal_exti.hal.o stm32g4xx_hal_flash.hal.o stm32g4xx_hal_flash_ex.hal.o
HALOBJS  += stm32g4xx_hal_flash_ramfunc.hal.o stm32g4xx_hal_gpio.hal.o stm32g4xx_hal_pwr.hal.o
HALOBJS  += stm32g4xx_hal_pwr_ex.hal.o stm32g4xx_hal_rcc.hal.o stm32g4xx_hal_rcc_ex.hal.o
HALOBJS  += stm32g4xx_hal_tim.hal.o stm32g4xx_hal_tim_ex.hal.o stm32g4xx_hal_uart.hal.o
HALOBJS  += stm32g4xx_hal_uart_ex.hal.o
#BSPOBJS   = stm32g4xx_nucleo.bsp.o

STARTUP   = $(STM32CUBE)/Drivers/CMSIS/Device/ST/STM32G4xx/Source/Templates/gcc/startup_stm32g491xx.s
LINKERSCRIPT = STM32G491RETX_FLASH.ld

$(PROJECT).elf: $(STARTUP) $(LOCALOBJS) $(HALOBJS) $(BSPOBJS)
	$(CC) $(CFLAGS) $(LFLAGS) -o $@ $^

%.hal.o: $(STM32CUBE)/Drivers/STM32G4xx_HAL_Driver/Src/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.bsp.o: $(STM32CUBE)/Drivers/BSP/STM32G4xx_Nucleo/%.c
	$(CC) $(CFLAGS) -c -o $@ $<
	
%.o: ./Src/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -rf *.o $(PROJECT).elf

.PHONY: clean
