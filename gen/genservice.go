package gen

import "github.com/tanky-hua/nigo/template"

var (
	serviceUserTestTemplate, _ = template.TemplateFs.ReadFile("service-user-test.tpl")
)

func genService(dir, projectName string) error {
	err := genFile(&Config{
		dir:             dir,
		targetDir:       "/service/",
		fileName:        "user.go",
		templateName:    "serviceUserTemplate",
		templateFile:    "service-user-test.tpl",
		builtinTemplate: string(serviceUserTestTemplate),
		data: map[string]string{
			"ProjectName": projectName,
		},
	})
	return err
}
