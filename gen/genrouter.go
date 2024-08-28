package gen

import "goctl/template"

var (
	routerTemplate, _ = template.TemplateFs.ReadFile("router.tpl")
)

func genRouter(dir, projectName string) error {
	return genFile(&Config{
		dir:             dir,
		tagetDir:        "/routers/",
		fileName:        "router.go",
		templateName:    "routerTemplate",
		templateFile:    "router.tpl",
		builtinTemplate: string(routerTemplate),
		data: map[string]string{
			"ProjectName": projectName,
		},
	})
}
