#!/bin/bash
ROBOT_NAME="swarm152"
PASSWD="nv"

# Sync Time
echo "$PASSWD" | sudo -S ntpdate -u cn.pool.ntp.org

# Start Project Sessions
tmux new-session -d -s $ROBOT_NAME
tmux split-window -h -p 50
tmux select-pane -t 1
tmux split-window -v -p 75
tmux select-pane -t 3
tmux split-window -v -p 80
tmux split-window -v -p 80
tmux split-window -v -p 80
tmux split-window -v -p 80
tmux split-window -v -p 80
tmux split-window -v -p 80

for pane in {1..9}; do
	tmux send-keys -t $ROBOT_NAME:1.$pane 'cd ~/star_exploration_ws && source setup.bash' C-m
done

tmux send-keys -t $ROBOT_NAME:1.3 'roscore' C-m
echo "[$ROBOT_NAME] roscore started."
tmux send-keys -t $ROBOT_NAME:1.4 'sleep 1 && mav' C-m
tmux send-keys -t $ROBOT_NAME:1.5 'sleep 4 && bridge' C-m
tmux send-keys -t $ROBOT_NAME:1.6 'sleep 5 && roslaunch realsense2_camera rs_camera.launch' C-m
tmux send-keys -t $ROBOT_NAME:1.7 'sleep 18 && gvio' C-m

echo "[$ROBOT_NAME] Initialized."
exit
