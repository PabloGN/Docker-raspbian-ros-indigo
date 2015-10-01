# This is a modified copy of GitHub/ docker_images/ros/indigo/indigo-ros-core/Dockerfile
# an auto generated Dockerfile for ros:indigo-ros-core
# generated from templates/docker_images/create_ros_core_image.Dockerfile.em
# generated on 2015-06-02 14:40:22 -0700
FROM sdhibit/rpi-raspbian 
MAINTAINER Pablo González Nalda pablo.gonzalez@ehu.eus

# setup environment
#RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN echo "deb http://archive.raspbian.org/raspbian jessie main contrib ">/etc/apt/sources.list

# setup keys
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

RUN apt-get update
# instala herramientas
RUN apt-get install  --no-install-recommends -y vim aptitude wget

# setup sources.list + keys
RUN echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list
RUN wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key --no-check-certificate
RUN apt-key add ros.key

RUN apt-get update

# install bootstrap tools
ENV ROS_DISTRO=indigo
RUN apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    && rm -rf /var/lib/apt/lists/*

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-indigo-ros-core=1.1.4-0* \
    ros-indigo-ros-base=1.1.4-0* \
    && rm -rf /var/lib/apt/lists/*

# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

