# Set CPU frequency to maximum
sudo echo "***** Set CPU frequency to maximum *****"
sudo echo "- Previous frequency of cores"
sudo cat /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq
sudo echo "- Previous CPU governor of cores"
sudo cat /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
sudo echo

sudo echo "- The list of available frequencies: 0123"
sudo cat /sys/devices/system/cpu/cpufreq/policy0/scaling_available_frequencies
sudo echo performance > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
sudo echo 1984000 > /sys/devices/system/cpu/cpufreq/policy0/scaling_setspeed
sudo echo 115200 > /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq
sudo echo 1984000 > /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq


sudo echo "- The list of available frequencies:4567"
sudo cat /sys/devices/system/cpu/cpufreq/policy4/scaling_available_frequencies
sudo echo performance > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor
sudo echo 1984000 > /sys/devices/system/cpu/cpufreq/policy4/scaling_setspeed
sudo echo 115200 > /sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq
sudo echo 1984000 > /sys/devices/system/cpu/cpufreq/policy4/scaling_max_freq

sudo echo
sudo echo "- Changed frequency of cores:0123"
sudo cat /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq
sudo echo "- Changed CPU governor of cores"
sudo cat /sys/devices/system/cpu/cpufreq/policy0/scaling_governor


sudo echo
sudo echo "- Changed frequency of cores:4567"
sudo cat /sys/devices/system/cpu/cpufreq/policy4/scaling_cur_freq
sudo echo "- Changed CPU governor of cores"
sudo cat /sys/devices/system/cpu/cpufreq/policy4/scaling_governor

