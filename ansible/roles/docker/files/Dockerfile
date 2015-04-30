FROM ubuntu:trusty
MAINTAINER KIYOHIRO ADACHI <kiyoad@da2.so-net.ne.jp>

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && apt-get upgrade -y && \
  apt-get install -qy wget python-mysqldb mysql-client monit openssh-server && \
  mkdir .build_pip && \
  (cd .build_pip && wget -q https://bootstrap.pypa.io/get-pip.py && python get-pip.py && cd ..) && \
  pip install crudini

ADD monit_openssh-server.conf /etc/monit/conf.d/openssh-server.conf
ADD sshd_config /etc/ssh/sshd_config
ADD set_maintenance_port.sh /usr/local/bin/set_maintenance_port.sh
ADD maintenance_id_rsa.pub /tmp/maintenance_id_rsa.pub

RUN \
  mkdir /var/run/sshd && \
  adduser --disabled-password --gecos "Maintainer" --uid 1000 maintainer && \
  mkdir /home/maintainer/.ssh && \
  cp /tmp/maintenance_id_rsa.pub /home/maintainer/.ssh/authorized_keys && \
  chown -R maintainer:maintainer /home/maintainer && \
  echo "maintainer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/maintainer && \
  chmod 0440 /etc/sudoers.d/maintainer
