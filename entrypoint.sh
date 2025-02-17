#!/bin/bash
set -ex

# Startup background services
supervisord -c /app/supervisord.conf

# Start AspecX
exec /venv/bin/python /aspecx.py
