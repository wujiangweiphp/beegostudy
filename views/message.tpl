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
                    <input type="text" class="form-control" id="search-input" placeholder="" />
                </div>
                <a class="btn btn-default" id="seatch-btn">搜索</a>
            </form>
        </div>

        <!-- 添加留言区域 -->
        <div class="msgtype">
            <form class="form-inline" autocapitalize="none" onsubmit="return false;">
                <div class="form-group">
                    <textarea name="dd" id="message" cols="70" rows="3"></textarea>
                    <input type="hidden" value="0" id="data-id">
                </div>
                <a class="btn btn-default" id="add-btn">留言</a>
            </form>
        </div>
    </div>


    <!-- 内容区域 -->
    <div id="content">

    </div>
    <!-- 页码区域 -->
    <div id="page" class="page">

    </div>
</div>
<script type="text/javascript" src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>
<script src="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="/static/js/jquery.page.js"></script>
<!--JS部分-->
<script type="text/javascript">

    let InitMsg = window.InitMsg || {
        page: 0,
        current_page: 0,
        init: function () {
            const _that = this;
            //给留言按钮 添加保存事件
            $('#add-btn').click(function () {
                let content = $("#message").val();
                let id = $("#data-id").val();
                _that.save(content,id)
            });
            // 给搜索按钮 添加事件
            $("#seatch-btn").click(function () {
                let content = $("#search-input").val();
                _that.list(1, content, true);
            });
            $('#search-input').keyup(function (e) {
                if (e.keyCode == 13) {
                    //回车事件
                    $('#seatch-btn').click();
                }
            });
            // 给删除按钮 添加事件
            $("#content").on("click",".msg-del",function (){
                let id = $(this).parent("td").attr("data-id");
                _that.delMsg(id);
            });
            // 给编辑按钮 添加事件
            $("#content").on("click",".msg-edit",function () {
                let parent = $(this).parent("td");
                let id = parent.attr("data-id");
                let content = parent.siblings(".content").text();
                _that.editMsg(id, content);
            });
            _that.list(1, '', true)
        },
        save: function (content,id) {
            const _that = this;
            $.ajax({
                type: 'post',
                url: '/msg/addmsg',
                data: {
                    "content": content,
                    "id" : id
                },
                success: function (result) {
                    if (result.State > 0) {
                        alert(result.Message);
                        if (result.State == 501) {
                            location.href = "/user/login"
                        }
                    } else {
                        alert("留言成功");
                        //刷新列表
                        _that.list(1)
                        $('#data-id').val("0")
                    }
                }
            })
        },
        list: function (page, content, init) {
            const _that = this;
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
                        $("#content").html("");
                        $("#page").html("");
                    } else {
                        $("#content").html(_that.conbinHtml(result.Data.List));
                        if (init) {
                            _that.page = Math.ceil(result.Data.Count / 10);
                            $("#page").Page({
                                totalPages: _that.page,//分页总数
                                liNums: 7,//分页的数字按钮数(建议取奇数)
                                activeClass: 'activP', //active 类样式定义
                                callBack: function (page) {
                                    _that.current_page = page;
                                    _that.list(page, content);
                                }
                            });
                        }
                    }
                }
            })
        },
        conbinHtml: function (list) {
            let html_code = "<table class=\"table table-striped\">";
            html_code += "<tr>";
            html_code += "<th>留言者</th>";
            html_code += "<th>留言内容</th>";
            html_code += "<th>留言时间</th>";
            html_code += "<th>操作</th>";
            html_code += "</div>";
            for (let i in list) {
                html_code += "<tr>";
                html_code += "<td>" + list[i].Name + "</td>";
                html_code += "<td class='content'>" + list[i].Content + "</td>";
                html_code += "<td>" + list[i].CreateAt + "</td>";
                html_code += "<td data-id=\"" + list[i].Id + "\"><a class='msg-edit'> 编辑</a> | <a class='msg-del'> 删除 </a></td>";
                html_code += "</div>";
            }
            html_code += "</table>"
            return html_code
        },
        delMsg: function (id) {
            let _that = this;
            $.ajax({
                type: 'post',
                url: '/msg/delmsg',
                data: {
                    "id": id
                },
                success: function (result) {
                    if (result.State > 0) {
                        alert(result.Message);
                        if (result.State == 501) {
                            location.href = "/user/login"
                        }
                    } else {
                        alert("删除成功");
                        _that.list(1);
                    }
                }
            })
        },
        editMsg: function (id,content) {
            $('#message').val(content);
            $('#data-id').val(id);
        }
    };

    // 初始化
    $(function () {
        InitMsg.init();
    })

</script>
</body>
</html>
