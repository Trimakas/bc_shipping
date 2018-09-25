#!/bin/bash
set -e

mkdir -p /root/.ssh/
echo -e "$authorized_keys" > /root/.ssh/authorized_keys

exec "$@"
