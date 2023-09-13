FROM danielguerra/ubuntu-xrdp:20.04

RUN sudo apt-get update && sudo apt-get install -y curl
RUN sudo apt-get update && sudo apt-get install -y bash
RUN sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
RUN sudo apt-get update && sudo apt-get install -y ros-noetic-desktop-full
RUN sudo apt-get update && sudo apt-get install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
RUN sudo rosdep init

ARG DEFAULT_USER=rosuser
# 입력값이 바뀌는 경우 다시 빌드할 수 있도록 입력값 전체에 대한 hash값을 argument로 받도록 해서, 이 이후 부분은 rebuild될 수 있도록 함.
ARG INPUT_HASH
RUN echo $INPUT_HASH

RUN --mount=type=secret,id=defaultUserPasswd \
    useradd -m $DEFAULT_USER -p $(openssl passwd -in /run/secrets/defaultUserPasswd) -s /bin/bash
RUN usermod -aG sudo $DEFAULT_USER

# Not to make the user 'ubuntu' automatically
RUN sudo rm /etc/users.list

RUN sudo -u $DEFAULT_USER echo "source /opt/ros/noetic/setup.bash" >> /home/$DEFAULT_USER/.bashrc
RUN sudo -u $DEFAULT_USER /bin/bash -c "rosdep update"

# 한글환경
RUN sudo apt-get update && sudo apt-get install -y language-pack-ko
RUN sudo locale-gen ko_KR.UTF-8
RUN sudo update-locale LANG=ko_KR.UTF-8
RUN sudo apt-get update && sudo apt-get install -y fonts-nanum fonts-nanum-coding fonts-nanum-extra
RUN sudo apt-get update && sudo apt-get install -y ibus ibus-hangul
RUN sudo printf '\n\
[Desktop Entry]\n\
Type=Application\n\
Name=IBUS Hangul Autostart\n\
Comment=Launch IBUS Hangul Environment\n\
Exec=/bin/bash -c "ibus exit; ibus-daemon -d; sleep 1; ibus engine hangul"\n\
OnlyShowIn=XFCE;\n\
' > /etc/xdg/autostart/ibus-hangul-autostart.desktop

