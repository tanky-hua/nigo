package gen

import "github.com/tanky-hua/nigo/template"

var (
	pkgCodeTemplate, _ = template.TemplateFs.ReadFile("pkg-code.tpl")
	loggerTemplate, _  = template.TemplateFs.ReadFile("logger.tpl")
	jwtTemplate, _     = template.TemplateFs.ReadFile("jwt.tpl")
)

func genPkg(dir, projectName string) error {
	err := genFile(&Config{
		dir:             dir,
		targetDir:       "/pkg/singleflight/",
		fileName:        "singleflight.go",
		templateName:    "singleFlightTemplate",
		templateFile:    "singleflight.tpl",
		builtinTemplate: string(singleFlightTemplate),
		data:            nil,
	})
	if err != nil {
		return err
	}

	err = genFile(&Config{
		dir:             dir,
		targetDir:       "/pkg/logger/",
		fileName:        "logger.go",
		templateName:    "loggerTemplate",
		templateFile:    "logger.tpl",
		builtinTemplate: string(loggerTemplate),
	})
	if err != nil {
		return err
	}

	err = genFile(&Config{
		dir:             dir,
		targetDir:       "/pkg/jwt/",
		fileName:        "jwt.go",
		templateName:    "jwtTemplate",
		templateFile:    "jwt.tpl",
		builtinTemplate: string(jwtTemplate),
		data: map[string]string{
			"ProjectName": projectName,
		},
	})
	if err != nil {
		return err
	}

	return genFile(&Config{
		dir:             dir,
		targetDir:       "/pkg/code/",
		fileName:        "code.go",
		templateName:    "pkgCodeTemplate",
		templateFile:    pkgCodeTemplateFile,
		builtinTemplate: string(pkgCodeTemplate),
	})
}
