package api

import(
    	"github.com/gin-gonic/gin"
    	"net/http"
    	"go.uber.org/zap"
    	"{{.ProjectName}}/model"
    	e "{{.ProjectName}}/pkg/code"
)
type baseController struct {
}

// RespSuccess 操作成功返回
func (b *baseController) RespSuccess(ctx *gin.Context, data interface{}) {
	ctx.JSON(http.StatusOK, &model.Response{
		Code: e.SUCCESS.Int(),
		Msg:  e.SUCCESS.String(),
		Data: data,
	})
}

// RespSuccessPage 分页返回
func (b *baseController) RespSuccessPage(ctx *gin.Context, data interface{}, count int) {
	ctx.JSON(http.StatusOK, &model.Response{
		Code: e.SUCCESS.Int(),
		Msg:  e.SUCCESS.String(),
		Data: &model.ResponsePage{
			Count: count,
			List:  data,
		},
	})
}

// RespError 操作失败返回
func (b *baseController) RespError(ctx *gin.Context, data interface{}, code e.StatusCode) {
	if code == e.InvalidParams {
		//参数检验失败的打印，其他的错误调用层打印
		zap.S().Error("resp error,code:", code, " data:", data)
	}
	ctx.JSON(http.StatusOK, &model.Response{
		Code: code.Int(),
		Msg:  code.String(),
		Data: nil,
	})
}
