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
)

func main() {

	engine := gin.Default()
	cfg := config.Get()

	//engine.Use(middleware.GinLogger(), middleware.GinRecovery(true))
	routers.NewRouter(engine)

	var (
		err    error
	)


	if err = startHTTPServer(engine, cfg); err != nil {
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


