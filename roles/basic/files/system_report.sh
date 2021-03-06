#!/bin/bash
#@20161027 loryu
work_dir=`pwd`
base_dir=/u01
tmct_dir=/u01/testdir
mkdir -p $base_dir/logs
function chk_date(){
	echo `date +%Y%m%d`
}
function chk_time(){
	echo `date +%H:%M:%S`
}
function mem_report(){
	echo $(chk_time) memory used:`free -m|grep Mem|awk '{print \$3}'` 
	echo $(chk_time) memory free:`free -m|grep Mem|awk '{print \$4}'`
}
function disk_report(){
	for pnt_chk in $@;do
		ex_row=`df -m|sed -n '1p'|awk '{print \$1}'`
		dskav=`df -m $pnt_chk|grep -v $ex_row|awk '{print \$4}'`
		dsktl=`df -m $pnt_chk|grep -v $ex_row|awk '{print \$2}'`
		psav=`awk 'BEGIN{printf "%.2f%\n",('$dskav'/'$dsktl')*100}'`
		echo $(chk_time) mount_point: $pnt_chk disk avaliable: $psav
	done 
}
function tomcat_report(){
	for tmct_node in `ls $tmct_dir|grep svr-t7|grep -v test`;do
		tmct_pid=`ps aux|grep $tmct_node|grep -v test|grep -v grep|awk '{print \$2}'`
		if [[ -z $tmct_pid ]];then
			echo $(chk_time) $tmct_node is *NOT* active
		else
			echo $(chk_time) $tmct_node pid: $tmct_pid %CPU: `top -bn1|grep $tmct_pid|awk '{print \$9}'` RES: `top -bn1|grep $tmct_pid|awk '{print \$6}'`
		fi
	done
}
function login_chk(){
	for noden in `ls /u01/ccservice/|grep svr-t7-808`;do
		nport=`echo $noden|awk -F'-' '{print $3}'`
		login_code=`curl -s "http://localhost:$nport/test.action?service=service1&user=user1&password=pwd1"`
		login_rslt=`echo $login_code|awk -F',' '{print \$4}'|awk -F':' '{print \$2}'|cut -c2`
		if [[ $login_rslt -eq 1 ]];then
			echo $noden login successfully
		else
			echo $noden login failed
		fi
	done
}
#script start
if [[ ! -f $base_dir/logs/$(chk_date).log ]];then
	touch $base_dir/logs/$(chk_date).log
	echo $(chk_time)=================start system report====================== 2>&1|tee -a $base_dir/logs/$(chk_date).log
	mem_report 2>&1|tee -a $base_dir/logs/$(chk_date).log
	disk_report /u01 2>&1|tee -a $base_dir/logs/$(chk_date).log
	tomcat_report 2>&1|tee -a $base_dir/logs/$(chk_date).log
	login_chk 2>&1|tee -a $base_dir/logs/$(chk_date).log
	echo $(chk_time)=================finished system report====================== 2>&1|tee -a $base_dir/logs/$(chk_date).log
else
	echo $(chk_time)=================start system report====================== 2>&1|tee -a $base_dir/logs/$(chk_date).log
	mem_report 2>&1|tee -a $base_dir/logs/$(chk_date).log
	disk_report /u01 2>&1|tee -a $base_dir/logs/$(chk_date).log
	tomcat_report 2>&1|tee -a $base_dir/logs/$(chk_date).log
	login_chk 2>&1|tee -a $base_dir/logs/$(chk_date).log
	echo $(chk_time)=================finished system report====================== 2>&1|tee -a $base_dir/logs/$(chk_date).log
fi
