package gen

import "goctl/template"

var (
	utilsCodeTemplate, _ = template.TemplateFs.ReadFile("utils-code.tpl")
)

func genUtilCode(dir, projectName string) error {
	return genFile(&Config{
		dir:             dir,
		tagetDir:        "/utils/code/",
		fileName:        "code.go",
		templateName:    "utilsCodeTemplate",
		templateFile:    utilsCodeTemplateFile,
		builtinTemplate: string(utilsCodeTemplate),
	})
}
