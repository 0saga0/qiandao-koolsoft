#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export qiandao_`

mkdir -p $KSROOT/init.d
mkdir -p /tmp/upload

# stop qiandao if enabled
[ -n "`pidof qiandao`" ] && sh $KSROOT/scripts/qiandao_config.sh stop

cp -r /tmp/qiandao/* $KSROOT/
chmod +x $KSROOT/qiandao/qiandao
chmod +x $KSROOT/scripts/qiandao_*
chmod +x $KSROOT/init.d/S99qiandao.sh
rm -rf $KSROOT/install.sh

# add icon into softerware center
dbus set softcenter_module_qiandao_install=1
dbus set softcenter_module_qiandao_name=qiandao
dbus set softcenter_module_qiandao_title=自动签到
dbus set softcenter_module_qiandao_description="帮助你完成自动签到"
dbus set softcenter_module_qiandao_version=1.0.1

# remove old files if exist
find /etc/rc.d/ -name *qiandao.sh* | xargs rm -rf

# now create start up file
ln -sf /koolshare/init.d/S99qiandao.sh /etc/rc.d/S99qiandao.sh

return 0
