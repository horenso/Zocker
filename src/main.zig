const std = @import("std");
const Card = @import("model/model.zig").Card;
const HandEvaluator = @import("hand_evaluator.zig").HandEvaluator;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var card_list: [7]Card = [_]Card{
        Card{ .value = .ace, .suit = .hearts },
        Card{ .value = .two, .suit = .diamonds },
        Card{ .value = .three, .suit = .hearts },
        Card{ .value = .four, .suit = .spades },
        Card{ .value = .five, .suit = .diamonds },
        Card{ .value = .six, .suit = .hearts },
        Card{ .value = .seven, .suit = .hearts },
    };

    var hand_evaluator = HandEvaluator.new();
    const hand = hand_evaluator.rateHand(card_list);

    try stdout.print("'{}'", .{hand});
}
