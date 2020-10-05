############################################
# Installing Oscap and AWS Inspector Agent #
#                                          #
# Places STIG XML in $HOME/scan-stig       #
############################################


# Openscap and STIG XML file delivery

sudo -s << EOF
yum install -y openscap-scanner
yum install -y scap-security-guide
EOF


# Install Amazon Inspector Agent

sudo -s << EOF
curl -O https://inspector-agent.amazonaws.com/linux/latest/install
bash install
rm install
EOF

