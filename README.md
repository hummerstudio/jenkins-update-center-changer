# Jenkins Update Center Changer

Jenkins插件更新中心地址修改工具，可一键修改为国内镜像地址（包括自动创建证书），畅享高速下载体验。

# 一键切换为国内镜像（无须手动下载代码到本地)

执行命令：
`bash -c "$(curl -fsSL https://gitee.com/hummerstudio/jenkins-update-center-changer/raw/master/jenkins-update-center-changer.sh)"`

# 使用方法详解

使用方法：`bash jenkins-update-center-changer.sh [命令]`

命令:

- modify    修改插件更新中心为国内镜像，默认操作
- rollback  回滚修改操作
- help      打印本帮助信息

可以直接复制下面的命令执行:

一键切换为国内镜像：`bash jenkins-update-center-changer.sh`

一键复原：`bash jenkins-update-center-changer.sh rollback`


