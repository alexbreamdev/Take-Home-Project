//
//  SettingsView.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 25.05.2023.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(UserDefaultKeys.hapticsEnabled) var hapticsEnabled: Bool = false
    var body: some View {
        NavigationStack {
            Form {
                haptics
            }
            .navigationTitle("Settings")
        }
    }
}

private extension SettingsView {
    var haptics: some View {
        Toggle("Enable Haptics", isOn: $hapticsEnabled)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
