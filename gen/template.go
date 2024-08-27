package gen

const (
	configTemplateFile     = "config.tpl"
	controllerTemplateFile = "controller.tpl"
	etcTemplateFile        = "etc.tpl"
	modelTemplateFile      = "model.tpl"
	utilsCodeTemplateFile  = "utils-code.tpl"
)

var templates = map[string]string{
	configTemplateFile:     configTemplate,
	controllerTemplateFile: controllerTemplate,
	modelTemplateFile:      modelTemplate,
	utilsCodeTemplateFile:  utilsCodeTemplate,
	etcTemplateFile:        etcTemplate,
}
