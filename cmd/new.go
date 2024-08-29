package cmd

import (
	"errors"
	"github.com/spf13/cobra"
	"github.com/tanky-hua/nigo/gen"
	"os"
)

var (
	VarDir = "."

	newCmd = &cobra.Command{
		Use:   "new",
		Short: "生成新项目目录结构及代码",
		Long: `new命令描述:
  生成新项目目录结构及代码
  包含缓存、数据库查询，中间件等功能
  具体使用请看user相关实例代码`,
		RunE: func(cmd *cobra.Command, args []string) error {
			projectName := "project"
			if len(args) > 0 {
				projectName = args[0]
			} else {
				return errors.New("请输入项目名称")
			}

			dir := os.Getenv("GOPATH")
			if VarDir == "." && dir != "" {
				VarDir = dir + "/src/"
			}

			return gen.GenProject(VarDir, projectName)
		},
		Args: cobra.MaximumNArgs(1),
		Example: `# 创建项目目录结构
  nigo new project
# 创建项目目录结构并指定项目目录
  nigo new project -d .`,
	}
)

func init() {
	//newCmd.SetUsageTemplate(template)
	newCmd.Flags().StringVarP(&VarDir, "dir", "d", ".", "项目目录生成路径")
}
