const HandEvaluator = @import("hand_evaluator.zig").HandEvaluator;
const model = @import("model/model.zig");
const Card = model.Card;
const CardSuit = model.CardSuit;
const CardValue = model.CardValue;
const print = @import("std").debug.print;

pub fn main() void {
    var a: HandEvaluator = HandEvaluator{};
    const cards: [7]Card = [_]Card{
        Card{ .value = CardValue.nine, .suit = CardSuit.hearts },
        Card{ .value = CardValue.three, .suit = CardSuit.spades },
        Card{ .value = CardValue.two, .suit = CardSuit.hearts },
        Card{ .value = CardValue.ace, .suit = CardSuit.clubs },
        Card{ .value = CardValue.king, .suit = CardSuit.spades },
        Card{ .value = CardValue.ten, .suit = CardSuit.diamonds },
        Card{ .value = CardValue.five, .suit = CardSuit.hearts },
    };
    for (cards) |card| {
        print("{s}\n", .{card.toChar()});
    }
    const card_slice: []const Card = cards[0..];
    _ = a.rateHand(card_slice);
}
