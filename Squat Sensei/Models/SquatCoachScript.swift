//
//  SquatCoachScript.swift
//  Squat Sensei
//

import Foundation

struct CoachLine {
    let displayCount: String
    let caption: String
    let spoken: String?
}

enum SquatCoachScript {
    static let totalReps = 20

    private static let lines: [CoachLine] = [
        CoachLine(displayCount: "1", caption: "", spoken: nil),
        CoachLine(displayCount: "2", caption: "", spoken: nil),
        CoachLine(displayCount: "3", caption: "You're not pushing yourself up, you're pushing the Earth down!", spoken: "You're not pushing yourself up, you're pushing the Earth down!"),
        CoachLine(displayCount: "4", caption: "Defy gravity! Make Isaac Newton cry!", spoken: "Defy gravity! Make Isaac Newton cry!"),
        CoachLine(displayCount: "5", caption: "You Can Do it!", spoken: "You Can Do it!"),
        CoachLine(displayCount: "6", caption: "Stop staring at the dust on the floor, look at your future!", spoken: "Stop staring at the dust on the floor, look at your future!"),
        CoachLine(displayCount: "7", caption: "Your muscles aren't crying, they're cheering for you!", spoken: "Your muscles aren't crying, they're cheering for you!"),
        CoachLine(displayCount: "8", caption: "Eight! Next is nine!", spoken: "Eight! Next is nine!"),
        CoachLine(displayCount: "9", caption: "Night! Come On! Last one!", spoken: "Night! Come On! Last one!"),
        CoachLine(displayCount: "9.1", caption: "Nine point one! Your thighs are shaking!", spoken: "Nine point one! Your thighs are shaking!"),
        CoachLine(displayCount: "9.2", caption: "Nine point two! Don't quit on me!", spoken: "Nine point two! Don't quit on me!"),
        CoachLine(displayCount: "9.3", caption: "Nine point three! Gravity is just a number!", spoken: "Nine point three! Gravity is just a number!"),
        CoachLine(displayCount: "9.4", caption: "Nine point four! Breathe in, push up!", spoken: "Nine point four! Breathe in, push up!"),
        CoachLine(displayCount: "9.5", caption: "Nine point five! We are halfway to ten!", spoken: "Nine point five! We are halfway to ten!"),
        CoachLine(displayCount: "9.6", caption: "Nine point six! The floor is lava!", spoken: "Nine point six! The floor is lava!"),
        CoachLine(displayCount: "9.7", caption: "Nine point seven! Lift like your ex is watching!", spoken: "Nine point seven! Lift like your ex is watching!"),
        CoachLine(displayCount: "9.8", caption: "Nine point eight! Are you counting? I'm not!", spoken: "Nine point eight! Are you counting? I'm not!"),
        CoachLine(displayCount: "9.9", caption: "Nine point nine! One more to ten!", spoken: "Nine point nine! One more to ten!"),
        CoachLine(displayCount: "9.99", caption: "Nine point nine nine!", spoken: "Nine point nine nine!"),
        CoachLine(displayCount: "10", caption: "TEN! You just did twenty reps! Your quads are now officially thicker than the Golden Gate Bridge cables!", spoken: "TEN! You just did twenty reps! Your quads are now officially thicker than the Golden Gate Bridge cables!")
    ]

    static func line(for rep: Int) -> CoachLine? {
        guard rep >= 1, rep <= lines.count else { return nil }
        return lines[rep - 1]
    }
}
