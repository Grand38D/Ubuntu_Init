#### According to the expert's documentation, I wrote a bash script to initialize the Ubuntu virtual machine for penetration testing. Applicable to Ubuntu 20.04/22.04 and derived systems

#### 根据大佬的文档，自己写了一个为渗透测试初始化ubuntu虚拟机的bash脚本.适用于 Ubuntu 20.04/22.04 及派生系统

【优化说明】
保留桌面/文档等个人目录，防止误删重要文件；

完全以 Python3 生态为主流，不默认装 Python2/pip2，除非必须用到（不建议2024年再用python2）；

所有 go 工具用 go install 的方式，版本最新并确保在 $HOME/go/bin 下，避免和全局环境冲突；

所有 Git clone 都加 || true，防止重复 clone 导致报错；

Docker、Metasploit、Wireshark等默认装好，并加当前用户到docker组；

路径全修正，不会出现 /subfinder/v2/cmd/subfinder/ 这样因 cd 路径问题失败；

wpscan 用 gem 安装，兼容性好于源码；

加入了 feroxbuster、bloodhound、amass、zaproxy 等当代红队常用神器；

pip3、go、apt等全部不需手动输入，纯自动化；

以普通用户身份clone，避免home权限混乱；

环境变量自动写入 .bashrc；

增加rockyou等常用字典；

最后清理系统包缓存，减少空间浪费
