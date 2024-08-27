package model

// Response 返回数据结构
type Response struct {
	Code int `json:"code"`
	Msg  string `json:"msg"`
	Data interface{} `json:"data"`
}

// ResponsePage 分页返回数据结构
type ResponsePage struct {
    List interface{} `json:"list"`
    Count int `json:"count"`
}