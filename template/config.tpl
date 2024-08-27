package config

import (
    {{.importStr}}
)

var config = &Config{}

type Config struct {
	Service struct {
    		Name          string `yaml:"name"`
    		Port          int    `yaml:"port"`
    		Mode          string `yaml:"mode"`

    		Token struct {
    			AccessTokenExpireTime  int `yaml:"accessTokenExpireTime"`
    			RefreshTokenExpireTime int `yaml:"refreshTokenExpireTime"`
    		} `yaml:"token"`
    }
    	MySQL struct {
    		Host     string `yaml:"host"`
    		Port     int    `yaml:"port"`
    		User     string `yaml:"user"`
    		Password string `yaml:"password"`
    		DB      string `yaml:"db"`
    	} `yaml:"mysql"`

    	Redis struct {
    		Host     string `yaml:"host"`
    		Port     int    `yaml:"port"`
    		User     string `yaml:"user"`
    		Password string `yaml:"password"`
    		DB      int    `yaml:"db"`
    	} `yaml:"redis"`
}

func init() {
	viper.SetConfigFile("./config/config.yaml")

	err := viper.ReadInConfig()
	if err != nil {
		panic(err)
	}
	if err = viper.Unmarshal(config); err != nil {
		panic(err)
	}

	viper.WatchConfig()
	viper.OnConfigChange(func(e fsnotify.Event) {
		if err := viper.Unmarshal(config); err != nil {
			zap.S().Error(err)
		}

	})
}

func Get()*Config{
	return config
}