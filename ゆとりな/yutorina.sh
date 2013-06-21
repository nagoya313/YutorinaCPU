#!/bin/bash

iverilog bus/rtl/*.v cpu/rtl/*.v io/*/rtl/*.v top/rtl/*.v lib/*.v test/*.v -Iinclude -Ibus/include -Icpu/include -Iio/rom/include -Iio/timer/include -DYUTORINA_SIMULATION
