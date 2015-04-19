# Set container maintenance port
sed -i -e "s/@@PORT@@/${MAINTENANCE_PORT}/" /etc/monit/conf.d/openssh-server.conf
sed -i -e "s/@@PORT@@/${MAINTENANCE_PORT}/" /etc/ssh/sshd_config
