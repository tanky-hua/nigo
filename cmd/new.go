package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
	"goctl/gen"
)

var (
	newCmd = &cobra.Command{
		Use:   "new",
		Short: "生成新项目目录结构及代码",
		Long:  `生成新项目目录结构及代码，包含缓存、数据库查询，中间件等功能，具体使用请看user相关实例代码`,
		RunE: func(cmd *cobra.Command, args []string) error {
			fmt.Println("args: ", args, VarDir)
			projectName := ""
			if len(args) > 0 {
				projectName = args[0]
			}

			return gen.GenProject(VarDir, projectName)
		},
		Args: cobra.MaximumNArgs(1),
	}
	VarDir = "."
)

func init() {
	newCmd.Flags().StringVarP(&VarDir, "dir", "d", ".", "项目目录")
}
