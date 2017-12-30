<title>软件中心 - 自动签到</title>
<content>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
<style type="text/css">
	input[disabled]:hover{
    cursor:not-allowed;
}
</style>
<script type="text/javascript">
var dbus;
var softcenter = 0;
var _responseLen;
var noChange = 0;
var reload = 0;
var Scorll = 1;
get_dbus_data();
setTimeout("get_run_status();", 1000);

function get_dbus_data(){
	$.ajax({
	  	type: "GET",
	 	url: "/_api/qiandao_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	dbus = data.result[0];
	  	}
	});
}

function get_run_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "qiandao_status.sh", "params":[2], "fields": ""};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("_qiandao_status").innerHTML = response.result;
			setTimeout("get_run_status();", 3000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("_qiandao_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}

function verifyFields(focused, quiet){
	if(E('_qiandao_enable').checked){
		$('input').prop('disabled', false);
		$('select').prop('disabled', false);
	}else{
		$('input').prop('disabled', true);
		$('select').prop('disabled', true);
		$(E('_qiandao_enable')).prop('disabled', false);
	}
	return true;
}

function toggleVisibility(whichone) {
	if(E('sesdiv' + whichone).style.display=='') {
		E('sesdiv' + whichone).style.display='none';
		E('sesdiv' + whichone + 'showhide').innerHTML='<i class="icon-chevron-up"></i>';
		cookie.set('ss_' + whichone + '_vis', 0);
	} else {
		E('sesdiv' + whichone).style.display='';
		E('sesdiv' + whichone + 'showhide').innerHTML='<i class="icon-chevron-down"></i>';
		cookie.set('ss_' + whichone + '_vis', 1);
	}
}

function save(){
	var para_chk = ["qiandao_enable"];
	var para_inp = ["qiandao_time", "qiandao_tieba", "qiandao_bilibili", "qiandao_smzdm", "qiandao_hostloc", "qiandao_v2ex"];
	// collect data from checkbox
	for (var i = 0; i < para_chk.length; i++) {
		dbus[para_chk[i]] = E('_' + para_chk[i] ).checked ? '1':'0';
	}
	// data from other element
	for (var i = 0; i < para_inp.length; i++) {
		console.log(E('_' + para_inp[i] ).value)
		if (!E('_' + para_inp[i] ).value){
			dbus[para_inp[i]] = "";
		}else{
			dbus[para_inp[i]] = E('_' + para_inp[i]).value;
		}
	}

	//-------------- post dbus to dbus ---------------
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method":'qiandao_config.sh', "params":["start"], "fields": dbus};
	var success = function(data) {
		$('#footer-msg').text(data.result);
		$('#footer-msg').show();
		setTimeout("window.location.reload()", 1000);
	};
	$('#footer-msg').text('保存中……');
	$('#footer-msg').show();
	$('button').addClass('disabled');
	$('button').prop('disabled', true);
	$.ajax({
	  type: "POST",
	  url: "/_api/",
	  data: JSON.stringify(postData),
	  success: success,
	  dataType: "json"
	});
}


</script>
<div class="box">
	<div class="heading">自动签到 1.0.1<a href="#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
	<div class="content">
		<span class="col" style="line-height:30px;width:700px">
		Program:Carseason<br />
		Interface:Hikaru Chang (i@rua.moe)<br />
		本插件实现帮你自动签到，可用平台：百度贴吧、哔哩哔哩、什么值得买、V2EX、hostloc<br />
		关于本插件的BUG反馈以及建议：<a href="https://github.com/hikaruchang/qiandao-koolsoft" target="_blank"><u>Github</u></a> | <a href="mailto:i@rua.moe" target="_blank"><u>Email</u></a>
		</span>
	</div>
</div>
<div class="box" style="margin-top: 0px;">
	<div class="heading">配置</div>
	<hr>
	<div class="content">
		<div id="qiandao-fields"></div>
		<script type="text/javascript">
			$('#qiandao-fields').forms([
			{ title: '开启自动签到', name: 'qiandao_enable', type: 'checkbox', value: dbus.qiandao_enable == 1},
			{ title: '运行时间', name: 'qiandao_time', type:'select', options:[['3','3点'],['6','6点'],['9','9点'],['12','12点'],['15','15点'],['18','18点'],['21','21点'],['0','0点']],value: dbus.qiandao_time || "12", suffix: ' 默认:12点' },
			{ title: '哔哩哔哩', name: 'qiandao_bilibili', type: 'text', maxlen: 100, size: 50, value: dbus.qiandao_bilibili ||"",suffix: ' 请填写哔哩哔哩账号cookie。' },
			{ title: '百度贴吧', name: 'qiandao_tieba', type: 'text', maxlen: 100, size: 50, value: dbus.qiandao_tieba ||"",suffix: ' 请填写百度贴吧账号cookie。' },
			{ title: '什么值得买', name: 'qiandao_smzdm', type: 'text', maxlen: 100, size: 50, value: dbus.qiandao_smzdm ||"",suffix: ' 请填写什么值得买账号cookie。' },
			{ title: 'V2EX', name: 'qiandao_v2ex', type: 'text', maxlen: 100, size: 50, value: dbus.qiandao_v2ex ||"",suffix: ' 请填写V2EX账号cookie。' },
			{ title: 'hostloc', name: 'qiandao_hostloc', type: 'text', maxlen: 100, size: 50, value: dbus.qiandao_hostloc ||"",suffix: ' 请填写hostloc账号cookie。' },
			]);
			$('#_qiandao_enable').parent().parent().css("margin-left","-10px");
		</script>
	</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">init();</script>
</content>
