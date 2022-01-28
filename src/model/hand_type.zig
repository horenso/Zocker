const eql = @import("std").mem.eql;
const ValueError = @import("value_error.zig").ValueError;

pub const HandType = enum {
    high_card,
    pair,
    two_pair,
    three_of_a_kind,
    straight,
    flush,
    full_house,
    four_of_a_kind,
    straight_flush,
    royal_flush,

    pub fn fromString(string: []const u8) ValueError!HandType {
        if (eql(u8, string, "high_card")) return .high_card;
        if (eql(u8, string, "pair")) return .pair;
        if (eql(u8, string, "two_pair")) return .two_pair;
        if (eql(u8, string, "three_of_a_kind")) return .three_of_a_kind;
        if (eql(u8, string, "straight")) return .straight;
        if (eql(u8, string, "flush")) return .flush;
        if (eql(u8, string, "full_house")) return .full_house;
        if (eql(u8, string, "four_of_a_kind")) return .four_of_a_kind;
        if (eql(u8, string, "straight_flush")) return .straight_flush;
        if (eql(u8, string, "royal_flush")) return .royal_flush;
        return ValueError.InvalidHandTypeString;
    }

    pub fn strongerOrEquals(self: HandType, other: HandType) bool {
        return @enumToInt(self) > @enumToInt(other);
    }
};
