#!/bin/sh

set -o errexit
set -o pipefail

# Constants
RESET='\033[0m'
RED='\033[38;5;1m'
GREEN='\033[38;5;2m'

# Variables
error_code=0

# Auxiliary functions
info() {
  printf "%b\\n" "${*}" >&2
}

error() {
  printf "%b\\n" "${*}" >&2
  error_code=1
}

print_validation_error() {
  error "${RED} ERROR ==>" "$1" "${RESET}"
}

empty_variable() {
  print_validation_error "The $1 environment variable is empty or not set."
  error_code=2
}

longer_password() {
  print_validation_error "The password can not be longer than 32 characters. Set the environment variable $1 with a shorter value (currently ${#$1} characters)"
  error_code=3
}

wrong_char() {
  print_validation_error "The password cannot contain backslashes ('\'). Set the environment variable $1 with no backslashes"
  error_code=4
}