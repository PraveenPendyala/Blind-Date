/*
 The MIT License (MIT)

 Copyright (c) 2015-present Badoo Trading Limited.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

import Foundation
import Chatto
import Firebase

class DemoChatDataSource: ChatDataSourceProtocol {
    var nextMessageId: Int = 0
    let preferredMaxWindowSize = 500
    private var conversationId = ""
    var slidingWindow: SlidingDataSource<ChatItemProtocol>!
    init(count: Int, pageSize: Int) {
        self.slidingWindow = SlidingDataSource(count: count, pageSize: pageSize) { [weak self] () -> ChatItemProtocol in
            guard let sSelf = self else { return DemoChatMessageFactory.makeRandomMessage("") }
            defer { sSelf.nextMessageId += 1 }
            return DemoChatMessageFactory.makeRandomMessage("\(sSelf.nextMessageId)")
        }
    }

    init(messages: [ChatItemProtocol], pageSize: Int) {
        self.slidingWindow = SlidingDataSource(items: messages, pageSize: pageSize)
    }
    
    init(_ convoId: String, pageSize: Int) {
        // DEV NOTE: To prevent firebase from adding already present items twice on the initial load
        var shouldStartObservingNewData = false
        self.conversationId = convoId
        self.slidingWindow  = SlidingDataSource(items: [], pageSize: 50)
        FirebaseManager.shared.messagesRef.child(convoId).queryOrdered(byChild: "timestamp").queryLimited(toLast: 1).observe(.childAdded) { (snapshot) in
            if shouldStartObservingNewData, let message = self.makeTextMessage(snapshot) {
                //        self.messageSender.sendMessage(message)
                self.slidingWindow.insertItem(message, position: .bottom)
                self.delegate?.chatDataSourceDidUpdate(self)
            }
        }
        FirebaseManager.shared.messagesRef.child(convoId).queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value) { (snapshot) in
            var messages = [DemoTextMessageModel]()
            for child in snapshot.children {
                if let childSnap = child as? DataSnapshot, let message = self.makeTextMessage(childSnap) {
                    messages.append(message)
                }
            }
            self.slidingWindow = SlidingDataSource(items: messages, pageSize: pageSize)
            self.delegate?.chatDataSourceDidUpdate(self)
            shouldStartObservingNewData = true
        }
    }

    lazy var messageSender: DemoChatMessageSender = {
        let sender = DemoChatMessageSender()
        sender.onMessageChanged = { [weak self] (message) in
            guard let sSelf = self else { return }
            sSelf.delegate?.chatDataSourceDidUpdate(sSelf)
        }
        return sender
    }()

    var hasMoreNext: Bool {
        return self.slidingWindow.hasMore()
    }

    var hasMorePrevious: Bool {
        return self.slidingWindow.hasPrevious()
    }

    var chatItems: [ChatItemProtocol] {
        return self.slidingWindow.itemsInWindow
    }

    weak var delegate: ChatDataSourceDelegateProtocol?

    func loadNext() {
        self.slidingWindow.loadNext()
        self.slidingWindow.adjustWindow(focusPosition: 1, maxWindowSize: self.preferredMaxWindowSize)
        self.delegate?.chatDataSourceDidUpdate(self, updateType: .pagination)
    }

    func loadPrevious() {
        self.slidingWindow.loadPrevious()
        self.slidingWindow.adjustWindow(focusPosition: 0, maxWindowSize: self.preferredMaxWindowSize)
        self.delegate?.chatDataSourceDidUpdate(self, updateType: .pagination)
    }

    func addTextMessage(_ text: String) {
//        let uid = "\(self.nextMessageId)"
//        self.nextMessageId += 1
//        let message = DemoChatMessageFactory.makeTextMessage(uid, text: text, isIncoming: false)
//        self.messageSender.sendMessage(message)
//        self.slidingWindow.insertItem(message, position: .bottom)
//        self.delegate?.chatDataSourceDidUpdate(self)
        let newMessage = FirebaseManager.shared.messagesRef.child("\(conversationId)").childByAutoId()
        newMessage.setValue(["firebaseId" : Auth.auth().currentUser!.uid,
                                "message" : text,
                              "timestamp" : ServerValue.timestamp()])
    }

    func addPhotoMessage(_ image: UIImage) {
        let uid = "\(self.nextMessageId)"
        self.nextMessageId += 1
        let message = DemoChatMessageFactory.makePhotoMessage(uid, image: image, size: image.size, isIncoming: false)
        self.messageSender.sendMessage(message)
        self.slidingWindow.insertItem(message, position: .bottom)
        self.delegate?.chatDataSourceDidUpdate(self)
    }

    func addRandomIncomingMessage() {
        let message = DemoChatMessageFactory.makeRandomMessage("\(self.nextMessageId)", isIncoming: true)
        self.nextMessageId += 1
        self.slidingWindow.insertItem(message, position: .bottom)
        self.delegate?.chatDataSourceDidUpdate(self)
    }

    func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double, completion:(_ didAdjust: Bool) -> Void) {
        let didAdjust = self.slidingWindow.adjustWindow(focusPosition: focusPosition, maxWindowSize: preferredMaxCount ?? self.preferredMaxWindowSize)
        completion(didAdjust)
    }
    
    private func makeTextMessage(_ snapshot: DataSnapshot) ->  DemoTextMessageModel? {
        guard let message = snapshot.value as? [String: Any] else { return nil}
        let text = DemoChatMessageFactory.makeTextMessage(snapshot.key,
                                                          text: message["message"] as? String ?? "",
                                                          isIncoming: message["firebasId"] as? String ?? "" == Auth.auth().currentUser!.uid)
        return text
    }
}
