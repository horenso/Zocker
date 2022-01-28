const model = @import("model/model.zig");
const Card = model.Card;
const Hand = model.Hand;
const HandType = model.HandType;
const CardValue = model.CardValue;
const CardSuit = model.CardSuit;
const assert = @import("std").debug.assert;
const print = @import("std").debug.print;
const mem = @import("std").mem;

pub const HandEvaluator = struct {
    card_table: [4][14]?Card = undefined,
    value_histogram: [14]u8 = undefined,
    best_hand_found: ?Hand = null,

    pub fn new() HandEvaluator {
        return HandEvaluator{};
    }

    pub fn rateHand(self: *HandEvaluator, cards: [7]Card) Hand {
        self.init();
        self.fillCardTableAndHistogram(cards);
        self.checkFlushAndStraightFlush();
        if (self.best_hand_found) |best_hand| {
            if (best_hand.hand_type.strongerOrEquals(HandType.straight_flush)) {
                return best_hand;
            }
        } else {
            // we only care about regular straights if we don't have a flush already
            self.checkStraight();
        }
        self.checkValueCombinations();
        return self.best_hand_found.?;
    }

    fn init(self: *HandEvaluator) void {
        self.card_table = mem.zeroes([4][14]?Card);
        self.value_histogram = mem.zeroes([14]u8);
        self.best_hand_found = null;
    }

    // Fills the cards into the card_table and also fills the value_historgram
    // E.g the cards 3D AS QH KS 7H JD 8S get placed in the table like this:
    // +----------+---+---+---+---+---+---+---+---+---+----+----+----+----+----+
    // |          | A | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | J  | Q  | K  | A  |
    // +----------+---+---+---+---+---+---+---+---+---+----+----+----+----+----+
    // | diamonds |   |   | X |   |   |   |   |   |   |    | X  |    |    |    |
    // | clubs    |   |   |   |   |   |   |   |   |   |    |    |    |    |    |
    // | hearts   |   |   |   |   |   |   | X |   |   |    |    | X  |    |    |
    // | spades   | X |   |   |   |   |   |   | X |   |    |    |    | X  | X  |
    // +----------+---+---+---+---+---+---+---+---+---+----+----+----+----+----+
    // After that, the evaluation becames a matter of identifying patterns
    // Note: ace gets inserted twice, once at the front and once at the back,
    // this makes checking for straights easier.
    fn fillCardTableAndHistogram(self: *HandEvaluator, cards: [7]Card) void {
        for (cards) |card| {
            var value_index: u8 = @enumToInt(card.value) - 1;
            var suit_index: u8 = @enumToInt(card.suit);
            self.card_table[suit_index][value_index] = card;
            self.putInHistogram(card);
            if (card.value == .ace) {
                self.card_table[suit_index][0] = card;
            }
        }
    }

    fn removeFromCardTable(self: *HandEvaluator, card: Card) void {
        var value_index: u8 = @enumToInt(card.value) - 1;
        var suit_index: u8 = @enumToInt(card.suit);
        self.card_table[suit_index][value_index] = null;
        if (card.value == .ace) {
            self.card_table[suit_index][0] = null;
        }
    }

    // fn setTable(self: *HandEvaluator, value: CardValue, suit: CardSuit, card: Card) void {
    //     var value_index: u8 = @enumToInt(value) - 1;
    //     var suit_index: u8 = @enumToInt(suit);
    //     self.card_table[suit_index][value_index] = card;
    // }

    fn putInHistogram(self: *HandEvaluator, card: Card) void {
        var value_index: u8 = @enumToInt(card.value) - 1;
        self.value_histogram[value_index] += 1;
        if (card.value == .ace) {
            self.value_histogram[0] += 1;
        }
    }

    fn checkFlushAndStraightFlush(self: *HandEvaluator) void {
        for (self.card_table) |row, suit_index| {
            var flush_streak: u8 = 0;
            var straight_flush_streak: u8 = 0;
            var value_index = row.len;

            while (value_index > 0) {
                value_index -= 1;
                if (self.card_table[suit_index][value_index]) |_| {
                    // Ace is already counted at position 13
                    if (value_index != 0) flush_streak += 1;
                    straight_flush_streak += 1;
                } else {
                    straight_flush_streak = 0;
                    continue;
                }
                if (straight_flush_streak == 5) {
                    var straight_flush_cards: [5]Card = undefined;
                    var i: u8 = 0;
                    while (i < straight_flush_cards.len) : (i += 1) {
                        // .? because we know that the previous five cards must be
                        // present in the table since we hit a straight_flush
                        straight_flush_cards[i] = self.card_table[suit_index][value_index + 4 - i].?;
                    }
                    const type_of_straight_flush = if (straight_flush_cards[0].value == CardValue.ace)
                        HandType.royal_flush
                    else
                        HandType.straight_flush;
                    self.best_hand_found = Hand{
                        .hand_type = type_of_straight_flush,
                        .cards = straight_flush_cards,
                    };
                    // straigt_flush is the best possible hand, so we can stop looking
                    return;
                }
                if (flush_streak == 5) {
                    var flush_cards: [5]Card = undefined;
                    var i: u8 = 5;
                    var offset: u8 = 0;
                    while (i >= 1) : (offset += 1) {
                        if (self.card_table[suit_index][value_index + offset]) |card| {
                            flush_cards[i - 1] = card;
                            i -= 1;
                        }
                    }
                    self.best_hand_found = Hand{
                        .hand_type = HandType.flush,
                        .cards = flush_cards,
                    };
                    // we don't want to find weaker flushes at this point
                    flush_streak = 0;
                }
            }
        }
    }

    fn checkStraight(self: *HandEvaluator) void {
        var straight_streak: u8 = 0;
        var value_index = self.card_table[0].len;

        while (value_index > 0) {
            value_index -= 1;
            for (self.card_table) |card, suit_index| {
                _ = card;
                _ = suit_index;
                _ = straight_streak;
                _ = self;
            }
        }
    }

    fn checkValueCombinations(self: *HandEvaluator) void {
        _ = self;
        return;
    }

    fn addKickers(self: *HandEvaluator, number_of_kickers: u8) void {
        _ = self;
        _ = number_of_kickers;
        return;
    }

    pub fn printTable(self: *HandEvaluator) void {
        print("Table:\n", .{});
        for (self.card_table) |row| {
            for (row) |maybe_card| {
                if (maybe_card) |card| {
                    print("{s} ", .{card.toString()});
                } else {
                    print("__ ", .{});
                }
            }
            print("\n", .{});
        }
    }
};
