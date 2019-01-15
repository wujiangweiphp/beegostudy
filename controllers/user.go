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


func (c *UserController) Register() {
	c.TplName = "register.tpl"
}

func (c *UserController) SaveUser() {
	user := models.User{}
	user.Name = c.Input().Get("name")
	user.Password = c.Input().Get("password")

	response := ResponseJson{State:0,Message:"ok"}
	if user.Name == "" || user.Password == ""{
		response.State = 500
		response.Message = "用户名或密码不能为空"
	}else {
		if id, err := user.SaveOne(); err != nil {
			response.State = 500
			response.Message = "保存失败，请稍后再试"
		} else {
			response.Data = id
		}
	}
	c.Data["json"] = response
	c.ServeJSON()

	//c.Ctx.WriteString(user.Name + " : " + user.Password)
	//return
}

func (c *UserController) Login() {
	c.TplName = "login.tpl"
}

func (c *UserController) Sign() {
	user := models.User{}
	user.Name = c.Input().Get("name")
	user.Password = c.Input().Get("password")

	response := ResponseJson{State:0,Message:"ok"}
	if user.Name == "" || user.Password == ""{
		response.State = 500
		response.Message = "用户名或密码不能为空"
	}else {
		if id,err := user.GerOne(); err != nil || id == 0 {
			response.State = 500
			response.Message = err.Error()
		} else {
			c.SetSession("Username",user.Name)
		}
	}
	c.Data["json"] = response
	c.ServeJSON()
}


func (c *UserController) Logout() {
	c.DelSession("Username")
	response := ResponseJson{State:0,Message:"ok"}
	c.Data["json"] = response
	c.ServeJSON()
}