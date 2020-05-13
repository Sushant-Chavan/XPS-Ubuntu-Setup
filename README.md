# XPS-Ubuntu16-04-Setup
This repository contains the instructions for installing Ubuntu-16.04 on a fresh XPS-15 (7590). It includes instructions to install several tools and packages that I require for my work with ROS-Kinetic, Tensorflow(&lt;=1.12) and PyTorch(1.15)

# Finalized Setup Steps:

## Install the necessary Windows and Dell updates.

* You can do this by going to Settings > Updates & Security > Check For Updates.

## Shrink Windows Partition

* Type “Create and Format Hard Disk Partitions” in the Windows Search Bar.
* Right click on the largest partition and click “Shrink Volume”.
* Choose the desired size for Ubuntu
* See the newly created “Unallocated space” in the partition diagram.

## Switch from RAID to AHCI Mode

* Disable BitLocker (required for disabling secure boot later)
    * Search for something like "Encrypt device" in the start menu and then turn it OFF.
* Type “cmd” into the Windows Search Bar, then click “Run as administrator”
* Enter command `bcdedit /set {current} safeboot minimal`. If that doesn't work try `bcdedit /set safeboot minimal`
* Restart the computer and enter the BIOS Setup using F2 key repeatedly.
* Under System Configuration, change the SATA Operation mode from RAID to AHCI.
* Also Disable SecureBoot from the BIOS (required for setting up WIFI drivers later). This does not work without disabling BitLocker First
* Save changes and try to boot into Windows. It will automatically boot to Safe Mode.
* Type “cmd” into the Windows Search Bar, then click “Run as administrator”.
* If the in the second step the first command had worked, use the command `bcdedit /deletevalue {current} safeboot`, else use the command `bcdedit /deletevalue safeboot`
* Reboot once more and Windows will automatically start with AHCI drivers enabled.
* If this worked, you should be able to search “Device Manager” in the Windows Search Bar, then see IDE ATA/ATAPI Controllers > Intel(R) 300 Series Chipset Family SATA AHCI Controller.

## Install Ubuntu

* Create a Ubuntu USB drive. Check this [guide](https://itsfoss.com/create-live-usb-of-ubuntu-in-windows/)
* Boot into USB using the Boot options at restart, using the key F12
* Complete installation instructions. I also installed updates and 3rd party libs during the installation (requires LAN cable or USB tether from a phone).
* I followed the installation instructions from [here](https://itsfoss.com/install-ubuntu-1404-dual-boot-mode-windows-8-81-uefi/)
* If there are issues during installations checkout some troubleshooting steps mentioned in the *Install Ubuntu 18.04* section on the [webpage](https://medium.com/@tylergwlum/my-journey-installing-ubuntu-18-04-on-the-dell-xps-15-7590-2019-756f738a6447)

## Install Terminator

* Execute the below commands:
    ```
    sudo add-apt-repository ppa:gnome-terminator
    sudo apt update
    sudo apt install -y terminator curl
    ```
* Change the color of the prompt in bashrc
* Activate infinite scrolling and disable scroll on output in  terminator preferences


## Upgrade all packages

* After installation, connect a LAN cable or USB tether from a phone and upgrade all the packages using:
    ```
    sudo apt update
    sudo apt upgrade
    reboot
    ```

## Setup Killer Wifi and Bluetooth Drivers:

### Tested steps that work

* Install the Backported Iwlwifi Driver using APT
    ```
    sudo add-apt-repository ppa:canonical-hwe-team/backport-iwlwifi
    sudo apt-get update
    sudo apt-get install -y backport-iwlwifi-dkms
    reboot
    ```
* Upgrade the ubuntu version firmware as described [here](https://ubuntuforums.org/showthread.php?t=2423019)
    * First go to this [link](http://archive.ubuntu.com/ubuntu/pool/main/l/linux-firmware/?)
    * Find the latest firmware in the list (example: linux-firmware_1.187_all.deb) and download it
    * Install the downloaded firmware (eg: sudo apt install ./linux-firmware_1.187_all.deb)
    * Reboot the system
* The two steps previous steps should ideally get WIFI and Bluetooth up and running. If that is not the case try the alternative steps described in the next section.
* **If the Bluetooth adapter stops working out of the blue:**
    * Check if the bluetooth adapter is listed when using the `list` command inside `bluetoothctl`
    * If no adapter is found, Try the following:
        * Turn OFF the Bluetooth from the BIOS->Wireless (both sub menus). Save and restart the system
        * As expected, there wont be a bluetooth adapter shown
        * Then restart system, and Turn ON Bluetoooth from the BIOS->Wireless (both sub menus). Save and restart the system
        * The Bluetooth device should now be shown.
        * `bluetoothctl` should also list the adpater now.

### Alternative methods if the previous did not work

* These instructions are taken from [Killers website](https://support.killernetworking.com/knowledge-base/killer-ax1650-in-debian-ubuntu-16-04/)

* Execute the following commands
    ```
    sudo apt-get install -y git
    sudo apt-get install -y build-essential
    cd ~
    git clone https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/backport-iwlwifi.git
    cd backport-iwlwifi
    make defconfig-iwlwifi-public
    make -j4
    sudo make install

    sudo git clone git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
    cd linux-firmware
    sudo cp iwlwifi-* /lib/firmware/
    reboot
    ```
* If the Wifi still doesn't work or the PC just freezes, then uninstall the backport drivers (may require booting in recovery mode without networking) using the following commands and restart system.
    ```
    cd ~/backport-iwlwifi
    sudo make uninstall
    reboot
    ```
    * Then follow the steps described previously in the section **Tested steps that work**

## Fix Suspend issue 

* Execute below commands, taken from [here](https://github.com/MuDiAhmed/Ubuntu-Dell-XPS-15-2019/blob/a3ec36c043287461e9f3f507d71123c573dab7dd/Makefile#L30):
    ```
    sudo echo deep | sudo tee /sys/power/mem_sleep
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& mem_sleep_default=deep/' /etc/default/grub
    sudo update-grub
    ```

## Install NVidia Drivers
* Use below commands:
    ```
    sudo add-apt-repository ppa:graphics-drivers/ppa
    sudo apt update
    sudo apt install -y nvidia-430 nvidia-settings
    ```

## Install Cuda-9.2 and related Nvidia drivers (setup decides the driver version automatically) 

* Inspired from [here](https://docs.nvidia.com/cuda/archive/9.2/cuda-installation-guide-linux/index.html). Below is the set of actually needed commands:
    ```
    sudo apt-get install -y linux-headers-$(uname -r)
    ** Download the Cuda toolkit (Base Installer) from [here](https://developer.nvidia.com/cuda-92-download-archive) **
    sudo dpkg -i cuda-repo-<distro>_<version>_<architecture>.deb
    sudo apt-key add /var/cuda-repo-<version>/7fa2af80.pub
    sudo apt-get update
    sudo apt-get install -y cuda-9-2
    **Add this line  to the bashrc: export PATH=/usr/local/cuda-9.2/bin${PATH:+:${PATH}}**
    reboot
    ```
* The above step at the time of writing installed Driver Version: 440.64.00 with CUDA Version: 10.2. That is alright since it will use a runtime version of 9.2. This is the output of nvidia-smi command:
    ```
        +-----------------------------------------------------------------------------+
        | NVIDIA-SMI 440.64.00    Driver Version: 440.64.00    CUDA Version: 10.2     |
        |-------------------------------+----------------------+----------------------+
        | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
        | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
        |===============================+======================+======================|
        |   0  GeForce GTX 1650    Off  | 00000000:01:00.0 Off |                  N/A |
        | N/A   50C    P8     1W /  N/A |    390MiB /  3914MiB |      6%      Default |
        +-------------------------------+----------------------+----------------------+
    ```

## Python3 (and 3.6) setup

* Execute the below commands:
    ```
    sudo add-apt-repository ppa:deadsnakes/ppa
    sudo apt update
    sudo apt install -y python3.6
    python3.6 --version
    # sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.5 1
    # sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 2
    # ** Choose 0 when this command asks for input (i.e. python3.6 --auto)** sudo update-alternatives --config python3
    python3 --version
    sudo apt update
    sudo apt install -y python3-pip
    pip3 --version
    sudo pip3 install --upgrade pip
    pip3 --version
    sudo pip install --upgrade virtualenv # pip instead of pip3 is deliberate 
    sudo pip3 install --upgrade jupyter numpy matplotlib sympy scipy pandas seaborn scikit-learn networkx
    ```

## Create a Python 3.6 virtual environment (requires Python 3.6 to be installed beforehand as described previously)

* Create a virtual env with `some_name`
    ```
    cd ~
    virtualenv --system-site-packages -p python3.6 ./SOME_UNIQUE_V_ENV_NAME
    source ./SOME_UNIQUE_V_ENV_NAME/bin/activate
    python --version
    pip install --upgrade pip
    pip --version
    ```
* Install required packages like jupyter etc using the `-I` (i.e. ignore already installed packages in the root) flag of pip. For example:
    ```
    pip install -I jupyter
    ```
* **Optional:** Add this python kernel (from the virtual env) to Jupyter
    ```
    python -m ipykernel install --user --name=SOME_GOOD_KERNEL_NAME
    ```
* Deactivate the virtual env
    ```
    deactivate
    ```


## Install TensorFlow 1.12

* Install Cuda-9.2 if not already installed.
* Activate python 3.6 virtual env
    ```
    cd ~
    source ./SOME_UNIQUE_V_ENV_NAME/bin/activate
    ```
* Install TF
    ```
    pip install --upgrade tensorflow-gpu==1.12
    ```
* Verify if TF is using GPU with the command:
    ```
    python -c "import tensorflow as tf;print('\nDefault GPU Device: {}'.format(tf.test.gpu_device_name()));print('\nGPU Available:', tf.test.is_gpu_available());print('\nBuilt with Cuda: ', tf.test.is_built_with_cuda())"
    ```
* Additional Guides can be referred here:
    * [Multi-Cuda Guide](https://medium.com/@peterjussi/multicuda-multiple-versions-of-cuda-on-one-machine-4b6ccda6faae) for installing multiple versions of TensorFlow
    * Check the required Cuda and CuDNN versions for a specific Tensorflow version from [here](https://www.tensorflow.org/install/source#linux)


## Install PyTorch version 1.5:

* Install Cuda-9.2 if not already installed.
* Activate python 3.6 virtual env
    ```
    cd ~
    source ./SOME_UNIQUE_V_ENV_NAME/bin/activate
    ```
* Install PyTorch using the command:
    ```
    pip install torch==1.5.0+cu92 torchvision==0.6.0+cu92 -f https://download.pytorch.org/whl/torch_stable.html
    ```
* Verify installation using the below command. The output should be a tensor
    ```
    python -c "from __future__ import print_function;import torch;x = torch.rand(5, 3);print(x)"
    ```
* Verify if GPU driver and CUDA is enabled and accessible by PyTorch:
    ```
    python -c "import torch;print('Is GPU and CUDA Available? :', torch.cuda.is_available())"
    ```

## Install ROS

* Update ROS Keys
    ```
    sudo sh -c "echo \"deb http://packages.ros.org/ros/ubuntu xenial main\" > /etc/apt/sources.list.d/ros-latest.list"
    sudo curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | sudo apt-key add - 
    sudo apt-key adv --keyserver keys.gnupg.net --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
    ```
* Install ROS binaries
    ```
    sudo apt-get update
    sudo apt-get install -y ros-kinetic-desktop-full
    ```
* Install ROS dependencies
    ```
    sudo rm -rf /etc/ros/rosdep/sources.list.d/*
    sudo rosdep init
    rosdep update
    sudo apt install -y python-rosinstall python-rosinstall-generator python-wstool build-essential python-catkin-tools python-pip
    sudo pip install catkin_pkg empy
    sudo rm -rf /var/lib/apt/lists/*
    source /opt/ros/kinetic/setup.bash
    ```
* Create and build a catkin workspace
    ```
    mkdir -p ~/catkin_ws/src
    cd ~/catkin_ws
    catkin init
    catkin config --extend /opt/ros/kinetic/
    catkin build
    source ~/catkin_ws/devel/setup.bash
    ```

## Install additional software

    ```
    cd ~/Downloads
    mkdir UbuntuSetup
    cd UbuntuSetup

    # Add PPA's
    sudo apt-add-repository ppa:kdenlive/kdenlive-stable
    sudo add-apt-repository ppa:pinta-maintainers/pinta-stable
    sudo apt-add-repository ppa:maarten-baert/simplescreenrecorder

    # Update apt cache
    sudo apt update

    sudo apt install -y texlive-full texmaker git kdiff3 htop retext kdenlive pinta simplescreenrecorder
    sudo snap install notepad-plus-plus vlc

    sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
    sudo chmod a+rx /usr/local/bin/youtube-dl

    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install ./google-chrome-stable_current_amd64.deb

    wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
    sudo apt install ./gitkraken-amd64.deb

    wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.4.2-amd64.deb
    sudo apt install ./slack-desktop-4.4.2-amd64.deb

    wget https://repo.skype.com/latest/skypeforlinux-64.deb
    sudo apt install ./skypeforlinux-64.deb

    wget https://www.scootersoftware.com/bcompare-4.3.4.24657_amd64.deb
    sudo apt install ./bcompare-4.3.4.24657_amd64.deb

    # Install VS Code
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get install -y apt-transport-https
    sudo apt-get update
    sudo apt-get install -y code

    cd ~
    ```

## Setup ThunderBird

* Follow steps in [this](https://support.mozilla.org/en-US/kb/moving-thunderbird-data-to-a-new-computer) guide.

## Install JabRef

* Follow installation instructions from [here](https://docs.jabref.org/general/installation#installation-commands)

## Install FoxitReader 

* Download the installer from [here](https://www.foxitsoftware.com/pdf-reader/) and complete the installation.



# Setup Reference Guides

1. Dual Boot Ubuntu
    * [Installing Ubuntu 18.04 on the Dell XPS 15 7590](https://medium.com/@tylergwlum/my-journey-installing-ubuntu-18-04-on-the-dell-xps-15-7590-2019-756f738a6447)
    * [ItsFOSS - How To Install Ubuntu Alongside Windows 10](https://itsfoss.com/install-ubuntu-1404-dual-boot-mode-windows-8-81-uefi/)
    * [A GitHub Discussion regarding installation of Ubuntu](https://github.com/JackHack96/dell-xps-9570-ubuntu-respin/issues/108)
