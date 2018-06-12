//
//  ChatViewController.swift
//  Blind Date
//
//  Created by Praveen Pendyala on 6/11/18.
//  Copyright © 2018 Praveen Pendyala. All rights reserved.
//

import Chatto
import ChattoAdditions

final class ChatViewController: BaseChatViewController {
    
    var chatInputPresenter: BasicChatInputBarPresenter!
    
    
    // MARK: -
    // MARK: Public Methods
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.chatDataSource = YourDataSource()
//    }
//
//    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
//        let textMessagePresenter = TextMessagePresenterBuilder(
//            viewModelBuilder: DemoTextMessageViewModelBuilder(),
//            interactionHandler: DemoTextMessageHandler(baseHandler: self.baseMessageHandler)
//        )
//        textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellAvatarStyle()
//
//        let photoMessagePresenter = PhotoMessagePresenterBuilder(
//            viewModelBuilder: DemoPhotoMessageViewModelBuilder(),
//            interactionHandler: DemoPhotoMessageHandler(baseHandler: self.baseMessageHandler)
//        )
//        photoMessagePresenter.baseCellStyle = BaseMessageCollectionViewCellAvatarStyle()
//
//        return [
//            "text-message-type": [textMessagePresenter],
//            "photo-message-type": [photoMessagePresenter],
//        ]
//    }
    
    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = NSLocalizedString("Send", comment: "")
        appearance.textInputAppearance.placeholderText = NSLocalizedString("Type a message", comment: "")
        self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        chatInputView.maxCharactersCount = 1000
        return chatInputView
    }
    
    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
        items.append(self.createPhotoInputItem())
        return items
    }
    
    
    // MARK: -
    // MARK: Private Methods
    
    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            // Your handling logic
        }
        return item
    }
    
    private func createPhotoInputItem() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] image in
            // Your handling logic
        }
        return item
    }
}
