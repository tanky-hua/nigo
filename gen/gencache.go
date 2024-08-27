package gen

import "fmt"

func genCache(dir string) error {
	err := genFile(&Config{
		dir:             dir,
		tagetDir:        "/repository/cache/",
		fileName:        "cache.go",
		templateName:    "cacheTemplate",
		templateFile:    "cache.tpl",
		builtinTemplate: "",
		data:            nil,
	})
	if err != nil {
		return err
	}
	err = genFile(&Config{
		dir:             dir,
		tagetDir:        "/repository/cache/",
		fileName:        "redis.go",
		templateName:    "redisTemplate",
		templateFile:    "redis.tpl",
		builtinTemplate: "",
		data:            nil,
	})
	if err != nil {
		return err
	}

	err = genFile(&Config{
		dir:             dir,
		tagetDir:        "/repository/cache/",
		fileName:        "singleflight.go",
		templateName:    "singleFlightTemplate",
		templateFile:    "singleflight.tpl",
		builtinTemplate: "",
		data:            nil,
	})
	if err != nil {
		return err
	}

	err = genFile(&Config{
		dir:             dir,
		tagetDir:        "/repository/cache/",
		fileName:        "user.go",
		templateName:    "userCacheTemplate",
		templateFile:    "cache-user-test.tpl",
		builtinTemplate: "",
		data: map[string]string{
			"ProjectName": "goctl-project",
		},
	})
	if err != nil {
		return err
	}

	importStr := `	"context"
	"fmt"
	"github.com/redis/go-redis/v9"
	"go.uber.org/zap"
	"%s/config"`
	err = genFile(&Config{
		dir:             dir,
		tagetDir:        "/repository/cache/",
		fileName:        "init.go",
		templateName:    "cacheInitTemplate",
		templateFile:    "cache-init.tpl",
		builtinTemplate: "",
		data: map[string]string{
			"importStr": fmt.Sprintf(importStr, "goctl-project"),
		},
	})
	if err != nil {
		return err
	}

	return nil
}
