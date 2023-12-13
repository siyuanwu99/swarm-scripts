#!/usr/bin/sh

# install Livox SDK
install_livox_sdk() {
	[ -d /tmp/livox_sdk ] && rm -r /tmp/livox_sdk
	git clone https://github.com/Livox-SDK/Livox-SDK.git /tmp/livox_sdk
	cd /tmp/livox_sdk/ || exit
	[ ! -d build ] && mkdir build
	cd build && cmake ..
	make -j4
	sudo make install
}

# install Livox SDK2
install_livox_sdk2() {
	[ -d /tmp/livox_sdk2 ] && rm -r /tmp/livox_sdk2
	git clone https://github.com/Livox-SDK/Livox-SDK2.git /tmp/livox_sdk2
	cd /tmp/livox_sdk2/ || exit
	[ ! -d build ] && mkdir build
	cd build && cmake ..
	make -j4
	sudo make install
}

[ ! -f /usr/local/lib/liblivox_sdk_static.a ] && install_livox_sdk
[ ! -f /usr/local/lib/liblivox_lidar_sdk_static.a ] && install_livox_sdk2
