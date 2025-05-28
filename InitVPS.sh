#!/bin/bash

# Color Functions
function RED(){ echo -e "\n\033[1;31m$1\033[0m"; }
function GREEN(){ echo -e "\n\033[1;32m$1\033[0m"; }
function YELLOW(){ echo -e "\n\033[1;33m$1\033[0m"; }
function BLUE(){ echo -e "\n\033[1;34m$1\033[0m"; }

# Root check
if [ "$EUID" -ne 0 ]; then
    RED "Please run as root"
    exit 1
fi

# 用户名与tools目录
USER_HOME=$(eval echo ~${SUDO_USER:-$USER})
TOOLS_DIR="$USER_HOME/tools"
mkdir -p "$TOOLS_DIR"
chown "$USER":"$USER" "$TOOLS_DIR"

# 基础组件
BLUE "Updating system and installing essential packages..."
apt-get update && apt-get upgrade -y
apt-get install -y curl wget git build-essential python3 python3-pip python3-venv python3-dev python3-setuptools \
    zsh terminator vim tmux net-tools gcc g++ make locate unzip rar p7zip-full \
    apt-transport-https ca-certificates gnupg lsb-release software-properties-common \
    libssl-dev libffi-dev libpcap-dev pkg-config

# 网络与渗透必备
BLUE "Installing common pentest tools..."
apt-get install -y nmap masscan proxychains4 wireshark tcpdump netcat-openbsd \
    exiftool binwalk steghide foremost scalpel hashcat john hydra medusa nikto \
    sqlmap gobuster ffuf wfuzz sublist3r whatweb dnsutils whois amap \
    openvpn metasploit-framework seclists wordlists crunch cmake unzip \
    unrar sqlite3 sqlitebrowser pinta

# Python库
BLUE "Installing Python security libraries..."
pip3 install --upgrade pip
pip3 install requests flask flask-login colorama passlib scapy pwntools impacket

# Go语言环境与常用工具
BLUE "Installing Go and go-based security tools..."
apt-get install -y golang-go
sudo -u "$USER" mkdir -p "$USER_HOME/go/bin"
export GOPATH="$USER_HOME/go"
export GOBIN="$USER_HOME/go/bin"
echo "export GOPATH=\$HOME/go" | sudo -u "$USER" tee -a "$USER_HOME/.bashrc" > /dev/null
echo "export GOBIN=\$HOME/go/bin" | sudo -u "$USER" tee -a "$USER_HOME/.bashrc" > /dev/null
echo "export PATH=\$PATH:\$GOBIN" | sudo -u "$USER" tee -a "$USER_HOME/.bashrc" > /dev/null

sudo -u "$USER" go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
sudo -u "$USER" go install github.com/tomnomnom/assetfinder@latest
sudo -u "$USER" go install github.com/OWASP/Amass/v3/...@latest
sudo -u "$USER" go install github.com/tomnomnom/httprobe@latest
sudo -u "$USER" go install github.com/tomnomnom/unfurl@latest
sudo -u "$USER" go install github.com/tomnomnom/waybackurls@latest
sudo -u "$USER" go install github.com/OJ/gobuster/v3@latest
sudo -u "$USER" go install github.com/projectdiscovery/httpx/cmd/httpx@latest

# 安装Docker
BLUE "Installing Docker..."
apt-get install -y docker.io
systemctl enable docker
systemctl start docker
usermod -aG docker "$USER"

# 不再删除桌面/文档等家目录（**保留桌面环境**）
GREEN "Desktop and personal folders are kept!"

# 只保留最新版python3, 不推荐继续使用python2与pip2（若有特需可以补装）
YELLOW "Python2 & pip2 will NOT be installed by default, use only if legacy needed!"

# 常用开源渗透工具和框架
cd "$TOOLS_DIR"

BLUE "Cloning and setting up commonly used pentest tools..."
sudo -u "$USER" git clone https://github.com/danielmiessler/SecLists.git || true
sudo -u "$USER" git clone https://github.com/SecureAuthCorp/impacket.git || true
sudo -u "$USER" git clone https://github.com/guelfoweb/knock.git || true
sudo -u "$USER" git clone https://github.com/nahamsec/lazyrecon.git || true
sudo -u "$USER" git clone https://github.com/nahamsec/JSParser.git || true
sudo -u "$USER" git clone https://github.com/Threezh1/JSFinder.git || true
sudo -u "$USER" git clone https://github.com/L-codes/Neo-reGeorg.git || true
sudo -u "$USER" git clone https://github.com/projectdiscovery/httpx.git || true
sudo -u "$USER" git clone https://github.com/aboul3la/Sublist3r.git || true
sudo -u "$USER" git clone https://github.com/maurosoria/dirsearch.git || true
sudo -u "$USER" git clone https://github.com/nahamsec/lazys3.git || true
sudo -u "$USER" git clone https://github.com/Yang0615777/PocList.git || true
sudo -u "$USER" git clone https://github.com/shmilylty/OneForAll.git || true

# 安装wpscan（Ruby gem）
BLUE "Installing wpscan..."
apt-get install -y ruby-full
gem install wpscan

# 常用密码字典下载
BLUE "Downloading more password/wordlist dictionaries (rockyou etc.)..."
apt-get install -y rockyou

# Stegsolve
BLUE "Downloading Stegsolve.jar..."
wget -O Stegsolve.jar http://www.caesum.com/handbook/Stegsolve.jar

# 额外推荐工具
BLUE "Installing additional useful tools: bloodhound, amass, zaproxy, feroxbuster, etc."
apt-get install -y bloodhound zaproxy enum4linux feroxbuster

# 清理多余
BLUE "Cleaning up..."
apt-get autoremove -y
apt-get clean

GREEN "All done! Please restart your terminal or re-login for all settings to take effect."
echo
YELLOW "工具集中在: $TOOLS_DIR"
YELLOW "Go工具（如subfinder, assetfinder）在: $USER_HOME/go/bin"
YELLOW "如需MSF、Wireshark等需权限的程序，请手动配置相应策略或用sudo运行。"

# END OF SCRIPT
