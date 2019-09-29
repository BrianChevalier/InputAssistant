//
//  CompletionManager.swift
//  InputAssistant
//
//  Created by Brian Chevalier on 9/28/19.
//
// This file has been adapted from OpenTerm to merge in autocompletion management

import Foundation

/// Receive notifications when the auto completion state changes
public protocol AutoCompleteManagerDelegate: class {
    func autoCompleteManagerDidChangeCompletions()
}

/// Provide commands to the completion manager
public protocol AutoCompleteManagerDataSource: class {
    func allCommandsForAutoCompletion() -> [String]
    func currentContextCompletions() -> [Completion]
}

public struct Completion {
    /// Display name for the completion
    public let name: String
    
    public var displayName: String {
        //remove placehold syntax
        return name.replacingOccurrences(of: "<#", with: "")
            .replacingOccurrences(of: "#>", with: "")
    }
    
    /// By default, a whitespace character will be inserted after the completion.
    public let appendingSuffix: String

    /// Additional information to store in the completion
    public let data: Any?

    public init(_ name: String, data: Any? = nil) {
        self.init(name, appendingSuffix: " ", data: data)
    }
    public init(_ name: String, appendingSuffix: String, data: Any? = nil) {
        self.name = name; self.appendingSuffix = appendingSuffix; self.data = data
    }
}

/// Class that takes the current command and parses it into various states of auto completion,
/// each state with various commands that can be run.
open class AutoCompleteManager {
    
    public init(){
        
    }
    
    /// A set of completions to be displayed to the user. Updated when the `currentCommand` changes.
    open var completions: [Completion] = [] {
        didSet {
            self.delegate?.autoCompleteManagerDidChangeCompletions()
        }
    }
    
    /// Set this to receive notifications when state changes.
    open weak var delegate: AutoCompleteManagerDelegate?
    
    /// Set this to provide completions.
    open weak var dataSource: AutoCompleteManagerDataSource? {
        didSet {
            self.updateCompletions()
        }
    }

    /// The current command text entered by the user.
    open var currentCommand: String = "" {
        didSet {
            // Update the completions list, since the text changed.
            self.updateCompletions()
        }
    }
    
    /// Update the value of the `completions` property, based on the current command and state.
    open func updateCompletions() {
        self.completions = dataSource?.currentContextCompletions() ?? []
    }
    
}
