package api

import (
    "{{.ProjectName}}/service"
    "{{.ProjectName}}/utils/code"
    "github.com/gin-gonic/gin"
)

type UserController struct{
	baseController

	svc *service.UserService
}

func NewUserController()*UserController{
	return &UserController{
	    svc: service.NewUserService(),
	}
}

func (c *UserController) Get(ctx *gin.Context){
    type request struct{
        UserID uint `form:"user_id" binding:"required"`
    }

    var req request
	if err := ctx.BindQuery(&req); err != nil {
		c.RespError(ctx, err, code.InvalidParams)
		return
	}

	user, err :=c.svc.Get(req.UserID)
	if err != nil {
		c.RespError(ctx, err, code.ERROR)
		return
	}

	c.RespSuccess(ctx, user)
}