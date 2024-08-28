service:
  name: {{.ProjectName}}
  port: 80
  mode: debug
  token:
    accessTokenExpireTime: 1
    refreshTokenExpireTime: 15

#MYSQL
mysql:
  host: 127.0.0.1
  port: 3306
  user: root
  password: root
  db: user

#Redis
redis:
  host: 127.0.0.1
  port: 6379
  db: 0
