package tools

import (
	"fmt"
)

//1,2,3,5,8,
//i=1; i += i;
//	1	2	3	5	8
//	p	n
//			n:p+n,p:n	n:p+n,p=n
//

func Fibonacci(till int) int {
	var prev = 1
	var next = 2
	fmt.Print(prev, ", ")
	for till > 0 {
		var fib = prev + next
		fmt.Print(fib, ", ")
		till--
		prev = next
		next = fib

	}
	return till
}
