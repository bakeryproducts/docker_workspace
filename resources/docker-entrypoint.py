#!/usr/bin/env python
"""
Main Workspace Run Script
"""

from subprocess import call
import os
import math
import sys
from urllib.parse import quote

# Enable logging
import logging
logging.basicConfig(
    format='%(asctime)s [%(levelname)s] %(message)s', 
    level=logging.INFO, 
    stream=sys.stdout)

log = logging.getLogger(__name__)
log.info("Starting...")

def set_env_variable(env_variable: str, value: str, ignore_if_set: bool = False):
    if ignore_if_set and os.getenv(env_variable, None):
        # if it is already set, do not set it to the new value
        return
    # TODO is export needed as well?
    call('export ' + env_variable + '="' + value + '"', shell=True)
    os.environ[env_variable] = value


ENV_RESOURCES_PATH = os.getenv("RESOURCES_PATH", "/resources")
ENV_WORKSPACE_HOME = os.getenv('WORKSPACE_HOME', "/workspace")
ENV_USERNAME = os.getenv('USERNAME', 'root')

call(f'usermod -d /home/{ENV_USERNAME} {ENV_USERNAME}', shell=True)
call(f'chown {ENV_USERNAME}:{ENV_USERNAME} {ENV_WORKSPACE_HOME}', shell=True)
call('service ssh start', shell=True)

# pass all script arguments to next script
script_arguments = " " + ' '.join(sys.argv[1:])

EXECUTE_CODE = os.getenv('EXECUTE_CODE', None)
if EXECUTE_CODE:
    # use workspace as working directory
    sys.exit(call("cd " + ENV_WORKSPACE_HOME + " && python3 " + ENV_RESOURCES_PATH + "/scripts/execute_code.py" + script_arguments, shell=True))

sys.exit(call("python3 " + ENV_RESOURCES_PATH + "/scripts/run_workspace.py" + script_arguments, shell=True))