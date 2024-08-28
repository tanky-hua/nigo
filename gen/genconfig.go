package gen

import "goctl/template"

var (
	configTemplate, _ = template.TemplateFs.ReadFile("config.tpl")
	etcTemplate, _    = template.TemplateFs.ReadFile("etc.tpl")
)

func genConfig(dir string, projectName string) error {

	err := genFile(&Config{
		dir:             dir,
		tagetDir:        "/config/",
		fileName:        "config.yaml",
		templateName:    "etcTemplate",
		templateFile:    etcTemplateFile,
		builtinTemplate: string(etcTemplate),
		data: map[string]string{
			"ProjectName": projectName,
		},
	})
	if err != nil {
		return err
	}
	return genFile(&Config{
		dir:             dir,
		tagetDir:        "/config/",
		fileName:        "config.go",
		templateName:    "configTemplate",
		templateFile:    configTemplateFile,
		builtinTemplate: string(configTemplate),
		data:            map[string]string{},
	})

}
