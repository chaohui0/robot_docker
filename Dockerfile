FROM ubuntu:20.04

RUN apt update
RUN apt install -y gcc-10 g++-10
# 安装miniconda

#wget https://repo.anaconda.com/miniconda/Miniconda3-py39_23.1.0-1-Linux-x86_64.sh
COPY Miniconda3-py39_23.1.0-1-Linux-x86_64.sh .
RUN /bin/bash Miniconda3-py39_23.1.0-1-Linux-x86_64.sh -b && rm Miniconda3-py39_23.1.0-1-Linux-x86_64.sh
ENV PATH=/root/miniconda3/bin:${PATH}

RUN apt-get install -y lsb-release gnupg2 curl && apt-get clean all
# 安装cuda
#wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
COPY cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
#wget https://developer.download.nvidia.com/compute/cuda/11.4.0/local_installers/cuda-repo-ubuntu2004-11-4-local_11.4.0-470.42.01-1_amd64.deb
COPY cuda-repo-ubuntu2004-11-4-local_11.4.0-470.42.01-1_amd64.deb .
RUN  dpkg -i cuda-repo-ubuntu2004-11-4-local_11.4.0-470.42.01-1_amd64.deb
RUN  apt-key add /var/cuda-repo-ubuntu2004-11-4-local/7fa2af80.pub
RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install cuda && rm cuda-repo-ubuntu2004-11-4-local_11.4.0-470.42.01-1_amd64.deb

COPY cudnn-local-repo-ubuntu2004-8.8.0.121_1.0-1_amd64.deb .
RUN dpkg -i cudnn-local-repo-ubuntu2004-8.8.0.121_1.0-1_amd64.deb && rm cudnn-local-repo-ubuntu2004-8.8.0.121_1.0-1_amd64.deb

RUN conda install pytorch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1 cudatoolkit=11.3 -c pytorch

COPY requirement.txt .
RUN pip install -i https://mirrors.aliyun.com/pypi/simple/ --no-cache-dir -r requirement.txt
RUN pip install h5py matplotlib numpy pyside2
RUN apt-get install -y cmake vim libhdf5-dev libxcb-xinerama0
RUN sh -c '/bin/echo -e "70" |/bin/echo -e "6"  | /bin/echo -e "y" | apt-get install python3-h5py'

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 100

RUN conda install -y libstdcxx-ng
ENV LD_LIBRARY_PATH=/root/miniconda3/pkgs/libstdcxx-ng-11.2.0-h1234567_1/lib/:${LD_LIBRARY_PATH}

RUN apt-get install ffmpeg libsm6 libxext6 libgl1 -y

RUN ln -s /usr/lib/x86_64-linux-gnu/hdf5/serial/libhdf5.so /usr/lib/x86_64-linux-gnu/libhdf5.so.200 && ln -s /usr/lib/x86_64-linux-gnu/hdf5/serial/libhdf5_cpp.so /usr/lib/x86_64-linux-gnu/libhdf5_cpp.so.200

# 安装ros
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN apt update

RUN sh -c '/bin/echo -e "6"  | apt-get install -y ros-noetic-desktop-full'
RUN apt install -y  rospack-tools
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
#RUN sh -c 'source ~/.bashrc'
RUN apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
RUN rosdep init && rosdep update

# 安装gazebo11
# 设置镜像
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
# 设置Key
#wget http://packages.osrfoundation.org/gazebo.key
COPY gazebo.key .
RUN apt-key add gazebo.key
# 安装gazebo
RUN apt update &&  apt install -y gazebo11 libgazebo11-dev
RUN conda install -c conda-forge rospkg empy
RUN pip install defusedxml
RUN pip install tensorflow tensorboard


ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV LANG=C.UTF-8
ENV MPLBACKEND="TkAgg"
