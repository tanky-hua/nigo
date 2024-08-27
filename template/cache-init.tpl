package cache

import (
	{{.importStr}}
)

var redisClient *redis.Client
var redisContext = context.Background()

func init() {
	cfg := config.Get()
	host := cfg.Redis.Host
	port := cfg.Redis.Port
	userName := cfg.Redis.User
	password := cfg.Redis.Password
	db := cfg.Redis.DB
	zap.S().Infof("redis host: %s, port: %d, username: %s, password: %s, db: %d", host, port, userName, password, db)
	client := redis.NewClient(&redis.Options{
		Addr:     fmt.Sprintf("%s:%d", host, port),
		Username: userName,
		Password: password,
		DB:       db,
	})

	_, err := client.Ping(redisContext).Result()
	if err != nil {
		zap.S().Error(err)
		panic(err)
	}
	redisClient = client

}
