package cache

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"{{.ProjectName}}/model"
	"{{.ProjectName}}/repository/db"
)

type UserCache struct {
	*cacheClient
	dao *db.UserDao
}

func NewUserCache() *UserCache {
	return &UserCache{
		cacheClient: newCacheClient(),
		dao:         db.NewUserDao(context.Background()),
	}
}

func (c *UserCache) userKey(userID uint) string {
	return fmt.Sprintf("cache:user:%d", userID)
}

func (c *UserCache) Get(id uint) (any, error) {
	key := c.userKey(id)
	v := new(model.User)
	err := c.doTake(v, key, func(v any) error {
		return c.rds.GetWithJson(key, v)
	}, func(v any) error {
		data, err := c.dao.GetByID(id)
		if err != nil {
			return err
		}
		if data == nil {
			// 此处必须返回ErrorNotFound错误，用于后续判断
			return ErrorNotFound
		}
		d, _ := json.Marshal(data)
		return json.Unmarshal(d, v)
	}, func(v any) error {
		return c.rds.SetByJson(key, v, DefaultExpireTime)
	})
	if errors.Is(err, ErrorNotFound) || errors.Is(err, ErrorNullValue) {
		return nil, nil
	}
	return v, err
}

func (c *UserCache) List(params any, desc bool, page int, pageSize int) (any, error) {
	return nil,nil

}

func (c *UserCache) Del(id uint) error {
	key := c.userKey(id)
	return c.rds.Del(key)
}
