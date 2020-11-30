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
log.info("Starting workspace")


ENV_RESOURCES_PATH = os.getenv("RESOURCES_PATH", "/resources")
ENV_WORKSPACE_HOME = os.getenv('WORKSPACE_HOME', "/workspace")
ENV_USERNAME = os.getenv('WORKSPACE_USERNAME', 'root')


log.info("Setting up bakery")
call(f'su {ENV_USERNAME} --command "{ENV_RESOURCES_PATH}/scripts/install_bakery.sh"', shell=True)


log.info("Workspace started.")
call('/bin/bash', shell=True)
# pass all script arguments to next script
#script_arguments = " " + ' '.join(sys.argv[1:])
#
#EXECUTE_CODE = os.getenv('EXECUTE_CODE', None)
#if EXECUTE_CODE:
#    # use workspace as working directory
#    sys.exit(call("cd " + ENV_WORKSPACE_HOME + " && python3 " + ENV_RESOURCES_PATH + "/scripts/execute_code.py" + script_arguments, shell=True))
#
#sys.exit(call("python3 " + ENV_RESOURCES_PATH + "/scripts/init_workspace.py" + script_arguments, shell=True))

