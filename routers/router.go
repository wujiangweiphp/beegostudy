package routers

import (
	"goblog/controllers"
	"github.com/astaxie/beego"
)

func init() {
    beego.Router("/", &controllers.MainController{})

    beego.Router("/user/register", &controllers.UserController{},"get:Register")
    beego.Router("/user/saveUser", &controllers.UserController{},"post:SaveUser")

    beego.Router("/user/login", &controllers.UserController{},"get:Login")
    beego.Router("/user/sign", &controllers.UserController{},"post:Sign")
    beego.Router("/user/logout", &controllers.UserController{},"post:Logout")

    beego.Router("/msg/", &controllers.MessageController{},"get:Index")
    beego.Router("/msg/list", &controllers.MessageController{},"get:List")
    beego.Router("/msg/addmsg", &controllers.MessageController{},"post:AddMsg")
}
