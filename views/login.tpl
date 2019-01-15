<!DOCTYPE html>

<html>
<head>
    <title>用户登录</title>
    <link href="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script type="text/javascript" src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
<div class="container">
    <div class="form-group">
        <label for="text">用户名:</label>
        <input type="text" class="form-control" id="name" placeholder="用户名">
    </div>
    <div class="form-group">
        <label for="text">密码:</label>
        <input type="password" class="form-control" id="password" placeholder="密码">
    </div>
    <div class="form-group">
        <button class="btn btn-primary" onclick="login()">登陆</button>
        <button class="btn btn-primary" onclick="register()">注册</button>
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
            url:'/user/sign',
            data:{
                "name":$("#name").val(),
                "password":$("#password").val()
            },
            success:function(result){
                if(result.State > 0){
                    alert(result.Message)
                }else {
                    alert("登录成功");
                    location.href = "/"
                }
            }
        })
    }

    function register() {
        location.href = "/user/register"
    }
</script>
</body>
</html>