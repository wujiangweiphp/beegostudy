package controllers

import (
	"github.com/astaxie/beego"
)

type MainController struct {
	beego.Controller
}

func (c *MainController) Get() {
	username := c.GetSession("Username")
	if username == nil {
		c.Redirect("/user/login",302)
		return
	}
	c.Data["Username"] = username
	c.TplName = "index.tpl"
}
