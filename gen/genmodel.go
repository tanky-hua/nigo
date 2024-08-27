package gen

var (
	modelTemplate = ""
)

func genModel(dir string) error {

	err := genFile(&Config{
		dir:             dir,
		tagetDir:        "/model/",
		fileName:        "user.go",
		templateName:    "modelTestTemplate",
		templateFile:    "model-user-test.tpl",
		builtinTemplate: "",
		data: map[string]interface{}{
			"ProjectName": "goctl-project",
		},
	})
	if err != nil {
		return err
	}

	return genFile(&Config{
		dir:             dir,
		tagetDir:        "/model/",
		fileName:        "response.go",
		templateName:    "modelTemplate",
		templateFile:    modelTemplateFile,
		builtinTemplate: modelTemplate,
	})
}
