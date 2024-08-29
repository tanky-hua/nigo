package gen

import "github.com/tanky-hua/nigo/template"

var (
	modelTemplate, _         = template.TemplateFs.ReadFile("model.tpl")
	modelUserTestTemplate, _ = template.TemplateFs.ReadFile("model-user-test.tpl")
)

func genModel(dir, projectName string) error {

	err := genFile(&Config{
		dir:             dir,
		targetDir:       "/model/",
		fileName:        "user.go",
		templateName:    "modelTestTemplate",
		templateFile:    "model-user-test.tpl",
		builtinTemplate: string(modelUserTestTemplate),
		data: map[string]interface{}{
			"ProjectName": projectName,
		},
	})
	if err != nil {
		return err
	}

	return genFile(&Config{
		dir:             dir,
		targetDir:       "/model/",
		fileName:        "response.go",
		templateName:    "modelTemplate",
		templateFile:    modelTemplateFile,
		builtinTemplate: string(modelTemplate),
	})
}
