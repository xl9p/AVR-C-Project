# AVR C Project
A simple AVR C project. Includes two toolchains: `GNU AVR`, and `Microchip XC8`.

There is support for `clangd` language server, it works fine with `GNU AVR` toolchain. Unfortunately, `Microchip XC8` requires using the supplied `xc8-clangd` binary instead.

While `GNU AVR` toolchain supports C, C++ and assembly, `Microchip XC8` toolchain does not support C++.

## Requirements
- CMake 3.20 or newer.
- GNU Make.
- GNU AVR toolchain that supplies `avr-gcc`, `avr-g++`, `avr-ar`/`avr-gcc-ar`, `avr-ranlib`, `avr-objcopy`, `avr-objdump`, and `avr-size`, in PATH.
- Microchip `AVR-Dx_DFP` version `2.8.343`, installed under
  `/opt/Microchip/AVR-Dx_DFP/2.8.343` by default.
- `Microchip XC8` compiler toolchain version `4.00`, 
  installed under `/opt/Microchip/xc8-v4.00` by default.

### Troubleshooting
 - If the DFP pack is elsewhere or has a different version, override `PACK_REPO_PATH` or `AVR_DFP_VERSION` when configuring CMake. 

 - The MCU is configurable as well, use `AVR_MCU` to override it during configuration; the example defaults to `avr128da28`.

 - To override the `xc8` compiler location override the `AVR_XC8_ROOT` CMake variable.

 - The selected GNU AVR compiler must support `-mmcu={AVR_MCU}`. Compiler version
support differs by distribution release, so verify with `avr-gcc --version` and
`avr-gcc -mmcu={AVR_MCU} -E -x c /dev/null` before debugging CMake setup.

 - The same applies to the `xc8` compiler. Check by executing `{AVR_XC8_ROOT}/bin/xc8-cc -mmcu={AVR_MCU} -mdfp={PACK_REPO_PATH}/Microchip/AVR-Dx_DFP/{AVR_DFP_VERSION}/xc8 -E -x c /dev/null`, substitute the placeholder variables in curly brackets with their actual values.
For the environment provided by the project's `Dockerfile` it is `/opt/Microchip/xc8-v4.00/bin/xc8-cc -mmcu=avr128da28 -mdfp=\"/opt/Microchip/AVR-Dx_DFP/2.8.343/xc8\" -E -x c /dev/null`.


## Building
The project's build process is organized around CMake's presets.

List available presets:
```sh
cmake --list-presets
cmake --build --list-presets
```

Configure and build with a `<preset>` :
```sh
cmake --preset <preset>
cmake --build --preset <preset>
```

Debug build is built by default, override it by supplying `-DCMAKE_BUILD_TYPE=<build type>` during configuration.

## Flashing
Typically, two options:
  - Use a USB-to-UART bridge to make a custom UPDI programmer and use compatible programmer software.
  - Use an official debugger with compatible programmer software (avrdude, vscode microchip.mplab-core-da extension, pymcuprog, etc).

The project is preconfigured to use VSCode `microchip.mplab-core-da` extension with the official MPLAB Snap debugger.