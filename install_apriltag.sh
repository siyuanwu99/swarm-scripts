#!/bin/sh

WORKSPACE="$HOME/star_exploration_ws"
WORKSPACE_SRC="$WORKSPACE/src"

# install Apriltag
install_apriltag(){
    if [ ! -d /usr/local/include/apriltag ] 
    then
        git clone git@github.com:AprilRobotics/apriltag.git /tmp/apriltag
        cd /tmp/apriltag
        [ ! -d /tmp/apriltag/build ] && mkdir build
        cd build && cmake .. && make -j4
        sudo make install
    fi


    [ ! -d $WORKSPACE_SRC/apriltag_ros ] && \ 
        git clone git@github.com:AprilRobotics/apriltag_ros.git $WORKSPACE_SRC/apriltag_ros
    cd $WORKSPACE
    catkin_make

}

update_configs() {
    # Define the path to your launch file
    LAUNCH_FILE="$WORKSPACE/src/apriltag_ros/apriltag_ros/launch/continuous_detection.launch"
    TAGS_FILE="$WORKSPACE/src/apriltag_ros/apriltag_ros/config/tags.yaml"

    # Check if the file exists
    if [ ! -f "$LAUNCH_FILE" ]; then
        echo "Error: Launch file not found!"
        exit 1
    fi

    # Modify camera_name and image_topic
    sed -i 's#<arg name="camera_name" default="[^"]*" />#<arg name="camera_name" default="/camera/infra1" />#g' "$LAUNCH_FILE"
    sed -i 's#<arg name="image_topic" default="[^"]*" />#<arg name="image_topic" default="/image_rect_raw" />#g' "$LAUNCH_FILE"


    # Check if the file exists
    if [ ! -f "$TAGS_FILE" ]; then
        echo "Error: tags.yaml file not found!"
        exit 1
    fi

    # Insert tag data into standalone_tags section

    # declare -a tags=(
    #     "{id: 1, size: 0.3, name: Tag1},"
    #     "{id: 2, size: 0.3, name: Tag2},"
    # )

    # for tag in "${tags[@]}"; do
    #     sed -i "/standalone_tags:/,/]/ { /]/i \ \ \ \${tag}\n" "$TAGS_FILE"; } 
    # done
    echo "standalone_tags:
  - id: 0
    size: 0.100
    name: Tag0
  - id: 5
    size: 0.100
    name: Tag5
  " > "$TAGS_FILE"

    echo "File updated successfully!"

}


# sudo apt-get update 
# install_apriltag
update_configs
