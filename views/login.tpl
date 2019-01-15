<!DOCTYPE html>

<html>
<head>
    <title>首页 - 用户列表页面</title>
    <link rel="shortcut icon" href="/static/img/favicon.png" />
    <link rel="stylesheet" href="/static/bootstrap/css/bootstrap.css"/>
    <script type="text/javascript" src="/static/js/jquery-2.1.1.min.js"></script>
    <script type="text/javascript" src="/static/bootstrap/js/bootstrap.min.js"></script>
</head>
<body>
<div class="container">
    <div class="form-group">
        <label for="text">用户名:</label>
        <input type="text" class="form-control" id="name" placeholder="用户名">
    </div>
    <div class="form-group">
        <label for="text">密码:</label>
        <input type="text" class="form-control" id="pwd" placeholder="密码">
    </div>
    <div class="form-group">
        <button class="btn btn-primary" onclick="login()">登陆</button>
        <button class="btn btn-default" onclick="logout()">退出</button>
    </div>
    <div>
        <label id="status"></label>
    </div>
</div>
<!--JS部分-->
<script type="text/javascript">
    //登陆功能
    function login(){
        $.ajax({
            type:'post',
            url:'/Home/Login',
            data:{
                "name":$("#name").val(),
                "pwd":$("#pwd").val()
            },
            success:function(result){
                if(result.islogin==0){
                    $("#status").html("登陆成功")
                }else  if(result.islogin==1){
                    $("#status").html("用户名错误")
                } else if(result.islogin==2){
                    $("#status").html("密码错误")
                }
            }
        })
    }
    //登出功能
    function logout(){
        $.ajax({
            type:'post',
            url:'/Home/Logout',
            data:{},
            success:function(result){
                if(result.islogin){
                    $("#status").html("登出成功");
                }else {
                    $("#status").html("登出失败");
                }
            }
        })
    }
</script>
</body>
</html>