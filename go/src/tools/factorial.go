package tools

func Factorial(input int) int {
	fact := 1
	for i := 0; i < input; i++ {
		fact = fact * input
		input -= 1
	}
	return fact
}
