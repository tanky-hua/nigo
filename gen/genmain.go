package gen

func genMain(dir string) error {
	return genFile(&Config{
		dir:             dir,
		tagetDir:        "",
		fileName:        "main.go",
		templateName:    "mainTemplate",
		templateFile:    "main.tpl",
		builtinTemplate: "",
		data: map[string]string{
			"ProjectName": "goctl-project",
		},
	})
}
