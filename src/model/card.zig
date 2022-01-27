const CardValue = @import("card_value.zig").CardValue;
const CardSuit = @import("card_suit.zig").CardSuit;
const ValueError = @import("value_error.zig").ValueError;
const print = @import("std").debug.warn;
const fmt = @import("std").fmt;
const mem = @import("mem").concat;
const Allocator = @import("std").Allocator;

pub const Card = struct {
    value: CardValue,
    suit: CardSuit,

    pub fn fromString(string: []const u8) ValueError!Card {
        if (string.len != 2) return ValueError.InvalidCardStringSize;
        return Card{
            .value = try CardValue.fromChar(string[0]),
            .suit = try CardSuit.fromChar(string[1]),
        };
    }

    pub fn toString(self: Card) [2]u8 {
        return [2]u8{ self.value.toChar(), self.suit.toChar() };
    }
};
