package code

type StatusCode int

const(
    	SUCCESS           StatusCode  = 0 //成功
    	InvalidParams     StatusCode  = 400
    	ERROR             StatusCode  = 500

    	ErrorAuthCheckTokenFail        = 10001 //token 错误
    	ErrorAuthUnLogin               = 10002
    	ErrorVisitorRegisterFail       = 10003
)

var codeMsg = map[StatusCode]string{
    	SUCCESS:           "success",
    	InvalidParams:     "请求参数错误",
    	ERROR:             "服务器内部错误",

    	ErrorAuthCheckTokenFail:        "Token鉴权失败",
    	ErrorAuthUnLogin:               "请先登陆",
    	ErrorVisitorRegisterFail: "游客注册失败",
}

func (c StatusCode)String()string{
    return codeMsg[c]
}

func (c StatusCode)Int()int{
    return int(c)
}