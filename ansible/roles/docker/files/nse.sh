#!/bin/bash
set -eux
nsenter --mount --uts --ipc --net --pid --target $1
