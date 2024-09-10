package service

import (
	"context"
	"go.uber.org/zap"
	"{{.ProjectName}}/model"
	"{{.ProjectName}}/repository/db"
	"{{.ProjectName}}/repository/cache"
	"{{.ProjectName}}/pkg/mr"
)

type UserService struct {
	cache     cache.Cache //使用缓存
	dao       *db.UserDao //不使用缓存，直接查询数据库
}

func NewUserService() *UserService {
	return &UserService{
		cache:     cache.NewUserCache(),
		dao:       db.NewUserDao(context.Background()),
	}
}

func (c *UserService) Get(userID uint) (*model.User, error) {
	/*
    	不走缓存，直接查询数据库
    	resp, err := c.dao.Get(userID)
    */

	// 走缓存查询
	resp, err := c.cache.Get(userID)
	if err != nil {
		zap.S().Error(err)
		return nil, err
	}
	if resp == nil {
		return nil, nil
	}
	return resp.(*model.User), err
}



func (c *UserService) List(req model.UserListRequest) ([]*model.User, error) {
	list, err := c.cache.List(req, false, int(req.Page), int(req.PageSize))
	if err != nil {
		zap.S().Error(err)
		return nil, err
	}
	return list.([]*model.User), err
}

func (c *UserService)ListByUserID(userIDs []uint)([]*model.User,error){
	// 并发走缓存查询
	data, err := mr.MapReduce(func(source chan<- interface{}) {
		for _, id := range userIDs {
			source <- id
		}
	}, func(item interface{}, writer mr.Writer, cancel func(error)) {
		id := item.(uint)
		user, err := c.Get(id)
		if err != nil {
			cancel(err)
			return
		}
		if user != nil {
			writer.Write(user)
		}

	}, func(pipe <-chan interface{}, writer mr.Writer, cancel func(error)) {
		var list []*model.User
		for v := range pipe {
			list = append(list, v.(*model.User))
		}
		writer.Write(list)
	})
	if err != nil {
		return nil, err
	}

	return data.([]*model.User), nil
}