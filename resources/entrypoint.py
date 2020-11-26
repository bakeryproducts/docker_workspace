#!/usr/bin/env python
"""
Configure and run tools
"""

from subprocess import call
import os
import sys
from pathlib import Path

print(sys.argv)
# Enable logging
import logging
logging.basicConfig(
    format='%(asctime)s [%(levelname)s] %(message)s', 
    level=logging.INFO, 
    stream=sys.stdout)

log = logging.getLogger(__name__)

log.info("Init base")

ENV_RESOURCES_PATH = os.getenv("RESOURCES_PATH", "/resources")
ENV_WORKSPACE_HOME = os.getenv('WORKSPACE_HOME', "/workspace")
ENV_USERNAME = os.getenv('USERNAME', 'root')

log.info("Setting permissions")
#call(f'cp /root/.bashrc {ENV_WORKSPACE_HOME}', shell=True)
#call(f'cp /root/.profile {ENV_WORKSPACE_HOME}', shell=True)
#call(f'echo "export PATH=/opt/conda/bin:\$PATH"  >> {ENV_WORKSPACE_HOME}/.profile', shell=True)

#call(f'cp -r /root/.conda {ENV_WORKSPACE_HOME}', shell=True)
call(f'usermod -d /home/{ENV_USERNAME} {ENV_USERNAME}', shell=True)
call(f'usermod --shell /usr/bin/zsh {ENV_USERNAME}', shell=True)
call(f'mkdir {ENV_WORKSPACE_HOME}/.local', shell=True)
call(f'mkdir {ENV_WORKSPACE_HOME}/.config', shell=True)

call(f'chown -R {ENV_USERNAME}:{ENV_USERNAME} {ENV_WORKSPACE_HOME}', shell=True)

log.info("Configure ssh service")
call('service ssh start', shell=True)
call("/bin/bash " + str(f"{ENV_RESOURCES_PATH}/scripts/configure_ssh.sh"), shell=True)

if len(sys.argv) > 1: call(' '.join(sys.argv[1:]), shell=True)
