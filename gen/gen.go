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
	targetDir       string
	fileName        string
	templateName    string
	templateFile    string
	builtinTemplate string
	data            interface{}
}

func GenProject(dir string, projectName string) error {
	dir = fmt.Sprintf("%s/%s", dir, projectName)

	MustError(genConfig(dir, projectName))
	MustError(genModel(dir, projectName))
	MustError(genPkg(dir, projectName))
	MustError(genController(dir, projectName))
	MustError(genCache(dir, projectName))
	MustError(genDB(dir, projectName))
	MustError(genService(dir, projectName))
	MustError(genMR(dir, projectName))
	MustError(genRouter(dir, projectName))
	MustError(genMiddleware(dir, projectName))
	MustError(genMain(dir, projectName))

	return nil

}

func genFile(c *Config) error {

	fpath := path.Join(c.dir, c.targetDir, c.fileName)
	_, err := os.Stat(fpath)
	if !os.IsNotExist(err) {
		return fmt.Errorf("%s already exist", fpath)
	}

	err = os.MkdirAll(path.Join(c.dir, c.targetDir), os.ModePerm)
	if err != nil {
		return err
	}
	fp, err := os.Create(fpath)
	if err != nil {
		return err
	}
	t := template.Must(template.New(c.templateName).Parse(c.builtinTemplate))
	buffer := new(bytes.Buffer)
	err = t.Execute(buffer, c.data)
	if err != nil {
		return err
	}

	code := formatCode(buffer.String())
	_, err = fp.WriteString(code)
	if err != nil {
		return err
	}

	fmt.Println(c.targetDir+c.fileName, " 创建成功！")
	return nil
}

func formatCode(code string) string {
	ret, err := format.Source([]byte(code))
	if err != nil {
		return code
	}

	return string(ret)
}

func MustError(err error) {
	if err != nil {
		fmt.Println("初始化文件失败：", err)
		fmt.Println("请确保目录文件不存在或者为空目录！")
		os.Exit(1)
	}
}
