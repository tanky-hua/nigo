package code

type StatusCode int

const(
    	SUCCESS           StatusCode  = 0 //成功
    	InvalidParams     StatusCode  = 400
    	ERROR             StatusCode  = 500
)

var codeMsg = map[StatusCode]string{
    	SUCCESS:           "OK",
    	InvalidParams:     "请求参数错误",
    	ERROR:             "服务器内部错误",
}

func (c StatusCode)String()string{
    return codeMsg[c]
}

func (c StatusCode)Int()int{
    return int(c)
}