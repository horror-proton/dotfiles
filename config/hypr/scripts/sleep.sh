#!/usr/bin/env bash
set -e

_args=(
    -w
    timeout $((60 * 5)) 'hyprctl dispatch dpms off'
    resume 'hyprctl dispatch dpms on'
)

swayidle "${_args[@]}"
