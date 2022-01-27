const HandType = @import("hand_type.zig").HandType;
const Card = @import("card.zig").Card;
const mem = @import("std").mem;

pub const Hand = struct {
    hand_type: HandType,
    cards: [5]Card,

    // pub fn sort(self: Hand, other: Hand) int {
    //     return 0;
    // }
};
