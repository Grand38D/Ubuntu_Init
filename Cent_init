#!/bin/bash

#==============================================================================
# CentOS 渗透测试及攻击模拟环境搭建脚本 (内部实验室环境专用)
# 作者: 基于用户需求生成
# 日期: 2023-10-27
#
# 警告:
# 1. 本脚本及其安装的工具仅用于合法的、授权的内部安全测试和研究。
# 2. 严禁将本脚本或工具用于任何非法用途。使用者需自行承担所有法律和伦理责任。
# 3. "免杀"是复杂概念，本脚本安装的工具本身可能被检测，脚本不提供完全免杀保证。
# 4. 建议在隔离的虚拟机或专用硬件上运行此脚本和工具。
#==============================================================================

echo "----------------------------------------------------"
echo "   CentOS 安全测试环境搭建脚本"
echo "   注意: 本脚本仅用于合法的内部安全实验室环境。"
echo "   使用前请务必阅读并理解脚本开头的警告信息。"
echo "----------------------------------------------------"
echo ""

# 检查是否以root用户或sudo权限运行
if [[ $EUID -ne 0 ]]; then
   echo "错误: 请使用root用户或sudo权限运行本脚本。"
   exit 1
fi

# 确定包管理器 (yum或dnf)
if command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    echo "检测到使用 $PKG_MANAGER 包管理器."
else
    PKG_MANAGER="yum"
    echo "检测到使用 $PKG_MANAGER 包管理器."
fi

# 定义工具安装目录
TOOL_DIR="/opt/security_tools"
echo "工具将安装到目录: $TOOL_DIR"

# 1. 系统更新与准备
echo ""
echo "--- 步骤 1: 更新系统并安装必要的依赖 ---"
$PKG_MANAGER update -y
$PKG_MANAGER install epel-release -y # 安装EPEL仓库，许多工具在此
$PKG_MANAGER update -y # 更新EPEL仓库信息
$PKG_MANAGER groupinstall "Development Tools" -y # 安装编译工具链 (gcc, make等)
$PKG_MANAGER install wget git python3 python3-pip python3-devel perl perl-devel cmake net-tools openssl-devel zlib-devel libffi-devel readline-devel sqlite-devel -y

# 创建工具目录并赋予当前用户权限 (如果你不是root，需要确保你有写权限)
mkdir -p $TOOL_DIR
chown -R $(logname):$(logname) $TOOL_DIR # 将目录所有者改为执行脚本的用户

echo "系统更新及依赖安装完成."

# 2. 安装常用渗透测试工具 (通过包管理器)
echo ""
echo "--- 步骤 2: 安装常用渗透测试工具 (通过包管理器) ---"
# 这些是比较通用且常用的工具
$PKG_MANAGER install nmap -y       # 网络扫描
$PKG_MANAGER install hydra -y     # 密码爆破
$PKG_MANAGER install john -y        # 离线密码破解
$PKG_MANAGER install netcat -y      # 网络调试和数据传输 (nc)
$PKG_MANAGER install socat -y       # 高级网络瑞士军刀
$PKG_MANAGER install tcpdump -y     # 抓包工具
$PKG_MANAGER install masscan -y     # 高速端口扫描 (有时候包管理器里有，有时候需要源码)
# 如果masscan在包管理器里没有，后面会尝试源码安装

echo "通过包管理器安装的工具安装完成."

# 3. 安装其他常用工具 (通过Git克隆或源码)
echo ""
echo "--- 步骤 3: 安装其他常用工具 (通过Git克隆或源码) ---"
cd $TOOL_DIR

# sqlmap (自动化SQL注入工具)
echo "-> 安装 sqlmap..."
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git
echo "sqlmap 克隆完成. (位于 $TOOL_DIR/sqlmap)"

# gobuster (目录/文件/子域名爆破工具，需要Go环境，前面已安装)
echo "-> 安装 gobuster..."
git clone https://github.com/OJ/gobuster.git
cd gobuster
# 确保Go环境可用，并编译
go build
mv gobuster /usr/local/bin/ # 移动到PATH目录下
cd $TOOL_DIR
echo "gobuster 安装完成. (可直接使用命令 gobuster)"

# theHarvester (信息收集工具)
echo "-> 安装 theHarvester..."
git clone https://github.com/laramies/theHarvester.git
cd theHarvester
pip3 install -r requirements/base.txt
# 可以选择创建软链接或添加到PATH
# ln -s $TOOL_DIR/theHarvester/theHarvester.py /usr/local/bin/theHarvester # 示例软链接
cd $TOOL_DIR
echo "theHarvester 安装完成. (位于 $TOOL_DIR/theHarvester)"

# subfinder (子域名发现工具，需要Go环境)
echo "-> 安装 subfinder..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
# go install 会把二进制文件放到 $GOPATH/bin 或 $HOME/go/bin，确保这个目录在PATH里
echo "subfinder 安装完成. (检查 \$HOME/go/bin 是否在 \$PATH 中)"

# Social-Engineer Toolkit (SET) - 辅助社工测试，包含钓鱼、Payload生成等
echo "-> 安装 Social-Engineer Toolkit (SET)..."
git clone https://github.com/trustedsec/social-engineer-toolkit.git setoolkit
cd setoolkit
pip3 install -r requirements.txt # 安装Python依赖
# 需要运行 ./setup.py 来完成安装和设置，脚本不自动执行，请手动完成
echo "SET 克隆完成. 请手动进入 $TOOL_DIR/setoolkit 目录运行 'python3 setup.py' 完成安装."
cd $TOOL_DIR
echo "Social-Engineer Toolkit (SET) 安装完成. (位于 $TOOL_DIR/setoolkit)"


# 4. 一些考虑“免杀”或后渗透阶段可能用到的框架和工具提示
echo ""
echo "--- 步骤 4: 关于免杀及后渗透工具的额外提示 ---"
echo "以下工具安装通常比较复杂或涉及授权，不在此脚本中自动安装，仅提供信息供你参考："

echo "1. Metasploit Framework: 非常强大的漏洞利用框架。推荐使用官方Installer进行安装，或者在Kali/Parrot等预装的发行版中使用。"
echo "   安装指南: https://docs.metasploit.com/docs/getting-started/getting-started-with-metasploit.html"

echo "2. Cobalt Strike / Empire / Starkiller (Empire GUI): 高级攻击模拟和C2框架。Cobalt Strike 是商业软件。Empire/Starkiller 是开源的C2框架，安装相对复杂，可能需要Docker或特定的环境配置。"
echo "   这些框架常用于生成和管理难以检测的Payload，但其本身及其配置也需要技巧才能达到更好的隐匿效果。"

echo "3. 自定义Payload生成工具/框架: 如 msfvenom (Metasploit自带), Veil-Evasion, Covenant, PoshC2 等。它们可以生成不同类型的Payload，但需要根据目标环境、安全软件策略进行定制和混淆。"
echo "   免杀效果取决于Payload的生成方式、混淆技术、加密方式以及目标系统的检测能力，没有一劳永逸的方法。"

echo "4. Windows平台工具: 很多后渗透工具（如Mimikatz）是针对Windows的。你可能需要在你的测试环境中有Windows虚拟机，并在上面运行或交叉编译相关工具。"
echo "   或者考虑使用跨平台的后渗透工具，如通过Meterpreter或Shell来执行Python/PowerShell脚本。"

echo "记住，真正的免杀依赖于你对攻击面、防御措施和检测技术的理解，以及持续学习和定制Payload的能力，而不是简单安装某个工具就能实现。"

# 5. 完成和收尾
echo ""
echo "--- 步骤 5: 安装完成 ---"
echo "核心工具安装完毕。部分工具位于 $TOOL_DIR 目录下，请根据需要手动添加到环境变量PATH或使用完整路径执行。"
echo "例如，可以将以下行添加到 ~/.bashrc 或 ~/.bash_profile 文件中并重新加载终端:"
echo "export PATH=\$PATH:$TOOL_DIR/sqlmap"
echo "export PATH=\$PATH:$TOOL_DIR/masscan" # 如果masscan是源码安装并移动到$TOOL_DIR下的 bin 目录
echo "export PATH=\$PATH:\$HOME/go/bin" # 如果你的Go bin目录在此

echo ""
echo "重要提醒: 请再次确认所有操作都在合法的、授权的内部测试环境中进行！"
echo "祝你测试顺利，但请务必遵守法律和职业道德！"
echo "----------------------------------------------------"

exit 0
