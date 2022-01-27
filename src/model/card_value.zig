const ValueError = @import("value_error.zig").ValueError;

pub const CardValue = enum(u8) {
    two = 2,
    three = 3,
    four = 4,
    five = 5,
    six = 6,
    seven = 7,
    eight = 8,
    nine = 9,
    ten = 10,
    jack = 11,
    queen = 12,
    king = 13,
    ace = 14,

    pub fn fromChar(char: u8) ValueError!CardValue {
        return switch (char) {
            '2'...'9' => @intToEnum(CardValue, char - '0'),
            'T' => .ten,
            'J' => .jack,
            'Q' => .queen,
            'K' => .king,
            'A' => .ace,
            else => ValueError.InvalidCharacter,
        };
    }

    pub fn toChar(self: CardValue) u8 {
        return switch (self) {
            .two => '2',
            .three => '3',
            .four => '4',
            .five => '5',
            .six => '6',
            .seven => '7',
            .eight => '8',
            .nine => '9',
            .ten => 'T',
            .jack => 'J',
            .queen => 'Q',
            .king => 'K',
            .ace => 'A',
        };
    }

    pub fn toString(self: CardValue) []const u8 {
        return @tagName(self);
    }
};
