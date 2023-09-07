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
    @State var showRemindersSheet: Bool = false
    
    let eventStore: EKEventStore = EKEventStore()
    
    var body: some View {
        ScrollView {
            VStack {
                DescriptionView()
                IngredientsView()
                InstructionsView()
            }
            .padding([.horizontal, .bottom])
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
        .navigationBarTitleDisplayMode(.automatic)
        .background(
            ZStack {
                Image(uiImage: document.image)
                    .ignoresSafeArea(.all)
                    .scaledToFill()
                Rectangle()
                    .fill(.regularMaterial)
            }
        )
    }
}

struct Inactive_Preview: PreviewProvider {
    static var previews: some View {
        Inactive()
            .environmentObject(RecipeDocument.exampleRecipe)
    }
}

struct Inactive_Empty_Preview: PreviewProvider {
    static var previews: some View {
        Inactive()
            .environmentObject(RecipeDocument.emptyRecipe)
    }
}
