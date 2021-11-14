sudo apt update
sudo apt upgrade

#sudo apt install blueman \
#                 pavucontrol \
#                 arp-scan \
#                 xscreensaver \
#                 keepass2 \
#                 redshift \
#                 redshift-gtk \
#                 kdenlive \
#                 dia \
#                 audacity \
#                 audacious \
#                 mediainfo \
#                 pandoc

#sudo add-apt-repository ppa:audio-recorder/ppa
#sudo apt install audio-recorder

sudo apt install curl \
                 htop \
                 arandr \
                 pylint \
                 python3-pip

sudo apt install vim \
                 ranger \
                 terminator \
                 i3 \
                 git \
                 zsh \
                 tmux \
                 scrot \
                 pdftk \
                 texlive-full \
                 pdfpc \
                 texmaker \
                 kdiff3

#sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install VSCode
sudo snap install code --classic

# install gitkraken
sudo snap install gitkraken --classic

# install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh
sudo groupadd docker
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock

# install nordvpn
wget https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb
sudo apt install ./nordvpn-release_1.0.0_all.deb
sudo apt update
sudo apt install nordvpn
rm nordvpn-release_1.0.0_all.deb

# install jabref
sudo snap install jabref

# install slack
sudo snap install slack --classic

# install skype
sudo snap install skype --classic

# install VLC player
sudo snap install vlc

# install krita
sudo snap install krita

# install simplescreenrecorder
sudo snap install simplescreenrecorder

# install google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# install zoom
wget https://zoom.us/client/latest/zoom_amd64.deb
sudo apt install ./zoom_amd64.deb
rm zoom_amd64.deb

# install python packages
sudo pip3 install ipython \
                  numpy \
                  scipy \
                  sympy \
                  matplotlib \
                  jupyter \
                  nbgrader \
                  rdflib \
                  networkx \
                  shapely \
                  oyaml \
                  pandas \
                  pymongo \
                  beautifulsoup4

# install ROS
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo apt update
sudo apt install ros-noetic-desktop-full
sudo apt install python3-catkin-tools python3-rosdep
sudo rosdep init
rosdep update
sudo apt install ros-noetic-map-server \
                 ros-noetic-amcl \
                 ros-noetic-teb-local-planner \
                 ros-noetic-move-base

#sudo apt install libbison-dev \
#                 flex \
#                 rviz

# set default git editor to vim
git config --global core.editor "vim"

# disable ubuntu tracking "frequently used" applications
gsettings set org.gnome.desktop.privacy remember-app-usage false

# reebot required to apply all changes for docker, nordvpn etc.
sudo reboot
