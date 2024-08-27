package api

import(
    {{.importStr}}
)
type baseController struct {
}

// RespSuccess 操作成功返回
func (b *baseController) RespSuccess(ctx *gin.Context, data interface{}) {
	ctx.JSON(http.StatusOK, &model.Response{
		Code: code.SUCCESS.Int(),
		Msg:  code.SUCCESS.String(),
		Data: data,
	})
}

// RespSuccessPage 分页返回
func (b *baseController) RespSuccessPage(ctx *gin.Context, data interface{}, count int) {
	ctx.JSON(http.StatusOK, &model.Response{
		Code: code.SUCCESS.Int(),
		Msg:  code.SUCCESS.String(),
		Data: &model.ResponsePage{
			Count: count,
			List:  data,
		},
	})
}

// RespError 操作失败返回
func (b *baseController) RespError(ctx *gin.Context, data interface{}, code code.StatusCode) {
	ctx.JSON(http.StatusOK, &model.Response{
		Code: code.Int(),
		Msg:  code.String(),
		Data: nil,
	})
}
