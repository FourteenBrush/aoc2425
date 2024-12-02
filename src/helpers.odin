package aoc

parse_int :: proc(s: string) -> (res, n: int) #no_bounds_check {
    for n < len(s) {
        b := s[n]
        if b < '0' || b > '9' do break
        res = res * 10 + int(b - '0')
        n += 1
    }
    return
}
