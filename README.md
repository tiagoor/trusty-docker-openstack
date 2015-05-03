# trusty-docker-openstack
OpenStack Demo for Ubuntu trusty by Ansible and Docker

## Abstract

This Vagrantfile will deploy the OpenStack Icehouse envirionment on Ubuntu 14.04 LTS virtual machines with VirtualBox.
OpenStack components that run on *controller* uses Docker container.

![trusty-docker-openstack components and networks](https://raw.githubusercontent.com/kiyoad/trusty-docker-openstack/master/images/trusty-docker-openstack.gif)

## Requirements

My development environment is shown below. I think that Ubuntu LinuxBox also works.

    $ cat /etc/redhat-release
    CentOS Linux release 7.1.1503 (Core)
    $ uname -a
    Linux zouk.local 3.10.0-229.1.2.el7.x86_64 #1 SMP Fri Mar 27 03:04:26 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
    $ cat /proc/meminfo | head -6
    MemTotal:       16243556 kB
    MemFree:          153060 kB
    MemAvailable:    7363000 kB
    Buffers:            4076 kB
    Cached:          7484732 kB
    SwapCached:        15380 kB
    $ vboxmanage --version
    4.3.26r98988
    $ vagrant --version
    Vagrant 1.7.2
    $ ansible --version
    ansible 1.9.0.1
      configured module search path = None
    $ vagrant box list
    ubuntu/trusty64 (virtualbox, 0)

My Vagrant base box 'ubuntu/trusty64' obtained from the following.
https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box

## How to use

1. Modify the following part in `ansible/group_vars/all` so that it fits your environment.(see previous picture.)

    ```
    neutron_ext_subnet_allocation_pool_start: 192.168.1.240
    neutron_ext_subnet_allocation_pool_end: 192.168.1.249
    neutron_ext_subnet_gateway: 192.168.1.1
    neutron_ext_subnet_cidr: 192.168.1.0/24
    neutron_demo_subnet_gateway: 192.168.99.1
    neutron_demo_subnet_cidr: 192.168.99.0/24
    ```

1. run `vagrant up` and `vagrant reload`
1. login to *controller* by `vagrant ssh controller`
1. Install the CirrOS by using script like this.

    ```
    vagrant@controller:~$ sudo su -
    root@controller:~# ./get-cirros-and-reg.sh
    ```

1. Create initial virtual network by using script like this.

    ```
    root@controller:~# ./create-sample-network.sh
    ```

1. Open the dashboard with the browser and login.

    ```
    http://(VirtualBox host):60080/horizon/auth/login/

    openstack_admin_password: openstack
    openstack_demo_password: openstack
    ```

## Memo

1. You can check the OpenStack components container state by `docker ps -a` like this.

    ```
    root@controller:~# docker ps -a
    CONTAINER ID        IMAGE                     COMMAND                CREATED             STATUS              PORTS               NAMES
    96454d07c559        kiyoad/cinder:latest      service_launcher.sh    37 hours ago        Up 37 hours                             cinder
    e7d06d0d0419        kiyoad/dashboard:latest   service_launcher.sh    37 hours ago        Up 37 hours                             dashboard
    0fd95c8210ce        kiyoad/neutron:latest     service_launcher.sh    37 hours ago        Up 37 hours                             neutron
    2972be5b0dbe        kiyoad/nova:latest        service_launcher.sh    37 hours ago        Up 7 hours                              nova
    80d38b54eafd        kiyoad/glance:latest      service_launcher.sh    37 hours ago        Up 37 hours                             glance
    2744d633e4c1        kiyoad/keystone:latest    service_launcher.sh    37 hours ago        Up 37 hours                             keystone
    6ab5afa8d189        rabbitmq:latest           /docker-entrypoint.s   37 hours ago        Up 37 hours                             openstack-rabbitmq
    a2bb4840abc0        mysql:latest              /entrypoint.sh mysql   37 hours ago        Up 37 hours                             openstack-mysql
    ```

1. The OpenStack components logfiles in *controller* are in the following.

    ```
    root@controller:~# ls -lR /var/log/openstack/
    /var/log/openstack/:
    total 24
    drwxrwxrwx 2 root root 4096 May  1 00:46 cinder
    drwxrwxrwx 2 root root 4096 May  1 00:44 dashboard
    drwxrwxrwx 2 root root 4096 May  1 00:40 glance
    drwxrwxrwx 2 root root 4096 May  1 00:38 keystone
    drwxrwxrwx 2 root root 4096 May  1 00:43 neutron
    drwxrwxrwx 2 root root 4096 May  1 00:42 nova

    /var/log/openstack/cinder:
    total 1404
    -rw-r--r-- 1 landscape messagebus 677635 May  2 07:15 cinder-api.log
    -rw-r--r-- 1 landscape messagebus 753819 May  2 14:34 cinder-scheduler.log

    /var/log/openstack/dashboard:
    total 180
    -rw-r--r-- 1 root root 170029 May  2 07:16 access.log
    -rw-r--r-- 1 root root   5536 May  2 07:16 error.log
    -rw-r--r-- 1 root root      0 May  1 00:44 other_vhosts_access.log

    /var/log/openstack/glance:
    total 948
    -rw-r--r-- 1 landscape messagebus 659363 May  2 07:16 api.log
    -rw-r--r-- 1 landscape messagebus 302449 May  2 07:16 registry.log

    /var/log/openstack/keystone:
    total 932
    -rw-r--r-- 1 landscape messagebus 863661 May  2 07:16 keystone-all.log
    -rw-r--r-- 1 landscape messagebus  85877 May  1 00:38 keystone-manage.log

    /var/log/openstack/neutron:
    total 34716
    -rw-r--r-- 1 landscape messagebus 35544248 May  2 14:34 server.log

    /var/log/openstack/nova:
    total 8304
    -rw-r--r-- 1 landscape messagebus 4535163 May  2 07:16 nova-api.log
    -rw-r--r-- 1 landscape messagebus  596648 May  2 14:34 nova-cert.log
    -rw-r--r-- 1 landscape messagebus 1460242 May  2 14:34 nova-conductor.log
    -rw-r--r-- 1 landscape messagebus  593042 May  2 14:34 nova-consoleauth.log
    -rw-r--r-- 1 landscape messagebus   13683 May  1 00:42 nova-manage.log
    -rw-r--r-- 1 landscape messagebus 1293589 May  2 14:34 nova-scheduler.log
    ```

1. You can login to each OpenStack components by using ssh like this.

    ```
    root@controller:~# ssh -i /opt/docker/common/maintenance_id_rsa -p 65501 maintainer@localhost # keystone
    root@controller:~# ssh -i /opt/docker/common/maintenance_id_rsa -p 65502 maintainer@localhost # glance
    root@controller:~# ssh -i /opt/docker/common/maintenance_id_rsa -p 65503 maintainer@localhost # nova
    root@controller:~# ssh -i /opt/docker/common/maintenance_id_rsa -p 65504 maintainer@localhost # neutron
    root@controller:~# ssh -i /opt/docker/common/maintenance_id_rsa -p 65505 maintainer@localhost # dashboard(horizon)
    root@controller:~# ssh -i /opt/docker/common/maintenance_id_rsa -p 65506 maintainer@localhost # cinder
    ```

    Or you can use *nsenter*(see /opt/docker/common/nse.sh).

## Bugs

1. Sometimes the dashboard doesn't work correctly when restart the *controller* node. I think that the previous Apache has not been stopped  correctly, it has failed the next boot. Wait a few minutes, perhaps the monit will restart the Apache.

