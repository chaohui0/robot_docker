FROM ubuntu:18.04

RUN apt update
RUN apt install -y gcc-8 g++-8 wget
# 安装miniconda
#wget https://repo.anaconda.com/miniconda/Miniconda3-py38_23.1.0-1-Linux-x86_64.sh
COPY Miniconda3-py38_23.1.0-1-Linux-x86_64.sh .
RUN /bin/bash Miniconda3-py38_23.1.0-1-Linux-x86_64.sh -b && rm Miniconda3-py38_23.1.0-1-Linux-x86_64.sh
ENV PATH=/root/miniconda3/bin:${PATH}

#COPY requirement.txt .
#RUN pip install -r requirement.txt
#RUN pip install h5py matplotlib numpy pyside2
RUN apt-get install -y cmake vim

#RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100 && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100

RUN conda install -y libstdcxx-ng
ENV LD_LIBRARY_PATH=/root/miniconda3/pkgs/libstdcxx-ng-11.2.0-h1234567_1/lib/:${LD_LIBRARY_PATH}

RUN apt-get install -y lsb-release gnupg2 && apt-get clean all

RUN sh -c '. /etc/lsb-release && echo "deb http://mirrors.ustc.edu.cn/ros/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt update
ENV DEBIAN_FRONTEND=noninteractive

RUN sh -c '/bin/echo -e "6"  | apt-get install -y ros-melodic-desktop-full'
RUN apt install -y  rospack-tools
RUN rosdep init && rosdep update
RUN apt-get install -y  python-rosinstall python-rosinstall-generator python-wstool build-essential

RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
# wget http://packages.osrfoundation.org/gazebo.key
COPY gazebo.key .
RUN apt-key add gazebo.key
RUN apt update && apt install -y gazebo9 libgazebo9-dev
RUN apt upgrade -y libignition-math2

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV LANG=C.UTF-8
ENV MPLBACKEND="TkAgg"
