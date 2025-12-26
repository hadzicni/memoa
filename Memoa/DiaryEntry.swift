//
//  DiaryEntry.swift
//  Memoa
//
//  Created by Nikola Hadzic on 26.12.2025.
//

import Foundation
import SwiftUI

struct DiaryEntry: Identifiable, Codable {
    var id = UUID()
    var title: String
    var content: String
    var date: Date
    var mood: Mood
    var photoData: [Data]?
    var audioData: Data?
    var audioDuration: TimeInterval?
    
    enum Mood: String, Codable, CaseIterable {
        case happy = "😊"
        case neutral = "😐"
        case sad = "😢"
        case excited = "🤩"
        case anxious = "😰"
        case calm = "😌"
        
        var name: String {
            switch self {
            case .happy: return "Happy"
            case .neutral: return "Neutral"
            case .sad: return "Sad"
            case .excited: return "Excited"
            case .anxious: return "Anxious"
            case .calm: return "Calm"
            }
        }
    }
    
    var hasMedia: Bool {
        (photoData?.isEmpty == false) || audioData != nil
    }
}
