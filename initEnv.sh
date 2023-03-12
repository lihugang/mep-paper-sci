#!/usr/bin/sh

type xelatex > /dev/null
if [ $? -eq 127 ]; then
    echo 检测到TexLive未安装，正在安装
    sudo apt-get install texlive
    sudo apt-get install texlive-xetex
    sudo apt-get install texlive-lang-chinese
    sudo apt-get install texlive-full
    if [ $? -eq 0 ]; then
        echo TexLive安装成功
    else
        echo TexLive安装失败
        return 1
    fi
else
    echo TexLive已安装√
fi

type npm > /dev/null
if [ $? -eq 127 ]; then
    echo 检测到nodejs未安装
    sudo apt-get install nodejs
    if [ $? -eq 0 ]; then
        echo nodejs安装成功
    else
        echo nodejs安装失败
        return 1
    fi
else
    echo nodejs已安装√
fi

type pnpm > /dev/null
if [ $? -eq 127 ]; then
    echo 检测到pnpm未安装
    npm install pnpm -g
    if [ $? -eq 0 ]; then
        echo pnpm安装成功
    else
        echo pnpm安装失败
        return 1
    fi
else
    echo pnpm已安装√
fi

type pnpm > /dev/null
if [ $? -eq 0 ]; then
    echo 正在升级nodejs到最新版本
    pnpm env use --global lts
    if [ $? -eq 0 ]; then
        echo 升级nodejs版本成功√
    else
        echo 无法升级nodejs到最新版本
    fi
fi

fc-list | grep "CMU" > /dev/null
if [ $? -eq 1 ]; then
    echo 正在安装字体
    wget -O cm-fonts.tar.xz https://fileshare.lihugang.top/cm-unicode-0.7.0-ttf.tar.xz
    tar -xf cm-fonts.tar.xz
    rm -rf cm-fonts.tar.xz
    sudo mkdir /usr/share/fonts/cm/
    sudo cp cm-unicode-0.7.0/*.ttf /usr/share/fonts/cm/
    sudo chmod 755 -R /usr/share/fonts/cm
    sudo mkfontscale
    sudo mkfontdir
    sudo fc-cache -fv
    fc-list | grep "CMU" > /dev/null
    if [ $? -eq 0 ]; then
        rm -rf fonts.dir
        rm -rf fonts.scale
        sudo apt-get install fonts-noto-cjk
        fc-list | grep "Noto Sans CJK" > /dev/null
        if [ $? -eq 0]; then
            echo 字体安装成功√
        else
            echo 字体安装失败
            return 1
        fi
    else
        rm -rf cm-unicode-0.7.0/
        echo 字体安装失败
        return 1
    fi
    rm -rf cm-unicode-0.7.0/
else
    echo 字体已安装√
fi

cp -r hooks/* .git/hooks/
sudo chmod u+x .git/hooks/*
echo 添加钩子成功√