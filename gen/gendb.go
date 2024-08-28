package gen

import "goctl/template"

var (
	dbInitTemplate, _     = template.TemplateFs.ReadFile("db-init.tpl")
	dbUserTestTemplate, _ = template.TemplateFs.ReadFile("db-user-test.tpl")
)

func genDB(dir, projectName string) error {

	err := genFile(&Config{
		dir:             dir,
		targetDir:       "/repository/db/",
		fileName:        "user.go",
		templateName:    "dbTestTemplate",
		templateFile:    "db-user-test.tpl",
		builtinTemplate: string(dbUserTestTemplate),
		data: map[string]interface{}{
			"ProjectName": projectName,
		},
	})
	if err != nil {
		return err
	}

	return genFile(&Config{
		dir:             dir,
		targetDir:       "/repository/db/",
		fileName:        "init.go",
		templateName:    "dbInitTemplate",
		templateFile:    "db-init.tpl",
		builtinTemplate: string(dbInitTemplate),
		data: map[string]interface{}{
			"ProjectName": projectName,
		},
	})
}
