#!/usr/bin/env bash

set -euo pipefail

acpi -b | awk '{ printf "%s%s;", $4, $5}'
