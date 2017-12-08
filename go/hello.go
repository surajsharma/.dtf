package main

import "fmt"

func main() {
	fact := Factorial(5)
	//add input
	fmt.Println("Factorial: ", fact)
}

func Factorial(input int) int {
	fact := 1
	for i := 0; i < input; i++ {
		fact = fact * input
		input -= 1
	}
	return fact
}
