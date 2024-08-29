package gen

import "nigo/template"

var (
	ginTemplate, _   = template.TemplateFs.ReadFile("middleware-gin.tpl")
	mdjwtTemplate, _ = template.TemplateFs.ReadFile("middleware-jwt.tpl")
)

func genMiddleware(dir string, projectName string) error {
	err := genFile(&Config{
		dir:             dir,
		targetDir:       "/middleware/",
		fileName:        "logger.go",
		templateName:    "loggerTemplate",
		templateFile:    "middleware-gin.tpl",
		builtinTemplate: string(ginTemplate),
		data: map[string]string{
			"ProjectName": projectName,
		},
	})
	if err != nil {
		return err
	}
	err = genFile(&Config{
		dir:             dir,
		targetDir:       "/middleware/",
		fileName:        "jwt.go",
		templateName:    "mdjwtTemplate",
		templateFile:    "middleware-jwt.tpl",
		builtinTemplate: string(mdjwtTemplate),
		data: map[string]string{
			"ProjectName": projectName,
		},
	})
	if err != nil {
		return err
	}

	return nil
}
