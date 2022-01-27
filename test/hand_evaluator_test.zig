const std = @import("std");
const print = @import("std").debug.print;
const fs = @import("std").fs;
const split = @import("std").mem.split;
const assert = @import("std").debug.assert;
const expect = @import("std").testing.expect;
const expectEqual = @import("std").testing.expectEqual;
const HandEvaluator = @import("hand_evaluator").HandEvaluator;
const join = @import("std").mem.join;
const nameCast = @import("std").enums.nameCast;
const trim = @import("std").mem.trim;
const eql = @import("std").mem.eql;
const mem = @import("std").mem;

const Card = @import("model").Card;
const HandType = @import("model").HandType;

pub fn print_list_of_cards(cards: []const Card) void {
    for (cards) |card| {
        print("{s} ", .{card.toString()});
    }
}

pub fn read_cards(cards: []Card, string: []const u8) void {
    var index: u8 = 0;
    var card_iter = std.mem.tokenize(u8, string, " ");
    while (card_iter.next()) |card_str| {
        const new_card = Card.fromString(card_str) catch unreachable;
        cards[index] = new_card;
        index += 1;
    }
    assert(index == cards.len);
}

pub fn compare_cards(expected: []const Card, actual: []const Card) !void {
    assert(expected.len == actual.len);
    var index: u8 = 0;
    while (index < expected.len) {
        try expectEqual(expected[index].suit, actual[index].suit);
        try expectEqual(expected[index].value, actual[index].value);
    }
}

test "test evaluations.txt" {
    var f = try fs.cwd().openFile("test/evaluations.txt", fs.File.OpenFlags{ .read = true });
    defer f.close();

    const reader = f.reader();
    var buffer: [200]u8 = undefined;

    var line_number: u16 = 1;
    var in_section: [100]u8 = mem.zeroes([100]u8);
    print("\n", .{}); // Just makes the tests look nicer
    while (try reader.readUntilDelimiterOrEof(buffer[0..], '\n')) |line| : (line_number += 1) {
        // Skip empty lines and comments
        if (line.len == 0) continue;
        if (std.mem.startsWith(u8, line, "#")) {
            mem.copy(u8, in_section[0..], line);
            print("Comment: {s}\n", .{in_section});
            continue;
        }

        var iter = split(u8, line, " - ");

        const input_cards_str = iter.next() orelse unreachable;
        var input_cards: [7]Card = undefined;
        read_cards(input_cards[0..], input_cards_str);

        const expected_hand_type_str = iter.next() orelse unreachable;
        const expected_hand_type = HandType.fromString(expected_hand_type_str) catch unreachable;

        const expected_hand_cards_str = iter.next() orelse unreachable;
        var expected_hand_cards: [5]Card = undefined;
        read_cards(expected_hand_cards[0..], expected_hand_cards_str);

        var evaluator = HandEvaluator.new();
        const actual_hand = evaluator.rateHand(input_cards);
        errdefer {
            print("Line number: {d}\n", .{line_number});
            print("Testcase: {s}\n", .{line});
            // if (in_section) |section| {
            print("In section: {s}\n", .{in_section});
            // }
        }
        try expectEqual(expected_hand_type, actual_hand.hand_type);
        try expectEqual(expected_hand_cards, actual_hand.cards);
        // line_number += 1;
    }

    assert(true);
}
