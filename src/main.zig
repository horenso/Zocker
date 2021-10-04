const std = @import("std");
const model = @import("./model.zig");

pub fn main() anyerror!void {
    const cards = [4]model.Suit{
        model.Suit.fromInt(0),
        model.Suit.fromInt(1),
        model.Suit.fromInt(2),
        model.Suit.fromInt(3),
    };
    std.log.info("Cards: {u}, {u}, {u}, {u}.", .{
        cards[0].toSymbol(),
        cards[1].toSymbol(),
        cards[2].toSymbol(),
        cards[3].toSymbol(),
    });
    std.log.info("All your codebase are belong to us.", .{});
}
