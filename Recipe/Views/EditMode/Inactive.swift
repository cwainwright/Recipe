//
//  Inactive.swift
//  Recipe
//
//  Created by Christopher Wainwright on 30/07/2023.
//

import SwiftUI
import EventKit

struct Inactive: View {
    
    @EnvironmentObject var document: RecipeDocument
    
    @State private var showRemindersSheet: Bool = false
    let eventStore: EKEventStore = EKEventStore()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    if geometry.size.width > 600 {
                        VStack {
                            HStack {
                                ImageView()
                                IngredientsView()
                            }
                            DescriptionView()
                            InstructionsView()
                        }
                    } else {
                        ImageView()
                        DescriptionView()
                        IngredientsView()
                        InstructionsView()
                    }
                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        showRemindersSheet.toggle()
                    } label: {
                        Label("Export Shopping List", systemImage: "checklist.unchecked")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .sheet(isPresented: $showRemindersSheet) {
            CalendarPicker(eventStore: eventStore)
                .onAppear {
                    switch EKEventStore.authorizationStatus(for: .reminder) {
                        case .authorized:
                            print("Authorized")
                        case .denied:
                            print("Access denied")
                        case .notDetermined:
                            eventStore.requestAccess(to: .reminder) { granted, error in
                                if granted {
                                    print("Access granted")
                                } else {
                                    print("Access denied")
                                }
                            }
                            print("Not Determined")
                        default:
                            print("Case Default")
                    }
                }
        }
        .background(
            ZStack {
                Image(uiImage: document.image)
                    .resizable()
                    .scaledToFill()
                Rectangle()
                    .fill(.thinMaterial)
            }
            .ignoresSafeArea()
        )
    }
}

struct Inactive_Preview: PreviewProvider {
    static var previews: some View {
        RecipeView()
            .environmentObject(RecipeDocument.example)
            .previewInterfaceOrientation(.portrait)
            .previewDisplayName("Example")
        RecipeView()
            .environmentObject(RecipeDocument.empty)
            .previewInterfaceOrientation(.portrait)
            .previewDisplayName("Empty")
    }
}
