package model

type User struct{
    UserID uint `gorm:"primary_key"`
    Name string `gorm:"type:varchar(255);not null"`
}


type Status uint32

const (
	StatusUsable  Status = 1 // 1-启用
	StatusDisable Status = 2 // 2-禁用
)
