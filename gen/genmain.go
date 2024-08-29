package gen

import "nigo/template"

var (
	mainTemplate, _ = template.TemplateFs.ReadFile("main.tpl")
)

func genMain(dir, projectName string) error {
	return genFile(&Config{
		dir:             dir,
		targetDir:       "",
		fileName:        "main.go",
		templateName:    "mainTemplate",
		templateFile:    "main.tpl",
		builtinTemplate: string(mainTemplate),
		data: map[string]string{
			"ProjectName": projectName,
		},
	})
}
