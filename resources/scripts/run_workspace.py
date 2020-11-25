#!/usr/bin/env python
"""
Configure and run tools
"""

from subprocess import call
import os
import sys
from pathlib import Path


# Enable logging
import logging
logging.basicConfig(
    format='%(asctime)s [%(levelname)s] %(message)s', 
    level=logging.INFO, 
    stream=sys.stdout)

log = logging.getLogger(__name__)

log.info("Start Workspace")

ENV_RESOURCES_PATH = Path(os.getenv("RESOURCES_PATH", "/resources"))
WORKSPACE_HOME = Path(os.getenv('WORKSPACE_HOME', "/workspace"))


log.info("Configure ssh service")
call("/bin/bash " + str(ENV_RESOURCES_PATH / "scripts/configure_ssh.sh"), shell=True)

#log.info("Configure tools")
#call("python3 " + ENV_RESOURCES_PATH / "scripts/configure_tools.py", shell=True)

startup_custom_script = str(ENV_RESOURCES_PATH / "scripts/internal_run.sh")
if os.path.exists(startup_custom_script):
    log.info("Run internal_run.sh user script from workspace folder")
    call("/bin/bash " + startup_custom_script, shell=True)

call('/bin/bash', shell=True)