#!/bin/bash

iverilog bus/*.v cpu/*.v -Iinclude -Ibus/include -Icpu/include
vvp a.out
