//
//  SearchView.swift
//  Messager
//
//  Created by Silchenko on 28.11.2018.
//

import UIKit

class SearchView: UIView {

    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var elementLabel: UILabel!
    @IBOutlet private weak var upButton: UIButton!
    @IBOutlet private weak var downButton: UIButton!
    @IBOutlet private weak var calendarButton: UIButton!
    
    private var endInput: ((String) -> ([Message]))?
    private var showMessage: ((Message) -> ())?
    private var willChangeMessage: ((Message) -> ())?
    private var showCalendar: (() -> ())?
    private var searchTextPlaceholder = "Search text..."
    
    private var foundMessages = [Message]()
    private var currentMessageIndex = 0
    
    override func awakeFromNib() {
        searchTextField.delegate = self
        searchTextField.placeholder = searchTextPlaceholder
    }
    
    func set(messages: [Message]) {
        self.foundMessages = messages
        updateUI()
        if foundMessages.count > 0 {
            showMessage?(foundMessages[currentMessageIndex])
        }
    }
    
    func configure(model: SearchViewViewModel) {
        self.searchTextPlaceholder = model.placeholder
        self.endInput = model.endInput
        self.showMessage = model.showMessage
        self.willChangeMessage = model.willChangeMessage
        self.showCalendar = model.showCalendar
        searchTextField.placeholder = searchTextPlaceholder
        calendarButton.setImage(model.calendarIcon, for: .normal)
        upButton.setImage(model.searchToTopIcon, for: .normal)
        downButton.setImage(model.searchToBottomIcon, for: .normal)
    }
    
    @IBAction private func upButtonTapped(_ sender: Any) {
        willChangeMessage?(foundMessages[currentMessageIndex])
        currentMessageIndex += 1
        if currentMessageIndex >= foundMessages.count {
            currentMessageIndex = 0
        }
        updateUI()
        showMessage?(foundMessages[currentMessageIndex])
    }
    
    @IBAction private func downButtonTapped(_ sender: Any) {
        willChangeMessage?(foundMessages[currentMessageIndex])
        currentMessageIndex -= 1
        if currentMessageIndex < 0 {
            currentMessageIndex = foundMessages.count - 1
        }
        updateUI()
        showMessage?(foundMessages[currentMessageIndex])
    }
    
    @IBAction private func calendarButtonTapped(_ sender: Any) {
        showCalendar?()
    }
    
    func updateUI() {
        searchTextField.placeholder = searchTextPlaceholder
        if foundMessages.count > 0 {
            upButton.isEnabled = true
            downButton.isEnabled = true
            elementLabel.text = "\(currentMessageIndex+1) of \(foundMessages.count)"
        } else {
            elementLabel.text = ""
            upButton.isEnabled = false
            downButton.isEnabled = false
        }
    }
}

extension SearchView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let messages = endInput?(textField.text ?? "") {
            foundMessages = messages
            if foundMessages.count > 0 && currentMessageIndex < foundMessages.count {
                showMessage?(foundMessages[currentMessageIndex])
            } else if currentMessageIndex >= foundMessages.count && foundMessages.count > 0 {
                currentMessageIndex = 0
                showMessage?(foundMessages[currentMessageIndex])
            }
            updateUI()
        }
        return true
    }
}
