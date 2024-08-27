package gen

func genRouter(dir string) error {
	return genFile(&Config{
		dir:             dir,
		tagetDir:        "/routers/",
		fileName:        "router.go",
		templateName:    "routerTemplate",
		templateFile:    "router.tpl",
		builtinTemplate: "",
		data: map[string]string{
			"ProjectName": "goctl-project",
		},
	})
}
