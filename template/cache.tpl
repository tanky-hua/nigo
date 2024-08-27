package cache

import (
	"encoding/json"
	"errors"
)

type (
	Cache interface {
		Get(id uint) (any, error)
		List(params any, desc bool, page int, pageSize int) (any, error)
		Del(key uint) error
	}

	cacheClient struct {
		rds     Redis
		barrier SingleFlight // 单次查询数据库，缓存击穿
	}
)

func newCacheClient() *cacheClient {
	return &cacheClient{
		rds:     NewRedis(),
		barrier: NewSingleFlight(),
	}
}

func (c *cacheClient) doGetCache(key string, v any) error {
	return c.rds.GetWithJson(key, v)
}

// doTake 获取缓存，不存在则查询db，并设置缓存
func (c *cacheClient) doTake(v any, key string, getCache func(v any) error, query func(v any) error, cacheVal func(v any) error) error {
	val, fresh, err := c.barrier.DoEx(key, func() (any, error) {
		if err := getCache(v); err != nil {
			if errors.Is(err, ErrorNullValue) {
				return nil, ErrorNullValue
			} else if !c.rds.IsNotFound(err) {
				return nil, err
			}

			// 缓存不存在，查询db
			if err = query(v); errors.Is(err, ErrorNotFound) {
				// 未查到数据，设置空值
				if err = c.rds.SetNotFound(key); err != nil {
					return nil, err
				}
				return nil, ErrorNotFound
			} else if err != nil {
				return nil, err
			}

			// 查到数据，存储到缓存redis
			if err = cacheVal(v); err != nil {
				return nil, err
			}

			d, _ := json.Marshal(v)
			err = json.Unmarshal(d, v)
			if err != nil {
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
