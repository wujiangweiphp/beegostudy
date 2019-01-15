<!DOCTYPE html>
<html>
<head>
    <title>留言板</title>
    <link href="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="/static/css/jquery.page.css">
    <style>
        .msgtype {
            width: 80%;
            margin: 20px auto
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row msgtype">
        go语言留言板
    </div>
    <div class="row msgtype">
        <!-- 搜索留言  -->
        <div id="search" class="col-10">
            <form class="form-inline" autocapitalize="off" onsubmit="return false;">
                <div class="form-group">
                    <label for="search-input">留言内容：</label>
                    <input type="text" class="form-control" id="search-input" placeholder="">
                </div>
                <a class="btn btn-default" id="seatch-btn">搜索</a>
            </form>
        </div>

        <!-- 添加留言区域 -->
        <div class="msgtype">
            <form class="form-inline" autocapitalize="none" onsubmit="return false;">
                <div class="form-group">
                    <textarea name="dd" id="message" cols="70" rows="3"></textarea>
                </div>
                <a class="btn btn-default" id="add-btn">留言</a>
            </form>
        </div>
    </div>


    <!-- 内容区域 -->
    <div id="content">

    </div>
    <!-- 页码区域 -->
    <div id="page" class="row page pagingUl">

    </div>
</div>
<script type="text/javascript" src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>
<script src="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="/static/js/jquery.page.js"></script>
<!--JS部分-->
<script type="text/javascript">

    var _PAGE = 0;
    var _CURRENT_PAGE = 1

    $(function () {

        $('#add-btn').click(function () {
            $.ajax({
                type: 'post',
                url: '/msg/addmsg',
                data: {
                    "content": $("#message").val()
                },
                success: function (result) {
                    if (result.State > 0) {
                        alert(result.Message)
                        if (result.State == 501) {
                            location.href = "/user/login"
                        }
                    } else {
                        alert("留言成功");
                        //刷新列表
                        reflashList(1)
                    }
                }
            })
        });
        $("#seatch-btn").click(function () {
            var content = $("#search-input").val();
            reflashList(_CURRENT_PAGE, content)
        });
        reflashList(1)
    })

    function combinHtml(list) {
        var html_code = "<table class=\"table table-striped\">";
        html_code += "<tr>";
        html_code += "<th>留言者</th>";
        html_code += "<th>留言内容</th>";
        html_code += "<th>留言时间</th>";
        html_code += "</div>";
        for (var i in list) {
            html_code += "<tr>";
            html_code += "<td>" + list[i].Name + "</td>";
            html_code += "<td>" + list[i].CreateAt + "</td>";
            html_code += "<td>" + list[i].Content + "</td>";
            html_code += "</div>";
        }
        html_code += "</table>"
        return html_code
    }

    //登陆功能
    function reflashList(page, content) {
        content = content || "";
        $.ajax({
            type: 'get',
            url: '/msg/list',
            data: {
                "content": content,
                "limit": 10,
                "page": page
            },
            success: function (result) {
                if (result.State > 0) {
                    alert(result.Message)
                } else {
                    _CURRENT_PAGE = page;
                    $("#content").html(combinHtml(result.Data.List));
                    console.log(result.Data);
                    _PAGE = Math.ceil(result.Data.Count / 10);
                    $("#page").Page({
                        totalPages: _PAGE,//分页总数
                        liNums: 7,//分页的数字按钮数(建议取奇数)
                        activeClass: 'activP', //active 类样式定义
                        callBack: function (page) {
                            reflashList(page)
                        }
                    });
                }
            }
        })
    }

    function initPage(page) {
        if (page == _PAGE) {
            console.log('page loaded')
        } else {
            reflashList(page)
        }
    }

    function login() {
        location.href = "/user/register"
    }
</script>
</body>
</html>
