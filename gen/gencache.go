package gen

import (
	"goctl/template"
)

var (
	cacheTemplate, _        = template.TemplateFs.ReadFile("cache.tpl")
	redisTemplate, _        = template.TemplateFs.ReadFile("redis.tpl")
	singleFlightTemplate, _ = template.TemplateFs.ReadFile("singleflight.tpl")
	cacheInitTemplate, _    = template.TemplateFs.ReadFile("cache-init.tpl")
	userCacheTemplate, _    = template.TemplateFs.ReadFile("cache-user-test.tpl")
)

func genCache(dir string, projectName string) error {
	err := genFile(&Config{
		dir:             dir,
		targetDir:       "/repository/cache/",
		fileName:        "cache.go",
		templateName:    "cacheTemplate",
		templateFile:    "cache.tpl",
		builtinTemplate: string(cacheTemplate),
		data: map[string]string{
			"ProjectName": projectName,
		},
	})
	if err != nil {
		return err
	}
	err = genFile(&Config{
		dir:             dir,
		targetDir:       "/repository/cache/",
		fileName:        "redis.go",
		templateName:    "redisTemplate",
		templateFile:    "redis.tpl",
		builtinTemplate: string(redisTemplate),
		data: map[string]string{
			"ProjectName": projectName,
		},
	})
	if err != nil {
		return err
	}

	err = genFile(&Config{
		dir:             dir,
		targetDir:       "/repository/cache/",
		fileName:        "user.go",
		templateName:    "userCacheTemplate",
		templateFile:    "cache-user-test.tpl",
		builtinTemplate: string(userCacheTemplate),
		data: map[string]string{
			"ProjectName": projectName,
		},
	})
	if err != nil {
		return err
	}

	err = genFile(&Config{
		dir:             dir,
		targetDir:       "/repository/cache/",
		fileName:        "init.go",
		templateName:    "cacheInitTemplate",
		templateFile:    "cache-init.tpl",
		builtinTemplate: string(cacheInitTemplate),
		data: map[string]string{
			"ProjectName": projectName,
		},
	})
	if err != nil {
		return err
	}

	return nil
}
