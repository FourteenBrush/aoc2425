package aoc

import "core:sync"
import "core:prof/spall"

import "base:runtime"

_ :: sync
_ :: spall
_ :: runtime

when ODIN_DEBUG {
    g_spall_ctx: spall.Context
    @(thread_local)
    g_spall_buf: spall.Buffer
}

main :: proc() {
    when ODIN_DEBUG {
        max_tsc_timeout_ms :: 500
        g_spall_ctx = spall.context_create("dayX.spall", max_tsc_timeout_ms) or_else panic("spall ctx")
        defer spall.context_destroy(&g_spall_ctx)

        backing_buf := make([]u8, spall.BUFFER_DEFAULT_SIZE)
        g_spall_buf = spall.buffer_create(backing_buf, u32(sync.current_thread_id())) or_else panic("spall buf")
        defer spall.buffer_destroy(&g_spall_ctx, &g_spall_buf)
    }

    // run day os.args[1]
}

part1 :: proc() {}

part2 :: proc() {}

when ODIN_DEBUG {
    @(instrumentation_enter)
    spall_enter :: proc "contextless" (proc_addr, callsite_ret_addr: rawptr, loc: runtime.Source_Code_Location) {
        spall._buffer_begin(&g_spall_ctx, &g_spall_buf, "", "", loc)
    }

    @(instrumentation_exit)
    spall_exit :: proc "contextless" (proc_addr, callsite_ret_addr: rawptr, loc: runtime.Source_Code_Location) {
        spall._buffer_end(&g_spall_ctx, &g_spall_buf)
    }
}
