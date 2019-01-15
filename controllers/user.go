package controllers

import (
	"github.com/astaxie/beego"
	"goblog/models"
)

type UserController struct {
	beego.Controller
}

type ResponseJson struct {
	State int
	Message string
	Data int
}

func (c *UserController) Get() {
	user := models.User{}
	data := user.GerOne(23)
	c.Data["Website"] = data.Name
	c.Data["Email"] = data.Password
	c.TplName = "index.tpl"
}

func (c *UserController) Register() {
	c.TplName = "register.tpl"
}

func (c *UserController) SaveUser() {
	user := models.User{}
	user.Name = c.Input().Get("name")
	user.Password = c.Input().Get("password")

	response := ResponseJson{State:0,Message:"ok"}
	if id, err := user.SaveOne(); err != nil {
		response.State = 500
		response.Message = "保存失败，请稍后再试"
	} else {
		response.Data = id
	}
	c.Data["json"] = response
	c.ServeJSON()

	//c.Ctx.WriteString(user.Name + " : " + user.Password)
	//return
}

func (c *UserController) Login() {
	c.TplName = "login.tpl"
}
