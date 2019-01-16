package controllers

import (
	"github.com/astaxie/beego"
	"goblog/models"
)

type MessageController struct {
	beego.Controller
}

func (c *MessageController) List() {
	msg :=  models.LeaveMessage{}
	limit,_ := c.GetInt("limit")
	page,_ := c.GetInt("page")
	content := c.Input().Get("content")
	response := ResponseJson{}
	response.Message = "ok"
	response.State = 0
	if messages, err:= msg.GetList(limit,page,content) ; err != nil {
		response.Message = err.Error()
		response.State = 500
	} else {
		response.Data = messages
	}
	c.Data["json"] = response
	c.ServeJSON()
	//c.TplName = "message.tpl"
}

func (c *MessageController) Index()  {
	c.TplName = "message.tpl"
}

func (c *MessageController)AddMsg()  {
	username := c.GetSession("Username")
	content := c.Input().Get("content")
	id, _ := c.GetInt("id",0)
	response := ResponseJson{}
	response.Message = "ok"
	response.State = 0
	if content == "" {
		response.Message = "留言内容不能为空"
		response.State = 500
		c.Data["json"] = response
		c.ServeJSON()
		return
	}
	if username == "" || username == nil {
		response.Message = "当前用户尚未登录，请先登录"
		response.State = 501
		c.Data["json"] = response
		c.ServeJSON()
		return
	}
	msg := models.LeaveMessage{}
	msg.Content = content
	msg.Id = id
	if id,err :=  msg.SaveMessage(username.(string)); err != nil {
		response.Message = "保存失败，请稍后再试"
		response.State = 503
	} else {
		response.Data = id
	}
	c.Data["json"] = response
	c.ServeJSON()
	return
}

func (c *MessageController)DelMsg() {
	username := c.GetSession("Username")
	id, _ := c.GetInt("id",0);
	response := ResponseJson{}
	response.Message = "ok"
	response.State = 0
	msg := models.LeaveMessage{}
	msg.Id = id
	if username == "" || username == nil {
		response.Message = "当前用户尚未登录，请先登录"
		response.State = 501
		c.Data["json"] = response
		c.ServeJSON()
		return
	}
	if err :=  msg.DelMsg(username.(string)); err != nil {
		response.Message = "删除失败，请稍后再试"
		response.State = 503
	}
	c.Data["json"] = response
	c.ServeJSON()
	return
}