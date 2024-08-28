package middleware

import (
	"github.com/gin-gonic/gin"
	e "{{.ProjectName}}/pkg/code"
	"{{.ProjectName}}/pkg/jwt"
	"{{.ProjectName}}/model"
	"go.uber.org/zap"
	"net/http"
)
const(
	AccessTokenHeader          = "access_token"
	RefreshTokenHeader         = "refresh_token"
	InstallIDHeader            = "install_id"
)
// AuthTokenMiddleware token验证中间件
func AuthTokenMiddleware() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		code := checkAuth(ctx, false)
		if code != e.SUCCESS {
			ctx.JSON(http.StatusOK, &model.Response{
				Code: code.Int(),
				Msg:  code.String(),
			})
			ctx.Abort()
			return
		}
		ctx.Next()
	}
}

// AuthVisitorMiddleware 游客身份验证
func AuthVisitorMiddleware() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		code := checkAuth(ctx, true)
		if code != e.SUCCESS {
			ctx.JSON(http.StatusOK, &model.Response{
				Code: code.Int(),
				Msg:  code.String(),
			})
			ctx.Abort()
			return
		}
		ctx.Next()
	}
}

func checkAuth(ctx *gin.Context, isVisitorCheck bool) e.StatusCode {
	var code = e.SUCCESS
	installID := ""
	accessToken := ctx.GetHeader(AccessTokenHeader)

	if accessToken == "" {
		if isVisitorCheck {
			// 游客方式
			zap.S().Debug("access_token:", accessToken)
			installID = ctx.GetHeader(InstallIDHeader)
			zap.S().Debug("installID:", installID)
			if installID == "" || installID == "0" {
				return e.ErrorVisitorRegisterFail
			}
		} else {
			// 登陆接口，未登陆状态
			return e.ErrorAuthUnLogin
		}
	} else {
		// 登陆状态（这里需要验证token，exp：获取章节信息需要用户id，但是不走登陆验证）
		claims, err := jwt.ParseToken(accessToken)
		if err != nil {
			zap.S().Error(err)
			return e.ErrorAuthCheckTokenFail
		}
		if claims != nil {
			zap.S().Debug("installID:", claims.InstallID)
			installID = claims.InstallID
		}

		// 是否在黑名单

	}

	//  判断用户是否存在


	return code
}
