################################################################
# Performs Basic Patching of the OS and libraries              #
################################################################

#!/bin/bash
set -e

sudo -s << EOF
    if zypper -n refresh; then zypper -n update;
    else yum update -y;
    fi
EOF