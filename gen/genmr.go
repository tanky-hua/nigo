package gen

import "nigo/template"

var (
	MrErrorTemplate, _     = template.TemplateFs.ReadFile("mr-error.tpl")
	MrLangTemplate, _      = template.TemplateFs.ReadFile("mr-lang.tpl")
	MrMapreduceTemplate, _ = template.TemplateFs.ReadFile("mr-mapreduce.tpl")
)

func genMR(dir, projectName string) error {
	err := genFile(&Config{
		dir:             dir,
		targetDir:       "/pkg/mr/",
		fileName:        "errorx.go",
		templateName:    "mrErrorTemplate",
		templateFile:    "mr-error.tpl",
		builtinTemplate: string(MrErrorTemplate),
		data:            nil,
	})
	if err != nil {
		return err
	}
	err = genFile(&Config{
		dir:             dir,
		targetDir:       "/pkg/mr/",
		fileName:        "lang.go",
		templateName:    "mrLangTemplate",
		templateFile:    "mr-lang.tpl",
		builtinTemplate: string(MrLangTemplate),
		data:            nil,
	})
	if err != nil {
		return err
	}
	err = genFile(&Config{
		dir:             dir,
		targetDir:       "/pkg/mr/",
		fileName:        "mapreduce.go",
		templateName:    "mrMapreduceTemplate",
		templateFile:    "mr-mapreduce.tpl",
		builtinTemplate: string(MrMapreduceTemplate),
		data:            nil,
	})
	if err != nil {
		return err
	}
	return nil
}
