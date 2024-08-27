package gen

import (
	"bytes"
	"fmt"
	"go/format"
	"os"
	"path"
	"text/template"
)

type Config struct {
	dir             string
	tagetDir        string
	fileName        string
	templateName    string
	templateFile    string
	builtinTemplate string
	data            interface{}
}

func GenProject(dir string) error {
	err := genConfig(dir)
	if err != nil {
		return err
	}

	err = genModel(dir)
	if err != nil {
		return err
	}

	err = genUtilCode(dir)
	if err != nil {
		return err
	}
	err = genController(dir)
	if err != nil {
		return err
	}

	err = genCache(dir)
	if err != nil {
		return err
	}

	err = genDB(dir)
	if err != nil {
		return err
	}

	err = genService(dir)
	if err != nil {
		return err
	}

	err = genMR(dir)
	if err != nil {
		return err
	}

	err = genRouter(dir)
	if err != nil {
		return err
	}

	err = genMain(dir)
	if err != nil {
		return err
	}
	return nil

}

func genFile(c *Config) error {

	content, err := os.ReadFile("./template/" + c.templateFile)
	if err != nil {
		return err
	}
	fpath := path.Join(c.dir, c.tagetDir, c.fileName)
	fmt.Println("path:", fpath)
	_, err = os.Stat(fpath)
	if !os.IsNotExist(err) {
		return fmt.Errorf("%s already exist", fpath)
	}

	err = os.MkdirAll(path.Join(c.dir, c.tagetDir), os.ModePerm)
	if err != nil {
		return err
	}
	fp, err := os.Create(fpath)
	if err != nil {
		return err
	}
	t := template.Must(template.New(c.templateName).Parse(string(content)))
	buffer := new(bytes.Buffer)
	err = t.Execute(buffer, c.data)
	if err != nil {
		return err
	}

	code := formatCode(buffer.String())
	_, err = fp.WriteString(code)
	return err
}

func formatCode(code string) string {
	ret, err := format.Source([]byte(code))
	if err != nil {
		return code
	}

	return string(ret)
}
