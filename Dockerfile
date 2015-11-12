# This is a modified copy of GitHub/ docker_images/ros/indigo/indigo-ros-core/Dockerfile
# an auto generated Dockerfile for ros:indigo-ros-core
# generated from templates/docker_images/create_ros_core_image.Dockerfile.em
# generated on 2015-06-02 14:40:22 -0700

FROM sdhibit/rpi-raspbian 
MAINTAINER Pablo González Nalda pablo.gonzalez@ehu.eus

USER root

RUN cd /root && \
	echo "deb http://archive.raspbian.org/raspbian jessie main contrib firmware non-free rpi ">/etc/apt/sources.list && \
	apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116 && \
	echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list && \
	apt-get update && \
	apt-get install --no-install-recommends -y \
	vim aptitude wget sudo ca-certificates openssl locales locales-all g++ vlc-nox &&  \
        wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key --no-check-certificate && \
        apt-key add ros.key && \
	apt-get install --no-install-recommends -y \
	python-rosdep \
	python-rosinstall \
	python-vcstools && \
	rm -rf /var/lib/apt/lists/*
	
RUN useradd pi && echo 'pi:hypriot' | chpasswd
RUN echo "pi ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN mkdir -p /home/pi && chown pi:pi /home/pi

USER pi

# setup environment
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 ROS_DISTRO=indigo

# bootstrap rosdep
RUN sudo rosdep init
RUN rosdep update

# install ros packages
RUN sudo apt-get update && sudo apt-get install -y \
    ros-indigo-ros-core=1.1.4-0* \
    ros-indigo-ros-base=1.1.4-0* \
    && sudo rm -rf /var/lib/apt/lists/*

RUN sudo ln -s /usr/lib/arm-linux-gnueabihf/liblog4cxx.so /usr/lib/

# setup entrypoint
WORKDIR /home/pi/
COPY ./rep.sh rep.sh
RUN chown pi:pi rep.sh
ENTRYPOINT ["./rep.sh"]
CMD ["/bin/bash"]

USER pi
