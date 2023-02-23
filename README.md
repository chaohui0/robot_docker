# robot_docker
ros+gazebo模拟环境docker

## ubuntu18分支配置环境

Ros melodic

gazebo9

python3.8

c++8

## main分支配置环境

Ros noetic

gazebo11

python3.9

c++10


# docker 镜像生成及使用

1.在工程目录下下载所需配置文件

    wget http://packages.osrfoundation.org/gazebo.key

    wget https://repo.anaconda.com/miniconda/Miniconda3-py39_23.1.0-1-Linux-x86_64.sh

2.生成镜像

    docker build -t robot_image_name ./

3.docker container生成示例

    docker run -dti  --entrypoint='bash'  --net=host --env="DISPLAY"  -v /data/$USER:/data/workspace  --volume="/home/$USER/.Xauthority:/root/.Xauthority:rw"  --name ${USER}_container robot_image_name
