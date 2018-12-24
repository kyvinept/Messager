//
//  ChatViewDataSource.swift
//  Messager
//
//  Created by Silchenko on 20.12.2018.
//

import UIKit

class ChatViewDataSource: NSObject {
    
    var showHideLabelCount: ((Bool) -> ())?
    var selectedRow: ((IndexPath) -> ())?
    var messages: [Message]! {
        didSet {
            rowBuilder.messages = messages
        }
    }
    var currentUser: User! {
        didSet {
            rowBuilder.currentUser = currentUser
        }
    }
    private var tableView: UITableView
    private var rowBuilder: ChatViewRowBuilder
    
    init(tableView: UITableView, rowBuilder: ChatViewRowBuilder) {
        self.tableView = tableView
        self.rowBuilder = rowBuilder
        super.init()
        registerCell()
        initTableView()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func scrollToBottom(animated: Bool, withReload: Bool) {
        if withReload {
            reloadData()
        }
        tableView.scrollToBottom(animated: animated)
    }
    
    func scrollToRow(at indexPath: IndexPath, at scrollPosition: UITableViewScrollPosition, animated: Bool) {
        tableView.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    func changeBackground(forIndexPath indexPath: IndexPath, isSearch: Bool) {
        if let cell = tableView.cellForRow(at: indexPath) as? CustomCell {
            cell.changeBackgroundColor(isSearch: isSearch)
        }
    }
}

extension ChatViewDataSource: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        showHideLabelCount?(!messages.isEmpty)
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRow?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return rowBuilder.createCell(forIndexPath: indexPath)
    }
}

private extension ChatViewDataSource {
    
    func registerCell() {
        tableView.register(UINib(nibName: "OutgoingMessageCell", bundle: nil), forCellReuseIdentifier: "OutgoingMessageCell")
        tableView.register(UINib(nibName: "IncomingMessageCell", bundle: nil), forCellReuseIdentifier: "IncomingMessageCell")
        tableView.register(UINib(nibName: "OutgoingImageCell", bundle: nil), forCellReuseIdentifier: "OutgoingImageCell")
        tableView.register(UINib(nibName: "IncomingImageCell", bundle: nil), forCellReuseIdentifier: "IncomingImageCell")
        tableView.register(UINib(nibName: "OutgoingLocationCell", bundle: nil), forCellReuseIdentifier: "OutgoingLocationCell")
        tableView.register(UINib(nibName: "IncomingLocationCell", bundle: nil), forCellReuseIdentifier: "IncomingLocationCell")
        tableView.register(UINib(nibName: "OutgoingVideoCell", bundle: nil), forCellReuseIdentifier: "OutgoingVideoCell")
        tableView.register(UINib(nibName: "IncomingVideoCell", bundle: nil), forCellReuseIdentifier: "IncomingVideoCell")
        tableView.register(UINib(nibName: "OutgoingGiphyCell", bundle: nil), forCellReuseIdentifier: "OutgoingGiphyCell")
        tableView.register(UINib(nibName: "IncomingGiphyCell", bundle: nil), forCellReuseIdentifier: "IncomingGiphyCell")
        tableView.register(UINib(nibName: "OutgoingAnswerCell", bundle: nil), forCellReuseIdentifier: "OutgoingAnswerCell")
        tableView.register(UINib(nibName: "IncomingAnswerCell", bundle: nil), forCellReuseIdentifier: "IncomingAnswerCell")
    }
    
    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        rowBuilder.selectedAnswerMessage = { [weak self] indexPath in
            self?.tableView.selectRow(at: indexPath,
                                      animated: true,
                                      scrollPosition: .middle)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
        }
    }
}
