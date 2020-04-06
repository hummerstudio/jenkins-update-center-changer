#!/bin/bash

help() {
    echo "使用方法：bash jenkins-update-center-changer.sh [命令]"
    echo "命令:"
    echo "  modify    默认操作，修改插件更新中心为国内镜像"
    echo "  rollback  回滚修改操作"
    echo "  help      打印本帮助信息"
}

getJenkinsHome() {
    if [ $JENKINS_HOME ]; then
        echo "识别到JENKINS_HOME: $JENKINS_HOME"
    else
        echo "错误: 环境变量JENKINS_HOME未设置，程序退出！"
        exit -1
    fi
}

createCADirAndFile() {
    if [ ! -d $JENKINS_HOME/update-center-rootCAs ]; then
        mkdir $JENKINS_HOME/update-center-rootCAs
    fi

    if [ -d $JENKINS_HOME/update-center-rootCAs ]; then
        echo "目录$JENKINS_HOME/update-center-rootCAs创建成功"
    else
        echo "目录$JENKINS_HOME/update-center-rootCAs创建失败，程序退出!"
    fi
    touch $JENKINS_HOME/update-center-rootCAs/jenkins-update-center-cn-root-ca.crt
    cat>$JENKINS_HOME/update-center-rootCAs/jenkins-update-center-cn-root-ca.crt<<END
-----BEGIN CERTIFICATE-----
MIICcTCCAdoCCQD/jZ7AgrzJKTANBgkqhkiG9w0BAQsFADB9MQswCQYDVQQGEwJD
TjELMAkGA1UECAwCR0QxCzAJBgNVBAcMAlNaMQ4wDAYDVQQKDAV2aWhvbzEMMAoG
A1UECwwDZGV2MREwDwYDVQQDDAhkZW1vLmNvbTEjMCEGCSqGSIb3DQEJARYUYWRt
aW5AamVua2lucy16aC5jb20wHhcNMTkxMTA5MTA0MDA5WhcNMjIxMTA4MTA0MDA5
WjB9MQswCQYDVQQGEwJDTjELMAkGA1UECAwCR0QxCzAJBgNVBAcMAlNaMQ4wDAYD
VQQKDAV2aWhvbzEMMAoGA1UECwwDZGV2MREwDwYDVQQDDAhkZW1vLmNvbTEjMCEG
CSqGSIb3DQEJARYUYWRtaW5AamVua2lucy16aC5jb20wgZ8wDQYJKoZIhvcNAQEB
BQADgY0AMIGJAoGBAN+6jN8rCIjVkQ0Q7ZbJLk4IdcHor2WdskOQMhlbR0gOyb4g
RX+CorjDRjDm6mj2OohqlrtRxLGYxBnXFeQGU7wWjQHyfKDghtP51G/672lXFtzB
KXukHByHjtzrDxAutKTdolyBCuIDDGJmRk+LavIBY3/Lxh6f0ZQSeCSJYiyxAgMB
AAEwDQYJKoZIhvcNAQELBQADgYEAD92l26PoJcbl9GojK2L3pyOQjeeDm/vV9e3R
EgwGmoIQzlubM0mjxpCz1J73nesoAcuplTEps/46L7yoMjptCA3TU9FZAHNQ8dbz
a0vm4CF9841/FIk8tsLtwCT6ivkAi0lXGwhX0FK7FaAyU0nNeo/EPvDwzTim4XDK
9j1WGpE=
-----END CERTIFICATE-----
END

    if [ -f $JENKINS_HOME/update-center-rootCAS/jenkins-update-center-cn-root-ca.crt ]; then
        echo "成功生成根证书文件$JENKINS_HOME/update-center-rootCAS/jenkins-update-center-cn-root-ca.cr"
    fi
}

backupUpdateCenterConfig() {
    cp hudson.model.UpdateCenter.xml hudson.model.UpdateCenter.xml.back

    if [ -f $JENKINS_HOME/hudson.model.UpdateCenter.xml.back ]; then
        echo "备份插件更新中心配置文件成功。"
    fi
}

modifyUpdateCenterConfig() {
    sed -i 's/<url.*url>/<url>https:\/\/updates.jenkins-zh.cn\/update-center.json<\/url>/g' hudson.model.UpdateCenter.xml
    echo "修改插件中心配置成功！"
}

tips() {
    echo -e "特别提醒：\n1.Jenkins重启后修改才会生效！\n2.重启后不要忘了先进入插件管理页面点击“立即获取”从新地址获取数据！\n3.开始享受极速下载的美好体验吧！"
}

modify() {
    echo "开始执行修改插件更新中心操作..."
    getJenkinsHome
    createCADirAndFile
    backupUpdateCenterConfig
    modifyUpdateCenterConfig
    tips
}

rollback() {
    echo "开始执行回滚操作..."
    getJenkinsHome
    if [ -f $JENKINS_HOME/hudson.model.UpdateCenter.xml.back ]; then
        cp $JENKINS_HOME/hudson.model.UpdateCenter.xml.back $JENKINS_HOME/hudson.model.UpdateCenter.xml
        echo "回滚插件更新中心配置文件成功。"
    else
        echo "错误：没有找到备份文件$JENKINS_HOME/hudson.model.UpdateCenter.xml.back"
    fi
}

if [ $# == 0 ]; then
    modify
elif [ $* = "modify" ]; then
    modify
elif [ $* = "rollback" ]; then
    rollback
elif [ $* = "help" ]; then
    help
else
    help
fi
