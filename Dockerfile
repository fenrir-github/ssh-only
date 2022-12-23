# fenrir/ssh-only
# Debian buster-slim+ssh
#
# VERSION 11.6.0
#
FROM debian:bullseye-slim
MAINTAINER Fenrir <dont@want.spam>

ENV	DEBIAN_FRONTEND noninteractive

# Configure APT
RUN	echo 'APT::Install-Suggests "false";' > /etc/apt/apt.conf &&\
	echo 'APT::Install-Recommends "false";' >> /etc/apt/apt.conf &&\
	echo 'Aptitude::Recommends-Important "false";' >> /etc/apt/apt.conf &&\
	echo 'Aptitude::Suggests-Important "false";' >> /etc/apt/apt.conf &&\
# Install packages
	apt-get update && apt-get install -y -q ssh &&\
# Cleanning
	apt-get autoclean &&\
	apt-get clean &&\
	rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /tmp/* /var/tmp/*

# Configure ssh
RUN mkdir /var/run/sshd &&\
	echo 'root:password' | chpasswd &&\
	sed -e '/PermitRootLogin/ s/^#*/#/' -i /etc/ssh/sshd_config &&\
	echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config &&\
	rm /etc/ssh/ssh_host_*_key.pub 

# Start ssh server
CMD ["/usr/sbin/sshd", "-D"]

# Expose port
EXPOSE 22
