package gen

var (
	utilsCodeTemplate = ""
)

func genUtilCode(dir string) error {
	return genFile(&Config{
		dir:             dir,
		tagetDir:        "/utils/code/",
		fileName:        "code.go",
		templateName:    "utilsCodeTemplate",
		templateFile:    utilsCodeTemplateFile,
		builtinTemplate: utilsCodeTemplate,
	})
}
