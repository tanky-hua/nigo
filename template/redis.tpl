package cache

import (
	"encoding/json"
	"errors"
	"github.com/redis/go-redis/v9"
	"strconv"
	"time"
)

type (
	Redis interface {
		Del(keys ...string) error
		Get(key string) (string, error)
		GetWithJson(key string, val any) error
		IsNotFound(err error) bool
		Set(key string, val any, expire time.Duration) error
		SetNX(key string, val any, expire time.Duration) error
		SetByJson(key string, val any, expire time.Duration) error
		Decr(key string) error
		ZAdd(key string, members ...redis.Z) error
		ZAddWithExpire(key string, expire time.Duration, members ...redis.Z) error
		ZRange(key string, start, stop int64) ([]string, error)
		ZRangeWithScores(key string, start, stop int64) ([]RedisZ, error)
		ZRevRange(key string, start, stop int64) ([]string, error)
		ZRevRangeWithScores(key string, start, stop int64) ([]RedisZ, error)
		ZUnionStoreWithExpire(destKey string, expireTime time.Duration, aggregate string, keys ...string) error
		SetNotFound(key string) error
	}

	RedisClient struct {
		rds *redis.Client
	}

	RedisZ struct {
		Score       float64
		Member      interface{}
		MemberToInt int
	}
)

var (
	ErrorNotFound    = errors.New("record not found")
	ErrorNullValue   = errors.New("null value")
	valueNullDefault = "*"

	DefaultExpireTime = 15 * time.Minute
)

func NewRedis() Redis {
	return &RedisClient{
		rds: redisClient,
	}
}

func (c *RedisClient) Del(keys ...string) error {
	return c.rds.Del(redisContext, keys...).Err()
}

func (c *RedisClient) Get(key string) (string, error) {
	data, err := c.rds.Get(redisContext, key).Result()
	if err != nil {
		return "", err
	}
	return data, nil
}
func (c *RedisClient) GetWithJson(key string, v any) error {
	data, err := c.rds.Get(redisContext, key).Result()
	if err != nil {
		if errors.Is(err, redis.Nil) {
			return ErrorNotFound
		}
		return err
	}
	if data == valueNullDefault {
		return ErrorNullValue
	}
	return json.Unmarshal([]byte(data), v)

}

func (c *RedisClient) IsNotFound(err error) bool {
	return errors.Is(err, ErrorNotFound)
}

func (c *RedisClient) Set(key string, val any, expire time.Duration) error {
	return c.rds.Set(redisContext, key, val, expire).Err()
}
func (c *RedisClient) SetNX(key string, val any, expire time.Duration) error {
	return c.rds.SetNX(redisContext, key, val, expire).Err()
}

func (c *RedisClient) SetByJson(key string, val any, expire time.Duration) error {
	data, err := json.Marshal(val)
	if err != nil {
		return err
	}
	return c.rds.Set(redisContext, key, data, expire).Err()
}
func (c *RedisClient) Decr(key string) error {
	return c.rds.Decr(redisContext, key).Err()
}
func (c *RedisClient) ZAdd(key string, members ...redis.Z) error {
	return c.rds.ZAdd(redisContext, key, members...).Err()
}

func (c *RedisClient) ZRange(key string, start, stop int64) ([]string, error) {
	return c.rds.ZRange(redisContext, key, start, stop).Result()
}

func (c *RedisClient) ZRangeWithScores(key string, start, stop int64) ([]RedisZ, error) {
	res, err := c.rds.ZRangeWithScores(redisContext, key, start, stop).Result()
	if err != nil {
		return nil, err
	}
	if len(res) == 0 {
		return nil, ErrorNotFound
	}
	var data = make([]RedisZ, 0, len(res))
	for _, i := range res {
		m, _ := strconv.Atoi(i.Member.(string))
		data = append(data, RedisZ{
			Score:       i.Score,
			Member:      i.Member,
			MemberToInt: m,
		})
	}
	return data, nil
}

func (c *RedisClient) ZRevRange(key string, start, stop int64) ([]string, error) {
	return c.rds.ZRevRange(redisContext, key, start, stop).Result()
}

func (c *RedisClient) ZRevRangeWithScores(key string, start, stop int64) ([]RedisZ, error) {
	res, err := c.rds.ZRevRangeWithScores(redisContext, key, start, stop).Result()
	if err != nil {
		return nil, err
	}
	if len(res) == 0 {
		return nil, ErrorNotFound
	}
	var data = make([]RedisZ, 0, len(res))
	for _, i := range res {
		m, _ := strconv.Atoi(i.Member.(string))
		data = append(data, RedisZ{
			Score:       i.Score,
			Member:      i.Member,
			MemberToInt: m,
		})
	}
	return data, nil
}

func (c *RedisClient) SetNotFound(key string) error {
	return c.rds.SetNX(redisContext, key, valueNullDefault, 60*time.Second).Err()
}

func (c *RedisClient) ZAddWithExpire(key string, expire time.Duration, members ...redis.Z) error {
	err := c.rds.ZAdd(redisContext, key, members...).Err()
	if err != nil {
		return err
	}
	return c.rds.Expire(redisContext, key, expire).Err()
}

func (c *RedisClient) ZUnionStoreWithExpire(destKey string, expireTime time.Duration, aggregate string, keys ...string) error {
	err := redisClient.ZUnionStore(redisContext, destKey, &redis.ZStore{
		Keys:      keys,
		Aggregate: aggregate,
	}).Err()
	if err != nil {
		return err
	}
	return redisClient.Expire(redisContext, destKey, expireTime).Err()

}
