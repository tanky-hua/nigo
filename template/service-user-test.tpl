package service

import (
	"context"
	"go.uber.org/zap"
	"{{.ProjectName}}/model"
	"{{.ProjectName}}/repository/db"
	"{{.ProjectName}}/repository/cache"
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
