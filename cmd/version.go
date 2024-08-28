package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
)

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "打印goctl的版本号",
	Long:  `所有软件都有版本号，这是goctl的版本号。`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Goctl的版本号为： v1.0")
	},
}
