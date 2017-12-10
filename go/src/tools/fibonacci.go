package tools

import (
	"fmt"
)

//1,2,3,5,8,
//i=1; i += i;

//	1	2	3	5	8
//	p	n
//			f=p+n	f=2+3
//			p=n	p=3
//			n=f	n=5
//

func Fibonaccir(till, p, n int) int {
	if till > 2 {
		if p == 1 {
			fmt.Print(p, ", ", n, ", ")
		}
		till--
		var fib = p + n
		p = n
		n = fib
		fmt.Print(fib, ", ")
		return Fibonaccir(till, p, n)
	}
	return till
}

func Fibonacci(till int) int {
	var prev = 1
	var next = 2
	for till > 2 {
		if prev == 1 {
			fmt.Print(prev, ", ", next, ", ")
		}
		var fib = prev + next
		fmt.Print(fib, ", ")
		prev = next
		next = fib
		till--
	}
	return till
}
