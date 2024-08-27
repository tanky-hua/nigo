package db

import (
	"context"
	"fmt"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
	"gorm.io/gorm/schema"
	"strings"
	"time"
	"{{.ProjectName}}/config"
)

var (
	_db  *gorm.DB
)

func init() {
	cfg := config.Get()
	host := cfg.MySQL.Host
	port := cfg.MySQL.Port
	user := cfg.MySQL.User
	password := cfg.MySQL.Password
	dbName := cfg.MySQL.DB

	db, _ := ConnectMysql(host, port, user, password, dbName)
	_db = db
	_db = _db.Set("gorm:table_options", "charset=utf8mb4")

    //自动生成表结构
	err := migrate()
	if err != nil {
		zap.S().Error(err)
		panic(err)
	}
	fmt.Println("数据库连接成功")
}

func ConnectMysql(host string, port int, user, password, dbName string) (*gorm.DB, error) {
	path := strings.Join([]string{user, ":", password, "@tcp(", host, ":", fmt.Sprintf("%d", port), ")/", dbName, "?charset=utf8mb4&parseTime=true&loc=Local"}, "")

	var ormLogger logger.Interface
	if gin.Mode() == "debug" {
		ormLogger = logger.Default.LogMode(logger.Info)
	} else {
		ormLogger = logger.Default
	}

	db, err := gorm.Open(mysql.New(mysql.Config{
		DSN:                       path,  // DSN data source name
		DefaultStringSize:         256,   // string 类型字段的默认长度
		DisableDatetimePrecision:  true,  // 禁用 datetime 精度，MySQL 5.6 之前的数据库不支持
		DontSupportRenameIndex:    true,  // 重命名索引时采用删除并新建的方式，MySQL 5.7 之前的数据库和 MariaDB 不支持重命名索引
		DontSupportRenameColumn:   true,  // 用 `change` 重命名列，MySQL 8 之前的数据库和 MariaDB 不支持重命名列
		SkipInitializeWithVersion: false, // 根据版本自动配置
	}), &gorm.Config{
		Logger: ormLogger,
		NamingStrategy: schema.NamingStrategy{
			SingularTable: true,
		},
	})

	if err != nil {
		panic(err)
	}

	sqlDB, _ := db.DB()
	sqlDB.SetMaxIdleConns(20)  // 设置连接池，空闲
	sqlDB.SetMaxOpenConns(100) // 打开
	sqlDB.SetConnMaxLifetime(time.Second * 30)

	return db, err
}

func NewDBClient(ctx context.Context) *gorm.DB {
	db := _db
	return db.WithContext(ctx)
}

func migrate() (err error) {
	// user 库
	//err = _dd.Set("gorm:table_options", "charset=utf8mb4").AutoMigrate(&model.User{})

	return
}
