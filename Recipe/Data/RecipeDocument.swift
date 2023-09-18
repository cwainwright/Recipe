//
//  RecipeDocument.swift
//  Recipe
//
//  Created by Christopher Wainwright on 26/06/2023.
//

import SwiftUI
import UniformTypeIdentifiers
import EventKit
import Combine

extension UTType {
    static var exampleRecipe: UTType {
        UTType(exportedAs: "com.recipe.recipe")
    }
}

final class RecipeDocument: ReferenceFileDocument {
    
    typealias Snapshot = (Recipe, UIImage)
    
    @Published var recipe: Recipe
    @Published var image: UIImage = UIImage(named: "food_example")!
    
    var undoManager: UndoManager? = nil
    
    func registerUndoManager(_ newUndoManager: UndoManager?) {
        if undoManager == nil { undoManager = newUndoManager }
    }

    static var readableContentTypes: [UTType] { [.exampleRecipe] }
    
    func snapshot(contentType: UTType) throws -> (Recipe, UIImage) {
        // return a copy of recipe object
        (recipe, image)
    }
    
    
    init() {
        // produce example recipe
        recipe = Recipe()
    }
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    init(description: String="", duration: Int=30, serves: Int=4, ingredients: Array<Ingredient>=[], instructions: Array<Instruction>=[], utensils: Array<Utensil>=[]) {
        recipe = .init(description: description, duration: duration, serves: serves, instructions: instructions, ingredients: ingredients, utensils: utensils)
    }
    
    init(configuration: ReadConfiguration) throws {
        // decode recipe from file
        guard let wrappers = configuration.file.fileWrappers
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        // decode recipe data
        guard let contentWrapper = wrappers["content"]
        else{
            throw CocoaError(.fileReadUnsupportedScheme)
        }
        do {
            let contentData = contentWrapper.regularFileContents
            self.recipe = try JSONDecoder().decode(Recipe.self, from: contentData!)
        } catch {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        // decode image data
        guard let imageWrapper = wrappers["image"]
        else {
            throw CocoaError(.fileReadUnsupportedScheme)
        }
        let imageData = imageWrapper.regularFileContents
        self.image = UIImage(data: imageData ?? Data()) ?? UIImage(imageLiteralResourceName: "food_example")
    }
    
    func fileWrapper(snapshot: (Recipe, UIImage), configuration: WriteConfiguration) throws -> FileWrapper {
        // encode recipe to file wrapper
        let contentEncoder = JSONEncoder()
        let contentData = try contentEncoder.encode(snapshot.0)
        let contentWrapper = FileWrapper(regularFileWithContents: contentData)
        
        // encode image data to file wrapper
        let imageData = image.jpegData(compressionQuality: 1)
        let imageWrapper = FileWrapper(regularFileWithContents: imageData ?? Data())
        
        // wrap files in directory file wrapper
        let package = FileWrapper(directoryWithFileWrappers: ["content": contentWrapper, "image": imageWrapper])
        
        print("\n\nSaving Recipe Object:")
        return package
    }
}

// Example Recipe
extension RecipeDocument {
    static var example = RecipeDocument(
        recipe: Recipe.example
    )
    static var empty = RecipeDocument(
        recipe: Recipe.empty
    )
}

extension RecipeDocument {
    // Document Metadata
    func setDescription(to newValue: String) {
        let oldValue = recipe.description
        
        recipe.description = newValue
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.setDescription(to: oldValue)
        }
    }
    
    func setServes(to newValue: Int) {
        let oldValue = recipe.serves
        
        recipe.serves = newValue
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.setServes(to: oldValue)
        }
    }
    
    func setDuration(to newValue: Int) {
        let oldValue = recipe.duration
        
        recipe.duration = newValue
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.setDuration(to: oldValue)
        }
    }
    
    func setImage(to newValue: UIImage) {
        let oldValue = image
        
        image = newValue
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.setImage(to: oldValue)
        }
    }
}

extension RecipeDocument {
    // Ingredient Functions
    func setIngredientName(of index: Int, to newValue: String) {
        let oldValue = recipe.ingredients[index].name
        
        recipe.ingredients[index].name = newValue
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.setIngredientName(of: index, to: oldValue)
        }
    }
    
    func setIngredientUnit(of index: Int, to newValue: String) {
        let oldValue = recipe.ingredients[index].unit
        
        recipe.ingredients[index].unit = newValue
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.setIngredientUnit(of: index, to: oldValue)
        }
    }
    
    func setIngredientMeasure(of index: Int, to newValue: Float) {
        let oldValue = recipe.ingredients[index].measure
        
        recipe.ingredients[index].measure = newValue
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.setIngredientMeasure(of: index, to: oldValue)
        }
    }
    
    // Array<Ingredient> Functions
    func appendIngredient(_ newIngredient: Ingredient) {
        let oldCount = recipe.ingredients.count
        
        recipe.ingredients.append(newIngredient)
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.deleteIngredient(at: oldCount)
        }
    }
    
    func insertIngredient(_ newIngredient: Ingredient, at i: Int) {
        recipe.ingredients.insert(newIngredient, at: i)
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.deleteIngredient(at: i)
        }
    }
    
    func deleteIngredient(at index: Int) {
        let oldIngredient = recipe.ingredients[index]
        
        recipe.ingredients.remove(at: index)
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.insertIngredient(oldIngredient, at: index)
        }
    }
    
    func deleteIngredients(atOffsets offsets: IndexSet) {
        let oldIngredients = recipe.ingredients
        
        recipe.ingredients.remove(atOffsets: offsets)
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.replaceIngredients(with: oldIngredients)
        }
    }
    
    func moveIngredients(fromOffsets: IndexSet, toOffset: Int) {
        let oldIngredients = recipe.ingredients
        
        recipe.ingredients.move(fromOffsets: fromOffsets, toOffset: toOffset)
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.replaceIngredients(with: oldIngredients)
        }
    }
    
    func replaceIngredients(with newIngredients: Array<Ingredient>) {
        let oldIngredients = recipe.ingredients
        
        recipe.ingredients = newIngredients
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.replaceIngredients(with: oldIngredients)
        }
    }
}

extension RecipeDocument {
    // Ingredient Functions
    func setInstructionDetail(of index: Int, to newValue: String) {
        let oldValue = recipe.instructions[index].detail
        
        recipe.instructions[index].detail = newValue
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.setInstructionDetail(of: index, to: oldValue)
        }
    }
    
    // Array<Instruction> Functions
    func appendInstruction(_ newInstruction: Instruction) {
        let oldCount = recipe.instructions.count
        
        recipe.instructions.append(newInstruction)
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.deleteInstruction(at: oldCount)
        }
    }
    
    func insertInstruction(_ newInstruction: Instruction, at i: Int) {
        recipe.instructions.insert(newInstruction, at: i)
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.deleteInstruction(at: i)
        }
    }
    
    func deleteInstruction(at index: Int) {
        let oldInstruction = recipe.instructions[index]
        
        recipe.instructions.remove(at: index)
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.insertInstruction(oldInstruction, at: index)
        }
    }
    
    func deleteInstructions(atOffsets offsets: IndexSet) {
        let oldInstructions = recipe.instructions
        
        recipe.instructions.remove(atOffsets: offsets)
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.replaceInstructions(with: oldInstructions)
        }
    }
    
    func moveInstructions(fromOffsets: IndexSet, toOffset: Int) {
        let oldInstructions = recipe.instructions
        
        recipe.instructions.move(fromOffsets: fromOffsets, toOffset: toOffset)
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.replaceInstructions(with: oldInstructions)
        }
    }
    
    func replaceInstructions(with newInstructions: Array<Instruction>) {
        let oldInstructions = recipe.instructions
        
        recipe.instructions = newInstructions
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.replaceInstructions(with: oldInstructions)
        }
    }
}

// Generate Reminders
extension RecipeDocument {
    func generateReminders(eventStore: EKEventStore, calendar: EKCalendar) {
        do {
            for ingredient in recipe.ingredients {
                try ingredient.toReminder(eventStore: eventStore, calendar: calendar)
            }
        } catch {
            print("Missing Calendar or EKStore")
            return
        }
        do {
            try eventStore.commit()
        } catch {
            print("EKStore could not commit changes")
        }
    }
}

