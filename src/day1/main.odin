package aoc

import "core:fmt"
import "core:time"
import "core:slice"
import "core:strings"

input := #load("input.txt", string)

main :: proc() {
    start := time.tick_now()
    list0 := make([dynamic]int, 0, 1000)
    list1 := make([dynamic]int, 0, 1000)

    for line in strings.split_lines_iterator(&input) {
        num0, len := parse_int(line)
        num_spaces :: 3
        num1, _ := parse_int(line[len + num_spaces:]) 
        append(&list0, num0)
        append(&list1, num1)
    }

    slice.sort(list0[:])
    slice.sort(list1[:])

    sum := 0
    for i in 0..<len(list0) {
        sum += abs(list0[i] - list1[i])
    }
    
    fmt.println(sum, time.tick_since(start))
}

parse_int :: proc(s: string) -> (res, n: int) {
    for i in 0..<len(s) {
        if s[i] < '0' || s[i] > '9' do break
        res *= 10
        res += int(s[i] - '0')
        n += 1
    }
    return
}
