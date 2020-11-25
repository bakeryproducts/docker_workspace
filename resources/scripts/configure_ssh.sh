#!/bin/sh
set -e
cp $RESOURCES_PATH/config/sshd_config /etc/ssh/
mkdir -m 700 $WORKSPACE_HOME/.ssh/
touch $WORKSPACE_HOME/.ssh/authorized_keys

for filename in $RESOURCES_PATH/keys/*.pub; do
    cat "$filename" >>  $WORKSPACE_HOME/.ssh/authorized_keys
done

chown -R $USERNAME:$USERNAME $WORKSPACE_HOME/.ssh