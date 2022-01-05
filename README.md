# Jetset: Targeted Firmware Rehosting for Embedded Systems

This repository contains all the code and data necessary for building Jetset and reproducing the results presented in our Usenix'21 paper [Jetset: Targeted Firmware Rehosting for Embedded Systems](https://www.usenix.org/system/files/sec21-johnson.pdf).  
  
## Abstract  
The ability to execute code in an emulator is a fundamental part of modern vulnerability testing. 
Unfortunately, this poses a challenge for many embedded systems, where firmware expects to interact with hardware devices specific to the target.
Getting embedded system firmware to run outside its native environment, termed rehosting, requires emulating these hardware devices with enough accuracy to convince the firmware that it is executing on the target hardware.
However, full fidelity emulation of target devices (which requires considerable engineering effort) may not be necessary to boot the firmware to a point of interest for an analyst (for example, apoint where fuzzer input can be injected). 
We hypothesized that, for the firmware to boot successfully, it is sufficient to emulate only the behavior expected by the firmware, and that this behavior could be inferred automatically.  
To test this hypothesis, we developed and implemented Jetset, a system that uses symbolic execution to infer what behavior firmware expects from a target device.  Jetset can generate devices models for hardware peripherals in C, allowing an analyst to boot the firmware in an emulator (e.g.,QEMU). 
We successfully applied Jetset to thirteen distinct pieces of firmware together representing three architectures, three application domains (power grid,  avionics, and consumer electronics), and five different operating systems. 
We also demonstrate how Jetset-assisted rehosting facilitates fuzz-testing, a common security analysis technique, on an avionics embedded system, in which we found a previously unknown privilege escalation vulnerability.

## Build Jetset

You first need to install several dependencies:

```bash
apt-get install git make build-essential zlib1g-dev pkg-config libglib2.0-dev binutils-dev libboost-all-dev autoconf libtool libssl-dev libpixman-1-dev virtualenv xterm
```

Once you have these, you can build Jetset:

```bash
make clone
make config_qemu
make build_qemu
make virtualenv
make build_jetset_engine  
```

## Run Jetset

The top-level script that coordinates symbolic execution and generates peripheral devices is in jetset_engine/execution/jetset_server.py.

Usage:  

```
usage: jetset_server.py [-h] [--useFunctionPrologues] [--useSlicer]
                        [--useFinalizer] [--verbose] [--noAutoDetectLoops]
                        [--port PORT] [--soc SOCNAME] [-o OUTFILE]
                        [--cmdfile CMDFILE]

Run Symbolic Execution engine for Jetset

optional arguments:
  -h, --help            show this help message and exit
  --useFunctionPrologues
                        Try to infer the start of functions (for CFG) using
                        architecture specific function prologues
  --useSlicer           Use constraint slicer to improve performance of
                        constraint solving
  --useFinalizer        After making a certain decision n times, finalize and
                        make that always the solution
  --verbose             Print out all log messages and other warnings
  --noAutoDetectLoops   Omit auto loop detection
  --port PORT           Port number to communicate with Qemu (over localhost)
  --soc SOCNAME         Type of soc (console | heat_press | steering_control |
                        robot | gateway | drone | reflow_oven | cnc | stm32f4
                        | rpi | beagle)
  -o OUTFILE            output file
  --cmdfile CMDFILE     path to script to invoke qemu instance. If window
                        doesn't open, make sure that the qemu run script is
                        executable
```

## Reproducing evaluation results

This repo contains all the infrastructure necessary for reproducing the results described in the paper. Once you build Jetset you can run our public evaluation targets.

### Running the evaluation suite

To symbolically execute and synthesize devices for the targets described in the paper, except the CMU900 and ICS binaries (they are proprietary / security-critical) the make command corresponding to a target run:

```bash
make run_<target name>
```

For example:  
```bash
make run_rpi
```

To run the synthesized devices used in the paper:

```bash
make run_<target name>_concrete
```

For example:  

```bash
make run_rpi_concrete
```


## Related repos

  There are three other repos needed to reproduce results. They are all pulled in automatically by the makefile.  

- **Symbolic Execution Engine**: Jetset's symbolic execution is [here](https://github.com/aerosec/jetset_engine.git).

- **Modified QEMU**: Jetset's modified version of qemu is [here](https://github.com/aerosec/jetset_qemu.git).

- **Binaries used for evaluation**: The binaries we executed as part of our evaluation are [here](https://github.com/aerosec/jetset_public_data.git).

- **Architecture Independent Fuzzer**: Jetset's fuzzer is [here](https://github.com/aerosec/jetset_fuzzer.git).

## FAQ

**How do I add custom firmware and symbolic devices?**: See the README.md files [here](https://github.com/aerosec/jetset_engine.git) and [here](https://github.com/aerosec/jetset_qemu.git).
