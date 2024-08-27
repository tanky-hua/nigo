package routers

import(
	"github.com/gin-gonic/gin"
	controllers "{{.ProjectName}}/api/v1"
)

func NewRouter(r *gin.Engine) {
	// 设置multipart内存限制，如果文件很大，请调整这个值
	r.MaxMultipartMemory = 200 << 20 // 200 MiB
	r.Static("/view", "./static/view")
	v1 := r.Group("api/v1")

	{
		var userController = controllers.NewUserController()
		v1.GET("/user/get", userController.Get)
	}
}
