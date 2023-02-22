# robot_docker
ros+gazebo模拟环境docker
主要软件配置

Ros melodic

gazebo9

python3.8

c++11


## docker container生成命令示例
docker run -dti  --entrypoint='bash'  --net=host --env="DISPLAY"  -v /data/$USER:/data/workspace  --volume="/home/$USER/.Xauthority:/root/.Xauthority:rw"  --name ${USER}_container robot_image
