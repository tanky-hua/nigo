package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
	"os"
)

func init() {
	rootCmd.AddCommand(newCmd)
	rootCmd.AddCommand(versionCmd)

}

var rootCmd = &cobra.Command{
	Use:   "nigo",
	Short: "nigo 是一个快速生成单体项目的工具",
	Long: `简介：
 快速生成单体项目目录结构和代码
 涉及技术框架有gin、gorm、redis、viper等
 支持缓存查询、mr并发调用内部服务等
 并提供简单的User模块demo

 欢迎使用!!！`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println(`欢迎使用Nigo!!!
请输入nigo help查看帮助`)
	},
}

func Execute() {

	rootCmd.SetUsageTemplate(template)
	if err := rootCmd.Execute(); err != nil {
		//fmt.Println(err)
		os.Exit(1)
	}
}
