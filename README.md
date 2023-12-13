# swarm-dotfiles

Dotfiles for swarm installation and configuration

## Installation

Clone this repository, and copy the dotfiles to your home directory.

```bash
git clone git@github.com:SYSU-STAR/swarm-dotfiles.git
cd swarm-dotfiles
./install.sh
```

Under `.ssh` directory, you can find the ssh keys for swarm project.
You may replace them with your own keys. Remember to add your public key to GitHub.
Note please check the permissions of the private key file, it should be `0600`.

## Usage

1. You may install racer to NVIDIA Jetson using the following command:

   ```bash
   ./install_racer.sh
   ```

   It will automatically install racer and its dependencies at `~/swarm_exploration_project`.

2. You can set the current IP address to static by running the following command:

   ```bash
   ./set_static_ip.sh
   ```

   > DEBUG: This is not stable now, use it at your own risk.

3. You may install AprilTag dependencies by calling this command:
   ```bash
   ./install_apriltag.sh
   ```
   It will also automatically update the detection configurations.

## TMUX configs

If you're new to tmux, I would recommend you to read the [instructions](https://github.com/gpakosz/.tmux#bindings) for basic keybindings.

Please modify the `~/.tmux.conf.local` file to change the theme and key bindings.

For example, if you want to use the light theme with white background, you may need to modify following options to

```
tmux_conf_theme_window_fg="$tmux_conf_theme_colour_1"
tmux_conf_theme_focused_pane_bg="$tmux_conf_theme_colour_17"
```

### KeybindingsBindings

tmux may be controlled from an attached client by using a key combination of a
prefix key, followed by a command key. This configuration uses `C-a` as a
secondary prefix while keeping `C-b` as the default prefix. In the following
list of key bindings:

- `<prefix>` means you have to either hit <kbd>Ctrl</kbd> + <kbd>a</kbd> or <kbd>Ctrl</kbd> + <kbd>b</kbd>
- `<prefix> c` means you have to hit <kbd>Ctrl</kbd> + <kbd>a</kbd> or <kbd>Ctrl</kbd> + <kbd>b</kbd> followed by <kbd>c</kbd>
- `<prefix> C-c` means you have to hit <kbd>Ctrl</kbd> + <kbd>a</kbd> or <kbd>Ctrl</kbd> + <kbd>b</kbd> followed by <kbd>Ctrl</kbd> + <kbd>c</kbd>

This configuration uses the following bindings:

- `<prefix> e` opens the `.local` customization file copy with the editor
  defined by the `$EDITOR` environment variable (defaults to `vim` when empty)
- `<prefix> r` reloads the configuration
- `C-l` clears both the screen and the tmux history

- `<prefix> C-c` creates a new session
- `<prefix> C-f` lets you switch to another session by name

- `<prefix> C-h` and `<prefix> C-l` let you navigate windows (default
  `<prefix> n` and `<prefix> p` are unbound)
- `<prefix> Tab` brings you to the last active window

- `<prefix> -` splits the current pane vertically
- `<prefix> _` splits the current pane horizontally
- `<prefix> h`, `<prefix> j`, `<prefix> k` and `<prefix> l` let you navigate
  panes ala Vim
- `<prefix> H`, `<prefix> J`, `<prefix> K`, `<prefix> L` let you resize panes
- `<prefix> <` and `<prefix> >` let you swap panes
- `<prefix> +` maximizes the current pane to a new window

- `<prefix> m` toggles mouse mode on or off

- `<prefix> U` launches Urlview (if available)
- `<prefix> F` launches Facebook PathPicker (if available)

- `<prefix> Enter` enters copy-mode
- `<prefix> b` lists the paste-buffers
- `<prefix> p` pastes from the top paste-buffer
- `<prefix> P` lets you choose the paste-buffer to paste from

## VINS

`./vins` contains paramsters for VINS-Fusion calibrated on ZJU-FAST-Tiny drone.
Please copy `left.yaml`, `right.yaml` and `stereo_imu_config.yaml` to the `configs` folder of your VINS workspace, and use `vins.launch` to apply these parameters.

## Shell Scripts

#### Install

1. `install.sh` is used to install the basic tools and dependencies for swarm project.
2. `install_racer.sh` is used to install racer and its dependencies to `~/star_exploration_ws/` directory.
3. `install_apriltag.sh` is used to install apriltag and its dependencies to `~/star_exploration_ws/src/` directory.
4. `install_ego_swarm.sh` is used to install ego-swarm and its dependencies to `~/ego_swarm_ws/` directory.
