.PHONY: clone pull config_qemu build_qemu virtualenv build_jetset_engine build

SHELL := /bin/bash
ENGINE_BASE := jetset_engine
ENGINE_SCRIPT := jetset_engine/jetset_server.py
ACTIVATE_VIRTUALENV := jetset_env/bin/activate

clone:
	git clone https://github.com/enjhnsn2/jetset_engine.git
	git clone https://github.com/enjhnsn2/jetset_qemu.git
	git clone https://github.com/enjhnsn2/jetset_public_data.git

pull:
	cd jetset_engine && git pull
	cd jetset_qemu && git pull
	cd jetset_public_data && git pull
	cd jetset_private_data && git pull

config_qemu:
	if [ ! -d jetset_qemu/build ]; then \
    	mkdir jetset_qemu/build; \
    fi
	cd jetset_qemu/build && \
	../configure --python=python3 --target-list=arm-softmmu,i386-softmmu,m68k-softmmu --disable-nettle --disable-docs --cpu=unknown --enable-tcg-interpreter --disable-werror

virtualenv:
	virtualenv -p python3 jetset_env  

build_jetset_engine:
	source jetset_env/bin/activate && \
	pip install -e jetset_engine/archinfo   && \
	pip install -e jetset_engine/pyvex  && \
	pip install -e jetset_engine/claripy  && \
	pip install -e jetset_engine/cle  && \
	pip install -e jetset_engine/angr  && \
	pip install -e jetset_engine/angr_platforms 

build_qemu:
	cd jetset_qemu/build && \
	make

run_rpi:
	source jetset_env/bin/activate && cd $(ENGINE_BASE) && python $(ENGINE_SCRIPT) --soc=rpi --useFinalizer --useSlicer --cmdfile ../jetset_qemu/run_rpi_qemu.sh

run_beagle:
	source jetset_env/bin/activate && cd $(ENGINE_BASE) && python $(ENGINE_SCRIPT) --soc=beagle --useSlicer --cmdfile ../jetset_qemu/run_beagle_qemu.sh

run_plc:
	source jetset_env/bin/activate && cd $(ENGINE_BASE) && python $(ENGINE_SCRIPT) --soc=stm32f4 --useFunctionPrologues -o=plc_device.c --useSlicer --cmdfile ../jetset_qemu/run_plc_qemu.sh

run_cnc:
	source jetset_env/bin/activate && cd $(ENGINE_BASE) && python $(ENGINE_SCRIPT) --soc=cnc --useFunctionPrologues --useSlicer -o=cnc_device.c --cmdfile ../jetset_qemu/run_cnc_qemu.sh

run_reflow_oven:
	source jetset_env/bin/activate && cd $(ENGINE_BASE) && python $(ENGINE_SCRIPT) --soc=reflow_oven -o=reflow_oven_device.c --cmdfile ../jetset_qemu/run_reflow_oven_qemu.sh --useFunctionPrologues

run_gateway:
	source jetset_env/bin/activate && cd $(ENGINE_BASE) && python $(ENGINE_SCRIPT) --soc=gateway -o=gateway_device.c --cmdfile ../jetset_qemu/run_gateway_qemu.sh --useFunctionPrologues

run_robot:
	source jetset_env/bin/activate && cd $(ENGINE_BASE) && python $(ENGINE_SCRIPT) --soc=robot -o=robot_device.c --cmdfile ../jetset_qemu/run_robot_qemu.sh --useFunctionPrologues

run_drone:
	source jetset_env/bin/activate && cd $(ENGINE_BASE) && python $(ENGINE_SCRIPT) --soc=drone -o=drone_device.c --cmdfile ../jetset_qemu/run_drone_qemu.sh --useFunctionPrologues

run_console:
	source jetset_env/bin/activate && cd $(ENGINE_BASE) && python $(ENGINE_SCRIPT) --soc=console -o=console_device.c --cmdfile ../jetset_qemu/run_console_qemu.sh --useFunctionPrologues

run_heat_press:
	source jetset_env/bin/activate && cd $(ENGINE_BASE) && python $(ENGINE_SCRIPT) --soc=heat_press -o=heat_press_device.c --cmdfile ../jetset_qemu/run_heat_press.sh --useFunctionPrologues

run_steering_control:
	source jetset_env/bin/activate && cd $(ENGINE_BASE) && python $(ENGINE_SCRIPT) --soc=steering_control -o=steering_control_device.c --cmdfile ../jetset_qemu/run_steering_control.sh --useFunctionPrologues

run_rpi_concrete:
	bash jetset_qemu/run_rpi_qemu_concrete.sh

run_beagle_concrete:
	bash jetset_qemu/run_beagle_qemu_concrete.sh

run_plc_concrete:
	bash jetset_qemu/run_plc_qemu_concrete.sh

run_cnc_concrete:
	bash jetset_qemu/run_cnc_qemu_concrete.sh

run_reflow_oven_concrete:
	bash jetset_qemu/run_reflow_oven_qemu_concrete.sh

run_gateway_concrete:
	bash jetset_qemu/run_gateway_qemu_concrete.sh

run_robot_concrete:
	bash jetset_qemu/run_robot_qemu_concrete.sh

run_drone_concrete:
	bash jetset_qemu/run_drone_qemu_concrete.sh

run_console_concrete:
	bash jetset_qemu/run_console_qemu_concrete.sh

run_heat_press_concrete:
	bash jetset_qemu/run_heat_press_concrete.sh

run_steering_control_concrete:
	bash jetset_qemu/run_steering_control_concrete.sh
