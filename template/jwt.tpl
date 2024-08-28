package jwt

import (
	"errors"
	jwtgo "github.com/dgrijalva/jwt-go"
	"time"
)

type Claims struct {
	InstallID string `json:"install_id"`
	jwtgo.StandardClaims
}

var (
	jwtSecret = []byte("{{.ProjectName}}")
	issuer    = "{{.ProjectName}}"
)

// GenerateToken 生成用户token
func GenerateToken(installID string, accessTokenExpire, refreshTokenExpire time.Duration) (accessToken, refreshToken string, err error) {
	nowTime := time.Now()
	expireTime := nowTime.Add(accessTokenExpire)
	rtExpireTime := nowTime.Add(refreshTokenExpire)
	claims := Claims{
		InstallID: installID,
		StandardClaims: jwtgo.StandardClaims{
			ExpiresAt: expireTime.Unix(),
			Issuer:    issuer,
		},
	}
	// 加密后获得完整的编码后的字符串token
	accessToken, err = jwtgo.NewWithClaims(jwtgo.SigningMethodHS256, claims).SignedString(jwtSecret)
	if err != nil {
		return "", "", err
	}

	refreshToken, err = jwtgo.NewWithClaims(jwtgo.SigningMethodHS256, jwtgo.StandardClaims{
		ExpiresAt: rtExpireTime.Unix(),
		Issuer:    issuer,
	}).SignedString(jwtSecret)
	if err != nil {
		return "", "", err
	}

	return
}

// ParseToken 解析token
func ParseToken(token string) (*Claims, error) {
	tokenClaims, err := jwtgo.ParseWithClaims(token, &Claims{}, func(token *jwtgo.Token) (interface{}, error) {
		return jwtSecret, nil
	})
	if tokenClaims != nil {
		if claims, ok := tokenClaims.Claims.(*Claims); ok && tokenClaims.Valid {
			return claims, nil
		}
	}
	return nil, err
}

// ParseRefreshToken 验证用户token
func ParseRefreshToken(aToken, rToken string, accessTokenExpire, refreshTokenExpire time.Duration) (newAToken, newRToken string, err error) {
	var claim Claims
	_, err = jwtgo.ParseWithClaims(aToken, &claim, func(token *jwtgo.Token) (interface{}, error) {
		return jwtSecret, nil
	})
	if err != nil {
		v, _ := err.(*jwtgo.ValidationError)
		if v.Errors != jwtgo.ValidationErrorExpired {
			return

		}
	}

	refreshClaim, err := ParseToken(rToken)
	if err != nil {
		return
	}

	if refreshClaim.ExpiresAt > time.Now().Unix() {
		// 如果 access_token 过期了,但是 refresh_token 没过期, 刷新 refresh_token 和 access_token
		return GenerateToken(claim.InstallID, accessTokenExpire, refreshTokenExpire)
	}

	// 如果两者都过期了,重新登陆
	return "", "", errors.New("身份过期，重新登陆")
}

// RefreshToken 刷新token
func RefreshToken(refreshToken string, accessTokenExpire, refreshTokenExpire time.Duration) (string, string, error) {

	refreshClaim, err := ParseToken(refreshToken)
	if err != nil {
		return "", "", err
	}

	if refreshClaim.ExpiresAt > time.Now().Unix() {
		// 刷新 refresh_token 和 access_token
		return GenerateToken(refreshClaim.InstallID, accessTokenExpire, refreshTokenExpire)
	}
	return "", "", errors.New("身份过期，重新登陆")

}
