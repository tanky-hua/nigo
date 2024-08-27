package gen

func genDB(dir string) error {

	err := genFile(&Config{
		dir:             dir,
		tagetDir:        "/repository/db/",
		fileName:        "user.go",
		templateName:    "dbTestTemplate",
		templateFile:    "db-user-test.tpl",
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
		tagetDir:        "/repository/db/",
		fileName:        "init.go",
		templateName:    "dbInitTemplate",
		templateFile:    "db-init.tpl",
		builtinTemplate: "",
		data: map[string]interface{}{
			"ProjectName": "goctl-project",
		},
	})
}
