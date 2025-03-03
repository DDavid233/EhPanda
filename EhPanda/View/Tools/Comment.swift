//
//  Comment.swift
//  EhPanda
//
//  Created by 荒木辰造 on R 3/01/03.
//

import SwiftUI

struct CommentButton: View {
    private let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Image(systemName: "square.and.pencil")
                Text("Post Comment")
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
        }
    }
}

struct DraftCommentView: View {
    @Binding private var content: String

    private let title: String
    private let postAction: () -> Void
    private let cancelAction: () -> Void

    init(
        content: Binding<String>,
        title: String,
        postAction: @escaping () -> Void,
        cancelAction: @escaping () -> Void
    ) {
        _content = content
        self.title = title
        self.postAction = postAction
        self.cancelAction = cancelAction
    }

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $content)
                    .padding()
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .navigationBarTitle(
                        title.localized(),
                        displayMode: .inline
                    )
                    .navigationBarItems(
                        leading:
                            Button(action: cancelAction) {
                                Text("Cancel")
                                    .fontWeight(.regular)
                            },
                        trailing:
                            Button(action: postAction) {
                                Text("Post")
                            }
                            .disabled(content.isEmpty)
                    )
                Spacer()
            }
        }
    }
}
