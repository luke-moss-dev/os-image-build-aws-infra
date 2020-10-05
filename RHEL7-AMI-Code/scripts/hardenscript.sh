
#*************************************************
#  V-204424, V-71937; SV-86561                   #
# CIS Rule 5.3.2                                 #
# CIS Rule 5.3.3                                 #
#*************************************************

sudo -s << EOF
sudo sed -i 's/\<nullok\>//g' /etc/pam.d/system-auth
sudo sed -i 's/\<nullok\>//g' /etc/pam.d/password-auth
EOF
sudo -s << EOF 
echo 'auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900' >> /etc/pam.d/system-auth
echo 'auth [success=1 default=bad] pam_unix.so' >> /etc/pam.d/system-auth
echo 'auth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900' >> /etc/pam.d/system-auth
echo 'auth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900' >> /etc/pam.d/system-auth
echo 'password sufficient pam_unix.so remember=5' >> /etc/pam.d/system-auth
EOF
sudo -s << EOF
echo 'auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900' >> /etc/pam.d/password-auth
echo 'auth [success=1 default=bad] pam_unix.so' >> /etc/pam.d/password-auth
echo 'auth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900' >> /etc/pam.d/password-auth
echo 'auth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900' >> /etc/pam.d/password-auth
echo 'password sufficient pam_unix.so remember=5' >> /etc/pam.d/password-auth
EOF


#*************************************************
#  V-204438, V-81005; SV-95717                   #
#*************************************************

#  fixed this manually  grub2 automation hard to find


#*************************************************
#  V-204448, V-71979; SV-86603                   #
#*************************************************
sudo -s << EOF
sudo echo "localpkg_gpgcheck=1" >> /etc/yum.conf
sudo yum update -y
EOF

#*************************************************
#  V-204448, V-71979; SV-86603                   #
#*************************************************

# This is a release issue, stating 7.8 doesn't fit criteria
# for supported version.  Possibly not true


#*************************************************
#  V-204448, V-71979; SV-86603                   #      #Still needs work to satisfy
#*************************************************

sudo -s << EOF
sudo yum install -y dracut-fips
sudo dracut -f
sudo sed -i 's/GRUB_CMDLINE_LINUX="console=ttyS0,115200n8 console=tty0 net.ifnames=0 rd.blacklist=nouveau nvme_core.io_timeout=4294967295 crashkernel=auto"/GRUB_CMDLINE_LINUX="console=ttyS0,115200n8 console=tty0 net.ifnames=0 rd.blacklist=nouveau nvme_core.io_timeout=4294967295 crashkernel=auto fips=1"/g' /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
EOF

#*************************************************
#  V-204401, V-71897; SV-86521                   #
#*************************************************

sudo -s <<EOF
sudo yum install -y screen
EOF

#*************************************************
#  V-204407, V-71903; SV-86527                   #
#  V-204408, V-71905; SV-86529                   #
#  V-204409, V-71907; SV-86531                   #
#  V-204410, V-71909; SV-86533                   #
#  V-204411, V-71911; SV-86535                   #
#  V-204412, V-71913; SV-86537                   #
#  V-204413, V-71915; SV-86539                   #
#  V-204414, V-71917; SV-86541                   #
#  V-204423, V-71935; SV-86559                   #
#*************************************************

sudo -s << EOF
sudo sed -i 's/^# ucredit.*/ucredit = -1/g' /etc/security/pwquality.conf
sudo sed -i 's/^# lcredit.*/lcredit = -1/g' /etc/security/pwquality.conf
sudo sed -i 's/^# dcredit.*/dcredit = -1/g' /etc/security/pwquality.conf
sudo sed -i 's/^# ocredit.*/ocredit = -1/g' /etc/security/pwquality.conf
sudo sed -i 's/^# difok.*/difok = 8/g' /etc/security/pwquality.conf
sudo sed -i 's/^# minclass.*/minclass = 4/g' /etc/security/pwquality.conf
sudo sed -i 's/^# maxrepeat.*/maxrepeat = 3/g' /etc/security/pwquality.conf
sudo sed -i 's/^# maxclassrepeat.*/maxclassrepeat = 3/g' /etc/security/pwquality.conf
sudo sed -i 's/^# minlen.*/minlen = 15/g' /etc/security/pwquality.conf
EOF

#*************************************************
#  V-204418, V-71925; SV-86549                   #
#  V-204420, V-71929; SV-86553                   #
# CIS 5.4.1.2 - changes passmindays to 7         #
#*************************************************

sudo -s << EOF
sudo sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   7/g' /etc/login.defs
sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   60/g' /etc/login.defs
EOF

#*************************************************
#  V-204401, V-77825; SV-92521                   #
#*************************************************

sudo -s << EOF
sudo sed -i 's/^INACTIVE.*/INACTIVE=0/g' /etc/default/useradd
EOF

#*************************************************
#  V-204584, V-71897; SV-86521                   #
#*************************************************

sudo -s << EOF
sudo echo "kernel.randomize_va_space = 2" >> /etc/sysctl.conf
sudo sysctl --system
EOF

#************************************************************
# CIS Operating System Security Configuration Benchmarks-1.0#
# Rule 5.2.13                                               # 
# Rule 5.2.5                                                #
# Rule 5.2.15                                               #
# Rule 5.2.3                                                #
# Rule 5.2.14                                               #
#************************************************************

sudo -s << EOF
sudo sed -i 's/^#ClientAliveInterval.*/ClientAliveInterval   300/g' /etc/ssh/sshd_config
sudo sed -i 's/^#ClientAliveCountMax.*/ClientAliveCountMax   0/g' /etc/ssh/sshd_config
sudo sed -i 's/^#MaxAuthTries.*/MaxAuthTries   4/g' /etc/ssh/sshd_config
sudo sed -i 's/^#LogLevel INFO.*/LogLevel INFO' /etc/ssh/sshd_config
sudo sed -i 's/^#LoginGraceTime.*/LoginGraceTime 60/g' /etc/ssh/sshd_config
sudo echo "DenyUsers nobody" >> /etc/ssh/sshd_config
sudo systemctl restart sshd
EOF


#************************************************************
# CIS Operating System Security Configuration Benchmarks-1.0#
# Rule 3.4.1                                                #
#************************************************************

sudo -s << EOF
sudo yum install -y tcp_wrappers
EOF


#************************************************************   
# CIS Operating System Security Configuration Benchmarks-1.0#
# Rule 4.1.11                                               #
# Rule 4.1.8                                                #  
# Rule 4.1.18                                               #
# Rule 4.1.13                                               #
# Rule 4.1.14                                               #
# Rule 4.1.6                                                #
# Rule 4.1.17                                               #
# Rule 4.1.7                                                #
# Rule 4.1.8                                                #
# Rule 4.1.9                                                #
# Rule 4.1.10                                               #
# Rule 4.1.15                                               #
# Rule 4.1.16                                               #
#************************************************************

sudo -s << EOL
sudo cat << EOF >> /etc/audit/rules.d/audit.rules
-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access 
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access 
-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access 
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access
-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts
-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts
-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete
-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete
-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale
-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale
-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295
-k perm_mod
-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295
-k perm_mod
-w /etc/issue -p wa -k system-locale
-w /etc/issue.net -p wa -k system-locale
-w /etc/hosts -p wa -k system-locale
-w /etc/sysconfig/network -p wa -k system-locale
-w /var/log/lastlog -p wa -k logins-w /var/run/faillock/ -p wa -k logins
-w /var/log/lastlog -p wa -k logins
-w /var/run/faillock/ -p wa -k logins
-w /sbin/insmod -p x -k modules
-w /sbin/rmmod -p x -k modules
-w /sbin/modprobe -p x -k modules
-w /etc/selinux/ -p wa -k MAC-policy
-w /var/log/sudo.log -p wa -k actions
-w /etc/sudoers -p wa -k scope
-w /etc/sudoers.d -p wa -k scope
-w /var/log/lastlog -p wa -k logins
-w /var/run/faillock/ -p wa -k logins
-w /var/run/utmp -p wa -k session
-w /var/log/wtmp -p wa -k session
-w /var/log/btmp -p wa -k session
-a always,exit arch=b64 -S init_module -S delete_module -k modules
-e 2
EOF

sudo systemctl daemon-reload
sudo service auditd restart
EOL


#************************************************************
# CIS Operating System Security Configuration Benchmarks-1.0#
# Rule 3.3.2                                                #
# Rule 3.2.4                                                #
# Rule 3.2.2                                                #
#************************************************************
sudo -s << EOL
sudo cat << EOF >> /etc/sysctl.conf
net.ipv6.conf.all.accept_ra = 0
net.ipv6.conf.default.accept_ra = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
EOF

sudo sysctl -w net.ipv6.conf.all.accept_ra=0
sudo sysctl -w net.ipv6.conf.default.accept_ra=0
sudo sysctl -w net.ipv6.conf.all.accept_redirects=0
sudo sysctl -w net.ipv6.conf.default.accept_redirects=0
sudo sysctl -w net.ipv6.route.flush=1
sudo sysctl -w net.ipv4.conf.all.secure_redirects=0
sudo sysctl -w net.ipv4.conf.default.secure_redirects=0
sudo sysctl -w net.ipv4.conf.all.log_martians=1
sudo sysctl -w net.ipv4.conf.default.log_martians=1
sudo sysctl -w net.ipv4.conf.all.accept_redirects=0
sudo sysctl -w net.ipv4.conf.default.accept_redirects=0
sudo sysctl -w net.ipv4.route.flush=1
EOL


#************************************************************
# CIS Operating System Security Configuration Benchmarks-1.0#
# Rule 5.1.4                                                #
# Rule 5.1.5                                                #
# Rule 5.1.6                                                #
# Rule 5.1.7                                                #
#************************************************************

sudo -s << EOF
sudo chown root:root /etc/cron.d
sudo chmod og-rwx /etc/cron.d
sudo chown root:root /etc/cron.daily
sudo chmod og-rwx /etc/cron.daily
sudo chown root:root /etc/cron.weekly
sudo chmod og-rwx /etc/cron.weekly
sudo chown root:root /etc/cron.monthly
sudo chmod og-rwx /etc/cron.monthly
EOF

#************************************************************
# CIS Operating System Security Configuration Benchmarks-1.0#
# Rule 1.1.17                                               #
#************************************************************

sudo -s << EOF
sudo echo "tmpfs /dev/shm tmpfs defaults,nodev,nosuid,noexec 0 0" >> /etc/fstab

sudo mount -o remount,noexec /dev/shm
EOF

#************************************************************
# CIS Operating System Security Configuration Benchmarks-1.0#
# Rule 4.1.3                                                #
#************************************************************

sudo -s << EOF
sudo sed -i 's/GRUB_CMDLINE_LINUX="[^"]*/& audit=1/' /etc/default/grub
sudo grub2-mkconfig > /boot/grub2/grub.cfg
EOF


#************************************************************
# CIS Operating System Security Configuration Benchmarks-1.0#
# Rule 5.2.10                                               #
# Rule 5.2.6                                                #
# Rule                                                      #
# Rule 5.2.8                                                #
# Rule 5.2.9                                                #
#************************************************************

sudo -s << EOF
sudo sed -i 's/^#PermitUserEnvironment.*/PermitUserEnvironment  no/g' /etc/ssh/sshd_config
sudo sed -i 's/^#IgnoreRhosts.*/IgnoreRhosts  yes/g' /etc/ssh/sshd_config
sudo sed -i '/# Ciphers and keying/a Ciphers aes256-ctr,aes192-ctr,aes128-ctr' /etc/ssh/sshd_config
sudo sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo sed -i 's/^#PermitEmptyPasswords.*/PermitEmptyPasswords no/g' /etc/ssh/sshd_config

sudo systemctl restart sshd
EOF


#************************************************************
# CIS Operating System Security Configuration Benchmarks-1.0#    # Pay attention to any effects this might have on localhost with kube cluster
# Rule 3.6.3                                                #
# Rule 3.6.2                                                #
#************************************************************

sudo -s << EOF
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT
sudo iptables -A INPUT -s 127.0.0.0/8 -j DROP
EOF
#sudo iptables -P INPUT DROP
#sudo iptables -P OUTPUT DROP            *These broke ec2*
#sudo iptables -P FORWARD DROP


#************************************************************
# CIS Operating System Security Configuration Benchmarks-1.0#
# Rule 5.4.4                                                #
#************************************************************

sudo -s << EOF
sudo sed -i 's/umask.*/umask 027/g' /etc/bashrc
sudo sed -i 's/umask.*/umask 027/g' /etc/profile
EOF

#************************************************************
# CIS Operating System Security Configuration Benchmarks-1.0#
# Rule 1.1.1.8                                              #
# Rule 1.1.1.1                                              #
# Rule 1.1.1.7                                              #
#************************************************************

sudo -s << EOF
echo "install vfat /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install cramfs /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install udf /bin/true" >> /etc/modprobe.d/CIS.conf
EOF


#************************************************************
# CIS Operating System Security Configuration Benchmarks-1.0#
# Rule 1.3.2                                                #
#************************************************************

sudo -s << EOF
(sudo crontab -l ; echo "0 5 * * * /usr/sbin/aide --check") | sudo crontab -
sudo crontab -l   #to list the crons for build log
EOF

#************************************************************
# CIS Operating System Security Configuration Benchmarks-1.0#
# Rule 4.1.1.2                                              #
#************************************************************

sudo -s << EOF
sudo sed -i 's/^space_left_action.*/space_left_action = email/g' /etc/audit/auditd.conf
sudo sed -i 's/^action_mail_acct.*/action_mail_acct = root/g' /etc/audit/auditd.conf
sudo sed -i 's/^admin_space_left_action.*/admin_space_left_action = halt/g' /etc/audit/auditd.conf
EOF

#************************************************************
# CIS Operating System Security Configuration Benchmarks-1.0#
# Rule 5.4.1.4                                              #
#************************************************************

sudo -s << EOF
sudo useradd -D -f 30
EOF

#************************************************************
# CIS Operating System Security Configuration Benchmarks-1.0#
# Rule 5.1.8                                                #
#************************************************************

sudo -s << EOF
sudo rm /etc/cron.deny
sudo rm /etc/at.deny
sudo touch /etc/cron.allow
sudo touch /etc/at.allow
sudo chmod og-rwx /etc/cron.allow
sudo chmod og-rwx /etc/at.allow
sudo chown root:root /etc/cron.allow
sudo chown root:root /etc/at.allow
EOF

#************************************************************
# CIS Operating System Security Configuration Benchmarks-1.0#
# Rule 4.2.1.3                                              #
#************************************************************

sudo -s << EOF
echo '\$FileCreateMode 0640' >> /etc/rsyslog.conf
EOF


#************************************************************
# CIS Operating System Security Configuration Benchmarks-1.0#  #Leave last??  
# Rule 4.2.4                                                #
#************************************************************

sudo -s << EOF
sudo find -L /var/log -type f -exec sudo chmod g-wx,o-rwx {} +
EOF





