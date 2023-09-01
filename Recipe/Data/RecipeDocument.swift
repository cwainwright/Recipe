//
//  RecipeDocument.swift
//  Recipe
//
//  Created by Christopher Wainwright on 26/06/2023.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var exampleRecipe: UTType {
        UTType(importedAs: "com.recipe.recipe")
    }
}

final class RecipeDocument: ReferenceFileDocument {
    
    typealias Snapshot = (Recipe, UIImage)
    
    @Published var recipe: Recipe
    @Published var image: UIImage = UIImage(named: "food_example")!

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
    
    init(description: String="", ingredients: Array<Ingredient>=[], instructions: Array<Instruction>=[], utensils: Array<Utensil>=[]) {
        recipe = .init(description: description, instructions: instructions, ingredients: ingredients, utensils: utensils)
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
    static var exampleRecipe = RecipeDocument(
        recipe: Recipe.example
    )
    static var emptyRecipe = RecipeDocument(
        recipe: Recipe.empty
    )
}

// Description Functions
extension RecipeDocument {
    func registerUndoDescriptionChange(oldDescription: String, undoManager: UndoManager? = nil) {
        let newDesciption = recipe.description
        
        registerUndoDescriptionChange(newDescription: newDesciption, oldDescription: oldDescription, undoManager: undoManager)
    }
    
    func registerUndoDescriptionChange(newDescription: String, oldDescription: String, undoManager: UndoManager? = nil) {
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.recipe.description = oldDescription
            
            undoManager?.registerUndo(withTarget: self) { doc in
                doc.recipe.description = newDescription
            }
        }
    }
}

// Image Functions
extension RecipeDocument {
    func registerUndoImageChange(newImage: UIImage, undoManager: UndoManager? = nil) {
        let oldImage = self.image
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.image = oldImage
            
            undoManager?.registerUndo(withTarget: self) { doc in
                doc.image = newImage
            }
        }
    }
}

// Ingredient Functions
extension RecipeDocument {
    
    func addIngredient(ingredient: Ingredient, undoManager: UndoManager? = nil) {
        recipe.ingredients.append(Ingredient())
        let count = recipe.ingredients.count
        undoManager?.registerUndo(withTarget: self) { doc in
            withAnimation {
                doc.deleteIngredient(index: count - 1, undoManager: undoManager)
            }
        }
    }
    
    /// Deletes an ingredient at specified index
    func deleteIngredient(index: Int, undoManager: UndoManager? = nil) {
        let oldItems = recipe.ingredients
        withAnimation {
            _ = recipe.ingredients.remove(at: index)
        }
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.replaceIngredients(with: oldItems, undoManager: undoManager)
        }
    }
    
    /// Replaces the existing items with a new set of items.
    func replaceIngredients(with newIngredients: [Ingredient], undoManager: UndoManager? = nil, animation: Animation? = .default) {
        let oldIngredients = recipe.ingredients
        
        withAnimation(animation) {
            recipe.ingredients = newIngredients
        }
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.replaceIngredients(with: oldIngredients, undoManager: undoManager, animation: animation)
        }
    }

    func deleteIngredients(offsets: IndexSet, undoManager: UndoManager? = nil) {
        let oldIngredients = recipe.ingredients
        withAnimation {
            recipe.ingredients.remove(atOffsets: offsets)
        }

        undoManager?.registerUndo(withTarget: self) { doc in
            doc.replaceIngredients(with: oldIngredients, undoManager: undoManager)
        }
    }
    
    /// Relocates the specified items, and registers an undo action.
    func moveIngredientsAt(offsets: IndexSet, toOffset: Int, undoManager: UndoManager? = nil) {
        let oldIngredients = recipe.ingredients
        withAnimation {
            recipe.ingredients.move(fromOffsets: offsets, toOffset: toOffset)
        }
        
        undoManager?.registerUndo(withTarget: self) { doc in
            // Use the replaceItems symmetric undoable-redoable function.
            doc.replaceIngredients(with: oldIngredients, undoManager: undoManager)
        }
        
    }
    
    func registerUndoMeasureChange(for index: Int, newMeasure: Float, oldMeasure: Float, undoManager: UndoManager?) {
        
        let newIngredients = recipe.ingredients
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.recipe.ingredients[index].measure = oldMeasure
            
            undoManager?.registerUndo(withTarget: self) { doc in
                doc.replaceIngredients(with: newIngredients, undoManager: undoManager, animation: nil)
            }
        }
    }
    
    func registerUndoUnitChange(for index: Int, newUnit: String, oldUnit: String, undoManager: UndoManager?) {
        
        let newIngredients = recipe.ingredients
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.recipe.ingredients[index].unit = oldUnit
            
            undoManager?.registerUndo(withTarget: self) { doc in
                doc.replaceIngredients(with: newIngredients, undoManager: undoManager, animation: nil)
            }
        }
    }
    
    func registerUndoIngredientChange(for index: Int, newIngredient: String, oldIngredient: String, undoManager: UndoManager?) {
        let newIngredients = recipe.ingredients
        
        recipe.ingredients[index].ingredient = newIngredient
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.recipe.ingredients[index].ingredient = oldIngredient
            
            undoManager?.registerUndo(withTarget: self) { doc in
                doc.replaceIngredients(with: newIngredients, undoManager: undoManager, animation: nil)
            }
        }
    }
}

// Instruction Functions
extension RecipeDocument {
    
    func addInstruction(instruction: Instruction, undoManager: UndoManager? = nil) {
        recipe.instructions.append(instruction)
        let count = recipe.instructions.count
        undoManager?.registerUndo(withTarget: self) { doc in
            withAnimation {
                doc.deleteInstruction(index: count - 1, undoManager: undoManager)
            }
        }
    }
    
    func deleteInstruction(index: Int, undoManager: UndoManager? = nil) {
        let oldInstructions = recipe.instructions
        withAnimation {
            _ = recipe.instructions.remove(at: index)
        }
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.replaceInstructions(with: oldInstructions, undoManager: undoManager)
        }
    }
    
    func deleteInstructionIDs(withIDs ids: [UUID], undoManager: UndoManager? = nil) {
        var indexSet: IndexSet = IndexSet()

        let enumerated = recipe.instructions.enumerated()
        for (index, item) in enumerated where ids.contains(item.id) {
            indexSet.insert(index)
        }

        deleteInstructions(offsets: indexSet, undoManager: undoManager)
    }
    
    /// Replaces the existing items with a new set of items.
    func replaceInstructions(with newInstructions: [Instruction], undoManager: UndoManager? = nil, animation: Animation? = .default) {
        let oldInstructions = recipe.instructions
        
        withAnimation(animation) {
            recipe.instructions = newInstructions
        }
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.replaceInstructions(with: oldInstructions, undoManager: undoManager, animation: animation)
        }
    }

    func deleteInstructions(offsets: IndexSet, undoManager: UndoManager? = nil) {
        let oldInstructions = recipe.instructions
        withAnimation {
            recipe.instructions.remove(atOffsets: offsets)
        }
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.replaceInstructions(with: oldInstructions, undoManager: undoManager)
        }
    }
    
    /// Relocates the specified items, and registers an undo action.
    func moveInstructionsAt(offsets: IndexSet, toOffset: Int, undoManager: UndoManager? = nil) {
        let oldInstructions = recipe.instructions
        withAnimation {
            recipe.instructions.move(fromOffsets: offsets, toOffset: toOffset)
        }
        
        undoManager?.registerUndo(withTarget: self) { doc in
            // Use the replaceItems symmetric undoable-redoable function.
            doc.replaceInstructions(with: oldInstructions, undoManager: undoManager)
        }
        
    }
    
    func registerUndoInstructionChange(for index: Int, newInstruction: String, oldInstruction: String, undoManager: UndoManager?) {
        let newInstructions = recipe.instructions
        
        recipe.instructions[index].instruction = newInstruction
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.recipe.instructions[index].instruction = oldInstruction
            
            undoManager?.registerUndo(withTarget: self) { doc in
                doc.replaceInstructions(with: newInstructions, undoManager: undoManager, animation: nil)
            }
        }
    }
}

// Utensil Functions
extension RecipeDocument {
    
    func addUtensil(utensil: Utensil, undoManager: UndoManager? = nil) {
        recipe.utensils.append(utensil)
        let count = recipe.utensils.count
        undoManager?.registerUndo(withTarget: self) { doc in
            withAnimation {
                doc.deleteUtensil(index: count - 1, undoManager: undoManager)
            }
        }
    }
    
    func deleteUtensil(index: Int, undoManager: UndoManager? = nil) {
        let oldUtensils = recipe.utensils
        withAnimation {
            _ = recipe.utensils.remove(at: index)
        }
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.replaceUtensils(with: oldUtensils, undoManager: undoManager)
        }
    }
    
    func deleteUtensilIDs(withIDs ids: [UUID], undoManager: UndoManager? = nil) {
        var indexSet: IndexSet = IndexSet()

        let enumerated = recipe.utensils.enumerated()
        for (index, item) in enumerated where ids.contains(item.id) {
            indexSet.insert(index)
        }

        deleteUtensils(offsets: indexSet, undoManager: undoManager)
    }
    
    /// Replaces the existing items with a new set of items.
    func replaceUtensils(with newUtensils: [Utensil], undoManager: UndoManager? = nil, animation: Animation? = .default) {
        let oldUtensils = recipe.utensils
        
        withAnimation(animation) {
            recipe.utensils = newUtensils
        }
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.replaceUtensils(with: oldUtensils, undoManager: undoManager, animation: animation)
        }
    }

    func deleteUtensils(offsets: IndexSet, undoManager: UndoManager? = nil) {
        let oldUtensils = recipe.utensils
        withAnimation {
            recipe.utensils.remove(atOffsets: offsets)
        }
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.replaceUtensils(with: oldUtensils, undoManager: undoManager)
        }
    }
    
    /// Relocates the specified items, and registers an undo action.
    func moveUtensilsAt(offsets: IndexSet, toOffset: Int, undoManager: UndoManager? = nil) {
        let oldUtensils = recipe.utensils
        withAnimation {
            recipe.utensils.move(fromOffsets: offsets, toOffset: toOffset)
        }
        
        undoManager?.registerUndo(withTarget: self) { doc in
            // Use the replaceItems symmetric undoable-redoable function.
            doc.replaceUtensils(with: oldUtensils, undoManager: undoManager)
        }
        
    }
    
    func registerUndoUtensilChange(for index: Int, newUtensil: String, oldUtensil: String, undoManager: UndoManager?) {
        let newUtensils = recipe.utensils
        
        recipe.utensils[index].utensil = newUtensil
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.recipe.utensils[index].utensil = oldUtensil
            
            undoManager?.registerUndo(withTarget: self) { doc in
                doc.replaceUtensils(with: newUtensils, undoManager: undoManager, animation: nil)
            }
        }
    }
    
    func registerUndoUtensilDetailChange(for index: Int, newDetail: String, oldDetail: String, undoManager: UndoManager?) {
        let newUtensils = recipe.utensils
        
        recipe.utensils[index].detail = newDetail
        
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.recipe.utensils[index].utensil = oldDetail
            
            undoManager?.registerUndo(withTarget: self) { doc in
                doc.replaceUtensils(with: newUtensils, undoManager: undoManager, animation: nil)
            }
        }
    }
}
