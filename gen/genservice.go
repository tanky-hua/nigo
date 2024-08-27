package gen

func genService(dir string) error {
	err := genFile(&Config{
		dir:             dir,
		tagetDir:        "/service/",
		fileName:        "user.go",
		templateName:    "serviceUserTemplate",
		templateFile:    "service-user-test.tpl",
		builtinTemplate: "",
		data: map[string]string{
			"ProjectName": "goctl-project",
		},
	})
	return err
}
