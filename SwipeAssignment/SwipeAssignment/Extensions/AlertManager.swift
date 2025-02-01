//
//  AlertManager.swift
//  SwipeAssignment
//
//  Created by Ashwin Kumar on 30/01/25.
//

import SwiftUI

@Observable
class AlertManager  {
    static let shared = AlertManager()
    
    var alert: AppAlerts? = nil
    var showAlert: Bool = false
    
    private init() {}
    
    func show(_ alert: AppAlerts) {
        DispatchQueue.main.async {
            self.alert = alert
            self.showAlert = true
        }
    }
}
