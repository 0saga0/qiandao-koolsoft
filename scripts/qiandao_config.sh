#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export qiandao_`

start_qiandao(){
	[ -n "$qiandao_tieba" ] && tieba="\"tieba\"=$qiandao_tieba" || tieba=""
	[ -n "$qiandao_bilibili" ] && bilibili="\"bilibili\"=$qiandao_bilibili" || bilibili=""
	[ -n "$qiandao_smzdm" ] && smzdm="\"smzdm\"=$qiandao_smzdm" || smzdm=""
	[ -n "$qiandao_v2ex" ] && v2ex="\"v2ex\"=$qiandao_v2ex" || v2ex=""
	[ -n "$qiandao_hostloc" ] && hostloc="\"hostloc\"=$qiandao_hostloc" || hostloc=""
	echo -e "$tieba\n$bilibili\n$smzdm\n$v2ex\n$hostloc\n########################END################" > $KSROOT/qiandao/cookie.conf
	sed -i '/qiandao/d' /etc/crontabs/root
	echo "0 $qiandao_time * * * $KSROOT/qiandao/qiandao" >> /etc/crontabs/root
	$KSROOT/qiandao/qiandao >/dev/null 2>&1 &
}

# used by rc.d
case $1 in
start)
	if [ "$qiandao_enable" == "1" ];then
		start_qiandao
	else
        killall qiandao
	fi
	;;
stop)
	killall qiandao
	;;
esac

# used by httpdb
case $2 in
start)
	if [ "$qiandao_enable" == "1" ];then
		killall qiandao
		start_qiandao
		http_response '设置已保存！切勿重复提交！页面将在1秒后刷新'
	else
		killall qiandao
        http_response '设置已保存！切勿重复提交！页面将在1秒后刷新'
    fi
	;;
stop)
	killall qiandao
    http_response '设置已保存！切勿重复提交！页面将在1秒后刷新'
	;;
esac
