#/bin/zsh
DRONE_ID=$(hostname -I | cut -d " " -f1 | rev | cut -d "." -f1 | rev)  ## bug on lidar drone

alias vio="roslaunch vins vins.launch"
alias mav="echo nv | sudo -S chmod 777 /dev/ttyTHS*;
(sleep 10;
rosrun mavros mavcmd long 511 105 5000 0 0 0 0 0;
rosrun mavros mavcmd long 511 31 5000 0 0 0 0 0;
timeout 5s rostopic hz /mavros/imu/data;) & 
roslaunch mavros px4.launch fcu_url:=/dev/ttyTHS0:921600; "
alias mav_udp="echo nv | sudo -S chmod 777 /dev/ttyTHS*;
(sleep 10;
rosrun mavros mavcmd long 511 105 5000 0 0 0 0 0;
rosrun mavros mavcmd long 511 31 5000 0 0 0 0 0;
timeout 5s rostopic hz /mavros/imu/data;) & 
roslaunch mavros px4.launch fcu_url:=/dev/ttyTHS0:921600 gcs_url:=udp-b://@; "

alias cam="roslaunch realsense2_camera rs_camera.launch"
alias imu="rosrun mavros mavcmd long 511 105 5000 0 0 0 0 0;
rosrun mavros mavcmd long 511 31 5000 0 0 0 0 0;
timeout 5s rostopic hz /mavros/imu/data"
alias lio="roslaunch fast_lio my_mapping_mid360.launch"
alias ekf="roslaunch ekf fast_lio_and_imu.launch"

alias bridge_hitl="roslaunch swarm_ros_bridge onboard_bridge.launch config:=swarm_hitl_drone.yaml"
alias bridge="roslaunch swarm_ros_bridge onboard_bridge.launch config:=swarm_drone.yaml"


alias set_master="export ROS_MASTER_URI=http://\$(hostname -I | cut -d\" \" -f1):11311;
export ROS_IP=\$(hostname -I | cut -d\" \" -f1);
echo  \"ROS_MASTER_URI set to \$ROS_MASTER_URI\"; 
echo  \"ROS_IP set to \$ROS_IP\"; "
alias set_back="export ROS_MASTER_URI=http://localhost:11311;
export ROS_IP=127.0.0.1
echo  \"ROS_MASTER_URI set to \$ROS_MASTER_URI\"; 
echo  \"ROS_IP set to \$ROS_IP\"; "

alias run_in_sim="roslaunch exploration_manager run_in_sim.launch drone_id:=2 drone_num:=5"
alias run_onboard="roslaunch exploration_manager run_onboard.launch drone_id:=3 drone_num:=4"

alias tag="roslaunch swarm_apriltag_initializer apriltag.launch"
alias cali_tag="roslaunch swarm_apriltag_initializer apriltag.launch is_calibrated:=False"
alias gvio="roslaunch swarm_apriltag_initializer vins.launch"

alias net_bw="sudo iftop -i wlan0"

alias px4_ctrl="roslaunch px4ctrl run_ctrl.launch"

alias takeoff="rostopic pub -1  /px4ctrl/takeoff_land quadrotor_msgs/TakeoffLand \"takeoff_land_cmd: 1\""
alias land="rostopic pub -1  /px4ctrl/takeoff_land quadrotor_msgs/TakeoffLand \"takeoff_land_cmd: 2\""

source devel/setup.zsh
# set_master
