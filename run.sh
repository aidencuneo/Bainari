#!/bin/bash

gcc src/char.c -o bin/char
if [[ $? != 0 ]]; then exit; fi
bin/char $@
