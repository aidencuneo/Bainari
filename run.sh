#!/bin/bash

gcc src/bainari.c -o bin/bainari
if [[ $? != 0 ]]; then exit; fi
bin/bainari $@
