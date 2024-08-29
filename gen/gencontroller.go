package gen

import (
	"github.com/tanky-hua/nigo/template"
)

var (
	controllerTemplate, _         = template.TemplateFs.ReadFile("controller.tpl")
	controllerUserTestTemplate, _ = template.TemplateFs.ReadFile("controller-user-test.tpl")
)

func genController(dir, projectName string) error {

	err := genFile(&Config{
		dir:             dir,
		targetDir:       "/api/v1/",
		fileName:        "user.go",
		templateName:    "controllerUserTemplate",
		templateFile:    "controller-user-test.tpl",
		builtinTemplate: string(controllerUserTestTemplate),
		data: map[string]string{
			"ProjectName": projectName,
		},
	})
	if err != nil {
		return err
	}

	return genFile(&Config{
		dir:             dir,
		targetDir:       "/api/v1/",
		fileName:        "base.go",
		templateName:    "controllerTemplate",
		templateFile:    controllerTemplateFile,
		builtinTemplate: string(controllerTemplate),
		data: map[string]string{
			"ProjectName": projectName,
		},
	})
}
