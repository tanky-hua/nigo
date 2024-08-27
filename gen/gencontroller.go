package gen

import "fmt"

var (
	controllerTemplate = ""
)

func genController(dir string) error {

	err := genFile(&Config{
		dir:             dir,
		tagetDir:        "/api/v1/",
		fileName:        "user.go",
		templateName:    "controllerUserTemplate",
		templateFile:    "controller-user-test.tpl",
		builtinTemplate: "",
		data: map[string]string{
			"ProjectName": "goctl-project",
		},
	})
	if err != nil {
		return err
	}

	importStr := `	
	"github.com/gin-gonic/gin"
	"net/http"
	"%s/model"
	"%s/utils/code"
`

	return genFile(&Config{
		dir:             dir,
		tagetDir:        "/api/v1/",
		fileName:        "base.go",
		templateName:    "controllerTemplate",
		templateFile:    controllerTemplateFile,
		builtinTemplate: controllerTemplate,
		data: map[string]string{
			"name":      "project",
			"importStr": fmt.Sprintf(importStr, "goctl-project", "goctl-project"),
		},
	})
}
