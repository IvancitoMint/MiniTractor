#!/usr/bin/env bash
set -e

source /opt/ros/humble/setup.bash

if [ -f /home/ros/MiniTractor/workspace/install/setup.bash ]; then
    source /home/ros/MiniTractor/workspace/install/setup.bash
fi

exec "$@"
