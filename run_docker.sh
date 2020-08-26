#!/usr/bin/env bash

until docker ps
do
    echo "Waiting for docker server"
    sleep 1
done


# Make sure processes in the container can connect to the x server
# Necessary so rviz can create a context for OpenGL rendering
XAUTH=/home/nqrobot/.docker.xauth #input your path
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    if [ ! -z "$xauth_list" ]
    then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

# nvidia-docker run -it \
#   -e DISPLAY=$DISPLAY \
#   -e QT_X11_NO_MITSHM=1 \
#   -e XAUTHORITY=$XAUTH \
#   -v "$XAUTH:$XAUTH" \
#   -v "/tmp/.X11-unix:/tmp/.X11-unix" \
#   -v "/etc/localtime:/etc/localtime:ro" \
#   -v "/dev/input:/dev/input" \
#   --privileged \
#   --rm=true \
#   --net=host \
#   hyye/lio
docker run -it \
    -e DISPLAY=$DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -e XAUTHORITY=$XAUTH \
    -v "$XAUTH:$XAUTH" \
    --user=$USER \
    --volume="/home/nqrobot/hejie_document/docker_file/ros1:/home/nqrobot/" \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --privileged \
    --rm=false \
    --net=host \
    hejie/slam:latest  \  #input your images
    /bin/bash   # you can use -c + "" to run some init bash
