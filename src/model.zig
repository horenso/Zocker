const unicode = @import("std").unicode;

pub const Suit = enum(u8) {
    diamonds,
    clubs,
    hearts,
    spades,

    pub fn toSymbol(self: Suit) u16 {
        return switch (self) {
            .diamonds => '♦',
            .clubs => '♣',
            .hearts => '♥',
            .spades => '♠',
        };
    }

    pub fn fromInt(num: i8) Suit {
        return switch (num) {
            0...3 => @intToEnum(Suit, num),
            else => unreachable,
        };
    }
};
