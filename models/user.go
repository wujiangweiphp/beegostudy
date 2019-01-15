package models

import (
	"fmt"
	"github.com/astaxie/beego/orm"
	_ "github.com/go-sql-driver/mysql"
)

type User struct {
	Id       int
	Name     string `orm:"size(50)"`
	Password string `orm:"size(50)"`
}

func init() {
	orm.RegisterDriver("mysql", orm.DRMySQL)
	orm.RegisterDataBase("default", "mysql", "root:@/my_blog?charset=utf8", 30)
	orm.RegisterModel(new(User))
}

func (user User) GetList(start, limit int) {
	//orm.Debug = true
	o := orm.NewOrm()
	user.Id = 23
	err := o.Read(&user)
	fmt.Println(err)
	fmt.Println(user)
}

/**
   查询单个用户信息
 */
func (user User) GerOne(id int) User {
	o := orm.NewOrm()
	user.Id = id
	if err := o.Read(&user); err != nil || user.Name == "" {
		return User{}
	} else {
		return user
	}
}

/**
    添加一条数据
 */
func (user User) SaveOne() (int, error) {
	o := orm.NewOrm()
	if created, id, err := o.ReadOrCreate(&user,"name"); err == nil {
		if created {
			return int(id) , nil
		} else {
			//更新
			user.Id = int(id)
			if num, err := o.Update(&user); err == nil && num > 0 {
				return int(id) , nil
			}
		}
	}
	return 0 , fmt.Errorf("save fail")
}
