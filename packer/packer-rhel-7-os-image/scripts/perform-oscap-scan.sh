################################################################
# Performs Oscap scan using provided STIG                      #
#                                                              #
# Moves file to home directory of user                         #
################################################################


# Perform scan   # Would like to not hardcode the datastream-id, but get from oscap info command

cd scan-stig

sudo -s << EOF
oscap xccdf eval --datastream-id scap_mil.disa.stig_datastream_U_RHEL_7_V3R0-4_STIG_SCAP_1-2_Benchmark \
  --profile xccdf_mil.disa.stig_profile_MAC-1_Classified \
  --results xccdf-results.xml \
  U_RHEL_7_V3R0-4_STIG_SCAP_1-2_Benchmark.xml
EOF



# Move results file

sudo chown $USER:$USER xccdf-results.xml
mv xccdf-results.xml $HOME/xccdf-results.xml


