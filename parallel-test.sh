
#!/bin/bash 

set -e

# RHEL
make rhel7 &

# Centos
make centos7 &


wait