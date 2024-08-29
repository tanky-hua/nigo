package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
)

const BuildVersion = "1.0.1"

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "打印nigo的版本号",
	Long: `所有软件都有版本号
使用version命令可以打印出nigo的版本号`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("nigo的版本号为:v%s\n", BuildVersion)
	},
}
