#!/usr/bin/env python
"""
Configure and run tools
"""

from subprocess import call
import os
import sys
from pathlib import Path
from subprocess import DEVNULL, STDOUT, check_call


def call_quiet(cmd): return check_call(cmd.split(" "), stdout=DEVNULL, stderr=STDOUT)

import logging
logging.basicConfig(
    format='%(asctime)s [%(levelname)s] %(message)s', 
    level=logging.INFO, 
    stream=sys.stdout)

log = logging.getLogger(__name__)

log.info("Init base")

ENV_RESOURCES_PATH = os.getenv("RESOURCES_PATH", "/resources")
ENV_WORKSPACE_HOME = os.getenv('WORKSPACE_HOME', "/workspace")
ENV_USERNAME = os.getenv('WORKSPACE_USERNAME', 'root')

log.info("Dropping env")
env_path = f"{ENV_RESOURCES_PATH}/scripts:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
call(f'echo "PATH=\"{env_path}\"" > /etc/environment', shell=True)

call(f'echo "RESOURCES_PATH=\"{ENV_RESOURCES_PATH}\"" >> /etc/environment', shell=True)
call(f'echo "WORKSPACE_HOME=\"{ENV_WORKSPACE_HOME}\"" >> /etc/environment', shell=True)
call(f'echo "WORKSPACE_USERNAME=\"{ENV_USERNAME}\"" >> /etc/environment', shell=True)
#call(f'env | grep _ >> /etc/environment', shell=True)

log.info("Setting permissions")
call(f'usermod -d /home/{ENV_USERNAME} {ENV_USERNAME}', shell=True)
call(f'usermod --shell /usr/bin/zsh {ENV_USERNAME}', shell=True)
call(f'mkdir {ENV_WORKSPACE_HOME}/.local', shell=True)
call(f'mkdir {ENV_WORKSPACE_HOME}/.config', shell=True)

call(f'chown -R {ENV_USERNAME}:{ENV_USERNAME} {ENV_WORKSPACE_HOME}', shell=True)

if call_quiet("service ssh status") != 0:
    log.info("Configure ssh service")
    call('service ssh start', shell=True)
    call("/bin/bash " + str(f"{ENV_RESOURCES_PATH}/scripts/configure_ssh.sh"), shell=True)

if len(sys.argv) > 1:  call(' '.join(sys.argv[1:]), shell=True)
