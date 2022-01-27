const unicode = @import("std").unicode;
const ValueError = @import("value_error.zig").ValueError;

pub const CardSuit = enum {
    diamonds,
    clubs,
    hearts,
    spades,

    pub fn fromInt(num: i2) ValueError!CardSuit {
        return switch (num) {
            0...3 => @intToEnum(CardSuit, num),
            else => ValueError.InvalidCharacter,
        };
    }

    pub fn fromChar(char: u8) ValueError!CardSuit {
        return switch (char) {
            'D' => .diamonds,
            'C' => .clubs,
            'H' => .hearts,
            'S' => .spades,
            else => ValueError.InvalidCharacter,
        };
    }

    pub fn fromUnicodeSymbol(char: u8) ValueError!CardSuit {
        return switch (char) {
            "♦" => .diamonds,
            "♣" => .clubs,
            "♥" => .hearts,
            "♠" => .spades,
            else => ValueError.InvalidCharacter,
        };
    }

    pub fn toChar(self: CardSuit) u8 {
        return switch (self) {
            .diamonds => 'D',
            .clubs => 'C',
            .hearts => 'H',
            .spades => 'S',
        };
    }

    pub fn toUnicodeSymbol(self: CardSuit) []const u8 {
        return switch (self) {
            .diamonds => "♦",
            .clubs => "♣",
            .hearts => "♥",
            .spades => "♠",
        };
    }
};
