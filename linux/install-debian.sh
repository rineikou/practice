#!/bin/sh
USER_RC='alias cman="man -M /usr/share/man/zh_CN"
export LANG="zh_CN.UTF-8"
export LC_ALL="zh_CN.UTF-8"
export LANGUAGE="zh_CN.UTF-8"'

# 换源
sudo apt-get install ca-certificates
sudo sed -i "s@http://\(deb\|security\).debian.org@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
sudo apt-get update

# 设置参数
if grep -q "$USER_RC" ~/.zshrc;
then :
else echo "$USER_RC">>~/.zshrc
fi
sudo bash -c "sed -i 's/# zh_CN.UTF-8/zh_CN.UTF-8/g' /etc/locale.gen"
sudo locale-gen

sudo apt-get install -y vim zsh git curl man-db manpages-zh

# 安装docker
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install gnupg
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable"|sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
echo "随便切换后再换回去"
sudo update-alternatives --config iptables