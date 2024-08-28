package main

import (
	"cmp"
	"fmt"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"os"
	"os/signal"
	"syscall"
	"{{.ProjectName}}/config"
	"{{.ProjectName}}/routers"
	"{{.ProjectName}}/middleware"
	"{{.ProjectName}}/pkg/logger"
	"time"
)

func main() {
	InitLogger()

	engine := gin.Default()
	cfg := config.Get()

	engine.Use(middleware.GinLogger(), middleware.GinRecovery(true))
	routers.NewRouter(engine)

	if err := startHTTPServer(engine, cfg); err != nil {
		zap.S().Fatalw("服务器启动失败", "error", err)
	}

	// 捕获中断信号，优雅地关闭服务
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM, syscall.SIGTERM, syscall.SIGINT)
	<-c
	//关闭日志记录器和其它资源
	zap.S().Info("正在关闭服务...")

}

// 启动HTTP服务器
func startHTTPServer(engine *gin.Engine, cfg *config.Config) error {
	port := cmp.Or(cfg.Service.Port, 80)
	zap.S().Infof("启动端口：%d", port)
	return engine.Run(fmt.Sprintf(":%d", port))
}


func InitLogger() {
	// 1. 配置log参数
	conf := logger.LogConfigs{
		LogLevel:          "debug",                                  // 输出日志级别 "debug" "info" "warn" "error"
		LogFormat:         "json",                                   // 输出日志格式 logfmt, json
		LogPath:           "./logs",                                 // 输出日志文件位置
		LogFileName:       time.Now().Format("2006-01-02") + ".log", // 输出日志文件名称
		LogFileMaxSize:    100,                                      // 输出单个日志文件大小，单位MB
		LogFileMaxBackups: 20,                                       // 输出最大日志备份个数
		LogMaxAge:         365,                                      // 日志保留时间，单位: 天 (day)
		LogCompress:       false,                                    // 是否压缩日志
		LogStdout:         true,                                     // 是否输出到控制台
	}
	// 2. 初始化log
	if err := logger.InitLogger(conf); err != nil {
		panic(err)
	}
}
