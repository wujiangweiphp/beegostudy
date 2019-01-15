package models

import (
	"errors"
	"github.com/astaxie/beego/orm"
	"log"
	"time"
)

type LeaveMessage struct {
	Id       int
	Uid      int
	Content  string
	Status   int
	CreateAt time.Time `orm:"type(datetime)"`
	UpdateAt time.Time `orm:"type(datetime)"`
}

type MsgData struct {
	Id int
	Content string
	Name string
	CreateAt time.Time
}
type MessageList struct {
	Count int
	List  []MsgData
}

func init() {
	orm.RegisterModel(new(LeaveMessage))
}

/**
  添加留言
 */
func (msg LeaveMessage) SaveMessage(username string) (int, error) {
	o := orm.NewOrm()
	if username == "" {
		return 0, errors.New("用户未登录，请先登录")
	}
	user := User{Name: username}
	if err := o.Read(&user, "name"); err != nil {
		log.Printf("read user %v error,error info is %v \n", msg, err)
		return 0, errors.New("用户不存在")
	}

	msg.Uid = user.Id
	msg.Status = 1
	msg.CreateAt = time.Now()
	msg.UpdateAt = time.Now()

	if id, err := o.Insert(&msg); err != nil {
		log.Printf("insert user %v error,error info is %v \n", msg, err)
		return 0, errors.New("保存失败，请稍后再试")
	} else {
		return int(id), nil
	}
}

/**
   搜索留言 分页
   1. 联表查询记录列表
   2. 筛选符合条件的结果
   3. 加入分页
 */

func (msg LeaveMessage) GetList(limit, page int, content string) (MessageList, error) {
	qb, _ := orm.NewQueryBuilder("mysql")
	qb2, _ := orm.NewQueryBuilder("mysql")
	if limit == 0 {
		limit = 20
	}
	offset := 0
	if page > 0 {
		offset = (page - 1) * limit
	}
	qb.Select("count(*) ").
		From("leave_message").
		LeftJoin("user").On("leave_message.uid = user.id")
	if content != "" {
		qb.Where("content like '%"+content+"%' ")
	}

	qb2.Select("user.name,leave_message.id,leave_message.content,leave_message.create_at").
		From("leave_message").
		LeftJoin("user").On("leave_message.uid = user.id")
	if content != ""{
		qb2.Where("content like '%"+content+"%' ")
	}
	qb2.OrderBy("leave_message.id desc").Limit(limit).Offset(offset)

	sqlCount := qb.String()
	sqlRows := qb2.String()

	o := orm.NewOrm()
	var messageList MessageList
	var count []int
	var msgDatas []MsgData
	if num, err := o.Raw(sqlCount).QueryRows(&count); err != nil || num == 0 {
		return MessageList{}, errors.New("查询失败，请稍后再试")
	}
	messageList.Count = count[0]
	if num, err := o.Raw(sqlRows).QueryRows(&msgDatas); err != nil || num == 0 {
		return MessageList{}, errors.New("查询失败，请稍后再试")
	}
	messageList.List = msgDatas
	return messageList, nil
}
