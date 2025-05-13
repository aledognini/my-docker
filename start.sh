#!/bin/bash

# Specify the container name and image
CONTAINER_NAME="zed_ros2_container"
IMAGE_NAME="zed-ros2-local-user"

# Grant permissions for GUI applications
#xhost +si:localuser:$(whoami)
xhost +si:localuser:root

# Check if the container exists
if docker ps -a | grep -q $CONTAINER_NAME; then
    echo "Container $CONTAINER_NAME exists."

    # Check if the container is running
    if [ "$(docker inspect -f {{.State.Running}} $CONTAINER_NAME)" == "true" ]; then
        echo "Container $CONTAINER_NAME is running. Stopping it now..."
        docker stop $CONTAINER_NAME
        docker rm $CONTAINER_NAME
    else
        echo "Container $CONTAINER_NAME is not running."
        docker rm $CONTAINER_NAME
    fi
else
    echo "Container $CONTAINER_NAME does not exist."
fi

# Ensure the local folder exist
mkdir -p "$(pwd)/data"
mkdir -p "$(pwd)/ROS2_ws"


docker run -it \
    --gpus all \
    --runtime nvidia \
    --privileged \
    --network=host \
    --ipc=host \
    --pid=host \
    --env="NVIDIA_DRIVER_CAPABILITIES=all" \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="/tmp:/tmp" \
    --volume="/dev:/dev" \
    --volume="$(pwd)/data:/home/zeduser/data" \
    --volume="$(pwd)/ROS2_ws:/home/zeduser/ROS2_ws" \
    --volume="/usr/local/zed/resources:/usr/local/zed/resources" \
    --volume="/usr/local/zed/settings:/usr/local/zed/settings" \
    --volume="/var/nvidia/nvcam/settings:/var/nvidia/nvcam/settings" \
    --volume="/etc/systemd/system/zed_x_daemon.service:/etc/systemd/system/zed_x_daemon.service" \
    --name $CONTAINER_NAME \
    -w /home/zeduser \
    $IMAGE_NAME 
