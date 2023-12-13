#!/bin/zsh

# Start a new tmux session in detached mode
tmux new-session -d

# Split the window vertically 
tmux split-window -h -p 50

# Split both panes horizontally 
tmux select-pane -t 1
tmux split-window -v -p 75
tmux select-pane -t 3
tmux split-window -v -p 80
tmux split-window -v -p 80
tmux split-window -v -p 80

# Change directory to ~/workspace for each pane
	for pane in {1..6}; do
    tmux send-keys -t $pane 'cd ~/star_exploration_ws && source setup.zsh' C-m
done

tmux send-keys -t 3 'jtop' C-m



# Attach to the tmux session
tmux attach

