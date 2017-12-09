package tools

import (
	"fmt"
	"time"
)

func Timing() {
	fmt.Println("Problem Size \t\t\t", "Seconds")
	var i int
	for i = 1; i < 5; i++ {
		var problemSize = 1000 * i
		start := time.Now()
		work := 1
		var problem = problemSize

		for problem > 0 {
			work++
			work--
			problem--
		}
		end := time.Now()
		elapsed := start.Sub(end)
		fmt.Print(problemSize, " problems solved in \t", elapsed, ".\n")
		problemSize *= 2
	}
}
