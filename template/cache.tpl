package cache

import (
	"encoding/json"
	"errors"
	"{{.ProjectName}}/pkg/singleflight"
)

type (
	Cache interface {
		Get(id uint) (any, error)
		List(params any, desc bool, page int, pageSize int) (any, error)
		Del(key uint) error
	}

	cacheClient struct {
		rds     Redis
		barrier singleflight.SingleFlight // 单次查询数据库，防止缓存击穿
	}
)

func newCacheClient() *cacheClient {
	return &cacheClient{
		rds:     NewRedis(),
		barrier: singleflight.NewSingleFlight(),
	}
}

func (c *cacheClient) doGetCache(key string, v any) error {
	return c.rds.GetWithJson(key, v)
}

// doTake 获取缓存，不存在则查询db，并设置缓存
func (c *cacheClient) doTake(v any, key string, isSetNotFound bool, getCache func(v any) error, queryDB func(v any) error, setCache func(v any) error) error {
	val, fresh, err := c.barrier.DoEx(key, func() (any, error) {
		if err := getCache(v); err != nil {
			if errors.Is(err, ErrorNullValue) {
				return nil, ErrorNullValue
			} else if !c.rds.IsNotFound(err) {
				return nil, err
			}

			// 缓存不存在，查询db
			if err = queryDB(v); errors.Is(err, ErrorNotFound) {
				if isSetNotFound {
					// 未查到数据，设置空值
					if err = c.rds.SetNotFound(key); err != nil {
						return nil, err
					}
				}
				return nil, ErrorNotFound
			} else if err != nil {
				return nil, err
			}

			// 查到数据，存储到缓存redis
			if err = setCache(v); err != nil {
				return nil, err
			}

		}

		return json.Marshal(v)
	})
	if err != nil {
		return err
	}

	if fresh {
		return nil
	}

	return json.Unmarshal(val.([]byte), v)
}

func parseToJson(source any, v any) error {
	d, err := json.Marshal(source)
	if err != nil {
		return err
	}
	return json.Unmarshal(d, v)
}
