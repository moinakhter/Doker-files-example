#!/usr/bin/env bash

# Redis monitor for all the channels except for the ww_input.
redis-cli -a darvis monitor | grep -v "ww_input"