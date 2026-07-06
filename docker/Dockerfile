FROM osrf/ros:humble-desktop-full

ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=1000

ENV ROS_DISTRO=humble
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /tmp/apt-archives/partial && \
    apt-get update && \
    apt-get \
      -o Dir::Cache::archives="/tmp/apt-archives" \
      install -y --no-install-recommends \
        sudo \
        git \
        nano \
        tree \
        python3-pip \
        python3-colcon-common-extensions \
        gazebo \
        ros-humble-gazebo-ros-pkgs \
        ros-humble-gazebo-plugins \
        ros-humble-gazebo-ros2-control \
        ros-humble-ros2-control \
        ros-humble-ros2-controllers \
    && apt-get clean && \
    rm -rf \
        /var/lib/apt/lists/* \
        /tmp/apt-archives

RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

COPY docker/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

USER ${USERNAME}
WORKDIR /home/${USERNAME}/MiniTractor

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
