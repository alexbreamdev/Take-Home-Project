//
//  HapticManager.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 25.05.2023.
//

import Foundation
import UIKit
// MARK: - Buzzing of iPhone on actions
// fileprivate restricts access to only from inside the file
fileprivate final class HapticsManager {
    static let shared = HapticsManager()
    
    private let feedback = UINotificationFeedbackGenerator()
    
    private init() {
        
    }
    
    func trigger(_ notification: UINotificationFeedbackGenerator.FeedbackType) {
        feedback.notificationOccurred(notification)
    }
}
// general interface func to use haptic manager
func haptic(_ notification: UINotificationFeedbackGenerator.FeedbackType) {
    if UserDefaults.standard.bool(forKey: UserDefaultKeys.hapticsEnabled) == true {
        HapticsManager.shared.trigger(notification)
    }
}

