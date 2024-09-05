const std = @import("std");
const Token = @import("./tokenizer.zig").Token;
const Ast = @import("./Ast.zig");
const Allocator = std.mem.Allocator;

gpa: Allocator,
source: []const u8,
token_tags: []const Token.Tag,
token_starts: []const Ast.ByteOffset,
tok_i: Ast.TokenIndex,
errors: std.ArrayListUnmanaged(Ast.Error),
nodes: Ast.NodeList,
extra_data: std.ArrayListUnmanaged(Ast.Node.Index),
scratch: std.ArrayListUnmanaged(Ast.Node.Index),

const Parse = @This();

// fn parseScriptBlock(p: *Parse) !void {}

/// Root <- skip container_doc_comment? ContainerMembers eof
pub fn parseRoot(p: *Parse) !void {
    // Root node must be index 0.
    p.nodes.appendAssumeCapacity(.{
        .tag = .root,
        .main_token = 0,
        .data = undefined,
    });

    // const root_members = try p.parseContainerMembers();
    // const root_decls = try root_members.toSpan(p);
    // if (p.token_tags[p.tok_i] != .eof) {
    //     try p.warnExpected(.eof);
    // }
    // p.nodes.items(.data)[0] = .{
    //     .lhs = root_decls.start,
    //     .rhs = root_decls.end,
    // };
}
