package cache

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"github.com/redis/go-redis/v9"
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
	err := c.doTake(v, key, true,
		func(v any) error {
			return c.rds.GetWithJson(key, v)
		},
		func(v any) error {
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
		},
		func(v any) error {
			return c.rds.SetByJson(key, v, DefaultExpireTime)
		},
	)
	if errors.Is(err, ErrorNotFound) || errors.Is(err, ErrorNullValue) {
		return nil, nil
	}
	return v, err
}

func (c *UserCache) List(params any, desc bool, page int, pageSize int) (any, error) {
        // 需要另外传参的请解析断言解析params
        	req := params.(model.UserListRequest)

        	var (
        		v   []*model.User
        		key = "cache:user:list"
        	)
        	cursor := int64((page - 1) * pageSize)
        	if cursor < 0 {
        		cursor = 0
        	}

        	size := int64(pageSize*page) - 1
        	if size <= 0 {
        		size = -1
        	}

        	err := c.doTake(&v, key, false,
        		func(v any) error { // 获取redis数据
        			var data []RedisZ
        			var err error
        			if desc {
        				data, err = c.rds.ZRevRangeWithScores(key, cursor, size)
        			} else {
        				data, err = c.rds.ZRangeWithScores(key, cursor, size)
        			}
        			if err != nil {
        				return err
        			}
        			if len(data) == 0 {
        				// 此处必须返回ErrorNotFound错误，用于后续判断
        				return ErrorNotFound
        			}

        			var resp []*model.User
        			for _, val := range data {
        				d, err := c.Get(uint(val.MemberToInt))
        				if err != nil {
        					return err
        				}
        				resp = append(resp, d.(*model.User))
        			}
        			return parseToJson(resp, v)
        		},
        		func(v any) error { // 获取mysql数据
        			data, err := c.dao.List(req)
        			if err != nil {
        				return err
        			}
        			if len(data) == 0 {
        				// 此处必须返回ErrorNotFound错误，用于后续判断
        				return ErrorNotFound
        			}
        			return parseToJson(data, v)

        		},
        		func(v any) error { // 添加缓存
        			var ids []redis.Z
        			for _, val := range *v.(*[]*model.User) {
        				ids = append(ids, redis.Z{
        					Score:  float64(val.UserID),
        					Member: val.UserID,
        				})

        				err := c.rds.SetByJson(c.userKey(val.UserID), val, DefaultExpireTime)
        				if err != nil {
        					zap.S().Error(err)
        					return err
        				}
        			}
        			return c.rds.ZAddWithExpire(key, 1*time.Hour, ids...)
        		},
        	)
        	if err != nil {
        		if errors.Is(err, ErrorNotFound) {
        			return v, nil
        		}
        		return nil, err
        	}

        	return v, nil
}

func (c *UserCache) Del(id uint) error {
	key := c.userKey(id)
	return c.rds.Del(key)
}
