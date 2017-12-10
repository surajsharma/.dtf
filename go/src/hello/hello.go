// LEARNING TO SPEAK GO

package main

import (
	"fmt"
	"tools"
)

func main() {
	fmt.Print("\033[H\033[2J")
	fmt.Print("How many Fibonacci should I print? : ")
	var fib = 0
	fmt.Scan(&fib)
	tools.Fibonaccir(fib, 1, 2)
	tools.Fibonacci(fib)
	//--------------------------------------------------
	//	tools.Timing(10000)
	//	var input int
	//	fmt.Println("Enter number to factorialize: ")
	//	fmt.Scanln(&input)
	//	fact := Factorial(input)
	//	fmt.Println("Factorial: ", fact)

}
