//
//  SquatCoachScript.swift
//  Squat Sensei
//

import Foundation

struct CoachLine {
    let displayCount: String
    let caption: String
    let audioFileName: String?
}

enum SquatCoachScript {
    static let totalReps = 20

    private static let lines: [CoachLine] = [
        CoachLine(displayCount: "1", caption: "", audioFileName: nil),
        CoachLine(displayCount: "2", caption: "", audioFileName: nil),
        CoachLine(displayCount: "3", caption: "You're not pushing yourself up, you're pushing the Earth down!", audioFileName: "rep_03"),
        CoachLine(displayCount: "4", caption: "Defy gravity! Make Isaac Newton cry!", audioFileName: "rep_04"),
        CoachLine(displayCount: "5", caption: "You Can Do it!", audioFileName: "rep_05"),
        CoachLine(displayCount: "6", caption: "Stop staring at the dust on the floor, look at your future!", audioFileName: "rep_06"),
        CoachLine(displayCount: "7", caption: "Your muscles aren't crying, they're cheering for you!", audioFileName: "rep_07"),
        CoachLine(displayCount: "8", caption: "Eight! Next is nine!", audioFileName: "rep_08"),
        CoachLine(displayCount: "9", caption: "Night! Come On! Last one!", audioFileName: "rep_09"),
        CoachLine(displayCount: "9.1", caption: "Nine point one! Your thighs are shaking!", audioFileName: "rep_10"),
        CoachLine(displayCount: "9.2", caption: "Nine point two! Don't quit on me!", audioFileName: "rep_11"),
        CoachLine(displayCount: "9.3", caption: "Nine point three! Gravity is just a number!", audioFileName: "rep_12"),
        CoachLine(displayCount: "9.4", caption: "Nine point four! Breathe in, push up!", audioFileName: "rep_13"),
        CoachLine(displayCount: "9.5", caption: "Nine point five! We are halfway to ten!", audioFileName: "rep_14"),
        CoachLine(displayCount: "9.6", caption: "Nine point six! The floor is lava!", audioFileName: "rep_15"),
        CoachLine(displayCount: "9.7", caption: "Nine point seven! Lift like your ex is watching!", audioFileName: "rep_16"),
        CoachLine(displayCount: "9.8", caption: "Nine point eight! Are you counting? I'm not!", audioFileName: "rep_17"),
        CoachLine(displayCount: "9.9", caption: "Nine point nine! One more to ten!", audioFileName: "rep_18"),
        CoachLine(displayCount: "9.99", caption: "Nine point nine nine!", audioFileName: "rep_19"),
        CoachLine(displayCount: "10", caption: "TEN! You just did twenty reps! Your quads are now officially thicker than the Golden Gate Bridge cables!", audioFileName: "rep_20")
    ]

    static func line(for rep: Int) -> CoachLine? {
        guard rep >= 1, rep <= lines.count else { return nil }
        return lines[rep - 1]
    }
}
