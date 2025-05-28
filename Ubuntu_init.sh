#!/bin/bash
set -e  # 脚本遇到错误立即退出

# 颜色输出
function info(){ echo -e "\e[1;34m[INFO]\e[0m $1"; }
function ok(){ echo -e "\e[1;32m[OK]\e[0m $1"; }
function warn(){ echo -e "\e[1;33m[WARN]\e[0m $1"; }
function err(){ echo -e "\e[1;31m[ERR]\e[0m $1"; }

# 检查root权限
if [ "$(id -u)" -ne 0 ]; then
  err "必须以root身份运行该脚本"
  exit 1
fi

# 基础软件
info "更新软件源并安装基础软件..."
apt update && apt upgrade -y
apt install -y curl wget git vim tmux terminator zsh python3 python3-pip build-essential apt-transport-https ca-certificates gnupg lsb-release software-properties-common

# 网络工具
info "安装常用网络与信息收集工具..."
apt install -y nmap netcat traceroute dnsutils whois tcpdump ipcalc \
  proxychains4 wireshark openvpn masscan hydra john hashcat nikto \
  sqlmap gobuster dirb ffuf amap htop atop iftop iptraf

# 破解与隐写工具
info "安装破解与隐写工具..."
apt install -y steghide exiftool fcrackzip unrar pdfcrack binwalk \
  foremost foremost scalpel hexedit

# 渗透框架和安全工具
info "安装Metasploit、Impacket、MSFvenom、Responder等..."
apt install -y metasploit-framework responder
pip3 install impacket

# Docker与虚拟化
info "安装Docker..."
apt install -y docker.io
systemctl enable --now docker
usermod -aG docker "$SUDO_USER"

# 代码编辑与办公
info "安装Sublime Text、Chromium、Pinta、sqlitebrowser..."
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" > /etc/apt/sources.list.d/sublime-text.list
apt update
apt install -y sublime-text chromium-browser pinta sqlitebrowser

# Python安全开发工具
info "安装Python相关安全开发库..."
pip3 install --upgrade pip
pip3 install requests flask flask-login colorama passlib scapy pwntools

# Go语言与常用go工具
info "安装Go与相关工具..."
apt install -y golang-go
export GOPATH="$HOME/go"
export GOBIN="$HOME/go/bin"
export PATH="$PATH:$GOBIN"
grep -q 'export GOPATH' ~/.bashrc || echo 'export GOPATH=$HOME/go' >> ~/.bashrc
grep -q 'export GOBIN' ~/.bashrc || echo 'export GOBIN=$HOME/go/bin' >> ~/.bashrc
grep -q 'export PATH=\$PATH:\$GOBIN' ~/.bashrc || echo 'export PATH=\$PATH:\$GOBIN' >> ~/.bashrc

# 安装go工具（常用信息收集&爆破工具）
info "安装常用go工具：subfinder, assetfinder, amass, httprobe, waybackurls, unfurl..."
su - "$SUDO_USER" -c "go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
su - "$SUDO_USER" -c "go install github.com/tomnomnom/assetfinder@latest"
su - "$SUDO_USER" -c "go install github.com/OWASP/Amass/v3/...@latest"
su - "$SUDO_USER" -c "go install github.com/tomnomnom/httprobe@latest"
su - "$SUDO_USER" -c "go install github.com/tomnomnom/waybackurls@latest"
su - "$SUDO_USER" -c "go install github.com/tomnomnom/unfurl@latest"
su - "$SUDO_USER" -c "go install github.com/OJ/gobuster/v3@latest"

# CTF和Web渗透辅助工具下载到~/tools
TOOLS_DIR="/home/$SUDO_USER/tools"
mkdir -p "$TOOLS_DIR"
chown "$SUDO_USER":"$SUDO_USER" "$TOOLS_DIR"

cd "$TOOLS_DIR"

info "下载CTF常用工具/字典..."
su - "$SUDO_USER" -c "git clone --depth=1 https://github.com/danielmiessler/SecLists.git"
su - "$SUDO_USER" -c "git clone https://github.com/SecureAuthCorp/impacket.git"
su - "$SUDO_USER" -c "git clone https://github.com/maurosoria/dirsearch.git"
su - "$SUDO_USER" -c "git clone https://github.com/guelfoweb/knock.git"
su - "$SUDO_USER" -c "git clone https://github.com/aboul3la/Sublist3r.git"
su - "$SUDO_USER" -c "git clone https://github.com/nahamsec/lazyrecon.git"
su - "$SUDO_USER" -c "git clone https://github.com/nahamsec/JSParser.git"
su - "$SUDO_USER" -c "git clone https://github.com/projectdiscovery/httpx.git"
su - "$SUDO_USER" -c "git clone https://github.com/Threezh1/JSFinder.git"
su - "$SUDO_USER" -c "git clone https://github.com/L-codes/Neo-reGeorg.git"
su - "$SUDO_USER" -c "git clone https://github.com/Yang0615777/PocList.git"
su - "$SUDO_USER" -c "git clone https://github.com/shmilylty/OneForAll.git"
su - "$SUDO_USER" -c "git clone https://github.com/tomnomnom/assetfinder.git"

# Stegsolve.jar下载
info "下载Stegsolve..."
wget -O Stegsolve.jar http://www.caesum.com/handbook/Stegsolve.jar
chmod +x Stegsolve.jar

# 安装zsh和oh-my-zsh（可选）
info "安装zsh与oh-my-zsh（可选）..."
apt install -y zsh fonts-powerline
su - "$SUDO_USER" -c "sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" || true"

# 常用渗透测试字典/辅助包
apt install -y wordlists crunch seclists

ok "所有核心工具安装完毕！请重启终端以确保环境变量生效。"
