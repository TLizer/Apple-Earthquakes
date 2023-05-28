//
//  ContentViewState.swift
//  Earthquakes-iOS
//
//  Created by Tomasz Lizer on 28/05/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI

final class ContentViewState: ObservableObject {
    @Published var editMode: EditMode = .inactive
    @Published var selectMode: SelectMode = .inactive
    @Published var selection: Set<String> = []
    @Published var isLoading = false
    @Published var error: QuakeError?
    @Published var hasError = false
    
    var title: String {
        if selectMode.isActive || selection.isEmpty {
            return "Earthquakes"
        } else {
            return "\(selection.count) Selected"
        }
    }
    
    var refreshButtonDisabled: Bool {
        isLoading || editMode == .active
    }
    
    var deleteButtonDisabled: Bool {
        isLoading || selection.isEmpty
    }
    
    var showDeleteButton: Bool {
        editMode == .active
    }
}
