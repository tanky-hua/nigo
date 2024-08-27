package main

import (
	"fmt"
	"goctl/gen"
)

func main() {
	fmt.Println(gen.GenProject("../goctl-project"))
}
