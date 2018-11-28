#!/bin/bash
if [ `whoami` = "root" ];then
    echo "normal"
else
    echo "请使用root权限执行! sudo ./start.sh"
    exit
fi
if [ ! -n "$1" ] ; then
        echo "请输入启动参数:
up 启动网络服务
down 停止网络服务
restart 重启服务
例如: ./start.sh up"
        exit
else
    action=$1
    chmod a+x /home/baas/bin/http
    pid=`ps -ef | grep "env/online.json" | grep "http" | awk '{print $2}'`
    echo "当前服务进程id：${pid}"
    if [ $action == "up" ];then
        if [ "$pid" != "" ];then
            echo "程序正在运行中"
        else
            echo "start service"
            nohup /home/baas/bin/http -f /home/baas/env/online.json >>/tmp/http.go &
        fi
    elif [ $action == "down" ];then
        if [ "$pid" == "" ];then
            echo "程序尚未运行"
        else
            echo "stop service"
            sudo kill -9 $pid
        fi
    elif [ $action == "restart" ];then
        if [ "$pid" == "" ];then
            echo "程序尚未运行"
            echo "start service"
            nohup /home/baas/bin/http -f /home/baas/env/online.json >>/tmp/http.go &
        else
            echo "stop service"
            kill -9 $pid
            echo "start service"
            nohup /home/baas/bin/http -f /home/baas/env/online.json >>/tmp/http.go &
        fi
    else
        echo "参数错误"
    fi
fi