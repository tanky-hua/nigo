package db

import (
	"context"
	"errors"
	"gorm.io/gorm"
	"{{.ProjectName}}/model"
)

type UserDao struct {
	db *gorm.DB
}

func NewUserDao(ctx context.Context) *UserDao {
	return &UserDao{NewDBClient(ctx)}
}

// GetByID 根据用户id获取信息
func (u *UserDao) GetByID(userID uint) ( *model.User, error) {
    var user model.User
    err := u.db.Where("user_id=? and status=?", userID, model.StatusUsable).First(&user).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &user,nil
}

func (u *UserDao) List(req model.UserListRequest) ([]*model.User, error) {
	var users []*model.User
	err := u.db.Where("status=?", model.StatusUsable).
		Offset(int((req.Page - 1) * req.PageSize)).
		Limit(int(req.PageSize)).
		Find(&users).Error
	if err != nil {
		return nil, err
	}
	return users, nil
}
