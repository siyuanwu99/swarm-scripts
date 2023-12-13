# How to simplify access to swarm

When connecting to a remote computer using ssh, you can simplify the process by the following hints.

## Setup `~/.ssh/config`

If it doesn't exist yet, create the file `~/.ssh/config` and add the following lines as an example.

```
# mostly used for executing commands on SMB
Host drone-148
  Hostname 192.168.101.148
  User nv

Host drone-149
  Hostname 192.168.101.149
  User nv

Host drone-150
  Hostname 192.168.101.150
  User nv
```

You may now connect as user nv to drone-148 on `192.168.101.148` by just executing `ssh drone-148`.

## SSH Public Key Authentication

This section assumes, that you haven't set up multiple key files yet.

Instead of typing the password everytime you connect to the robot, you may also copy your public ssh key to the robot.

In a nutshell, follow the steps below:

```bash
test ! -e ~/.ssh/id_rsa.pub && ssh-keygen  # generate ssh keys if they don't exist yet
ssh-copy-id nv@192.168.101.148   # adjust username and robot IP address!
```

Combined with setting up the robot in `~/.ssh/config` this allows connecting to the robot without the need to type the password.

More details can be found in the [official documentation of ssh-copy-id](https://www.ssh.com/academy/ssh/copy-id).

## Setting ROS_MASTER_URI and ROS_IP

Setting the environment variables `ROS_MASTER_URI` and `ROS_IP` properly is the best strategy to avoid any communication issues in the ROS network.

A convinient way to set the variables is to **adjust the following code to match your robot** and add it to the file `~/.bash_aliases` (or `~/.bashrc`):

```bash
alias connect-smb261='export ROS_MASTER_URI=http://10.0.1.5:11311 ;
export ROS_IP=`ip route get 10.0.1.5 | awk '"'"'{print $5; exit}'"'"'` ;
echo "ROS_MASTER_URI and ROS_IP set to " ;
printenv ROS_MASTER_URI ;
printenv ROS_IP'
```

Then (for any newly openend terminal), you can execute `connect-smb261` to set the correct environment variables for your robot.

## Test Communication Bandwidth

On the client side:

```
iperf -c <your-server-ip> -p 14555 -i 1 -t 10
```

On the server side:

```
iperf -s -p 14555 -i 1 -t 10
```
