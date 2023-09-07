//
//  CalendarPicker.swift
//  Recipe
//
//  Created by Christopher Wainwright on 04/09/2023.
//

import Foundation
import UIKit
import SwiftUI
import EventKit
import EventKitUI

struct CalendarPicker: UIViewControllerRepresentable {
    
    @EnvironmentObject var document: RecipeDocument
    
    typealias UIViewControllerType = UINavigationController
    
    let eventStore: EKEventStore
    var calendar: EKCalendar? = nil
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let calendarPicker = EKCalendarChooser(selectionStyle: .single, displayStyle: .writableCalendarsOnly, entityType: .reminder, eventStore: eventStore)
        calendarPicker.showsCancelButton = true
        calendarPicker.showsDoneButton = true
        calendarPicker.delegate = context.coordinator
        let navViewController = UINavigationController(rootViewController: calendarPicker)
        return navViewController
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    final class Coordinator: NSObject, UINavigationControllerDelegate, EKCalendarChooserDelegate {
        var parent: CalendarPicker
        
        init(parent: CalendarPicker) {
            self.parent = parent
        }
        
        func calendarChooserDidFinish(_ calendarPicker: EKCalendarChooser) {
            guard let calendar = parent.calendar else {
                return
            }
            parent.document.generateReminders(eventStore: parent.eventStore, calendar: calendar)
            calendarPicker.dismiss(animated: true)
        }
        
        func calendarChooserDidCancel(_ calendarPicker: EKCalendarChooser) {
            calendarPicker.dismiss(animated: true)
        }
        
        func calendarChooserSelectionDidChange(_ calendarPicker: EKCalendarChooser) {
            parent.calendar = calendarPicker.selectedCalendars.first
        }
    }
}
