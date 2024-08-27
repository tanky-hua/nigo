package gen

var (
	configTemplate = ""
	etcTemplate    = ""
)

func genConfig(dir string) error {
	importStr := `
	"github.com/fsnotify/fsnotify"
	"github.com/spf13/viper"
	"go.uber.org/zap"`
	err := genFile(&Config{
		dir:             dir,
		tagetDir:        "/config/",
		fileName:        "config.yaml",
		templateName:    "etcTemplate",
		templateFile:    etcTemplateFile,
		builtinTemplate: configTemplate,
		data: map[string]string{
			"name": "project",
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
		builtinTemplate: configTemplate,
		data: map[string]string{
			"importStr": importStr,
		},
	})

}
