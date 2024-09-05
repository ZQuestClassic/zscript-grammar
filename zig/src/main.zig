const std = @import("std");
const Tokenizer = @import("./tokenizer.zig").Tokenizer;
const Token = @import("./tokenizer.zig").Token;
const Parse = @import("./Parse.zig");
const Ast = @import("./Ast.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    // const source = "void fn(){\n\tint[] data = 0L;\n}";
    const source = @embedFile("simple.zs");
    // const source = @embedFile("std_functions.zh");
    // var tokenizer = Tokenizer.init(source);
    // var token_count: u32 = 0;
    // while (true) {
    //     const token = tokenizer.next();
    //     // std.log.info("{s} ({}, {})", .{ token.tag.symbol(), token.loc.start, token.loc.end });
    //     if (token.tag == .eof) {
    //         break;
    //     }

    //     token_count += 1;
    // }
    const ast = try Ast.parse(allocator, source);
    std.log.info("nodes: {}", .{ast.nodes.len});
}
