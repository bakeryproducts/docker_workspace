#!/usr/bin/python

from subprocess import call
import os
import sys

# Enable logging
import logging
logging.basicConfig(
    format='%(asctime)s [%(levelname)s] %(message)s', 
    level=logging.INFO, 
    stream=sys.stdout)

log = logging.getLogger(__name__)

log.info("Starting...")

ENV_RESOURCES_PATH = Path(os.getenv("RESOURCES_PATH", "/resources"))
WORKSPACE_HOME = Path(os.getenv('WORKSPACE_HOME', "/workspace"))

call(f'/bin/bash cp {ENV_RESOURCES_PATH}/configs/sshd_config /etc/ssh/')
call(f'/bin/bash mkdir -m 700 {WORKSPACE_HOME}/.ssh')
call(f'/bin/bash cp {ENV_RESOURCES_PATH}/keys/id.pub {WORKSPACE_HOME}/.ssh/authorized_keys')
call(f'/bin/bash mkdir -m 700 {ENV_RESOURCES_PATH}/.ssh')