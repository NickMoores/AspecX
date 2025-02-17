#!/bin/bash
set -ex

# Startup background services
supervisord -c /app/supervisord.conf

sleep 5s

# Start AspecX
exec /venv/bin/python /app/aspecx.py
