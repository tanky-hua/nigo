package gen

func genMR(dir string) error {
	err := genFile(&Config{
		dir:             dir,
		tagetDir:        "/mr/",
		fileName:        "errorx.go",
		templateName:    "mrErrorTemplate",
		templateFile:    "mr-error.tpl",
		builtinTemplate: "",
		data:            nil,
	})
	if err != nil {
		return err
	}
	err = genFile(&Config{
		dir:             dir,
		tagetDir:        "/mr/",
		fileName:        "lang.go",
		templateName:    "mrLangTemplate",
		templateFile:    "mr-lang.tpl",
		builtinTemplate: "",
		data:            nil,
	})
	if err != nil {
		return err
	}
	err = genFile(&Config{
		dir:             dir,
		tagetDir:        "/mr/",
		fileName:        "mapreduce.go",
		templateName:    "mrMapreduceTemplate",
		templateFile:    "mr-mapreduce.tpl",
		builtinTemplate: "",
		data:            nil,
	})
	if err != nil {
		return err
	}
	return nil
}
