//
//  EhPandaView.swift
//  EhPanda
//
//  Created by 荒木辰造 on R 3/01/18.
//

import SwiftUI

struct EhPandaView: View, StoreAccessor {
    @EnvironmentObject var store: Store

    private var contacts: [Info] {
        [
            Info(
                url: "https://ehpanda.app",
                text: "Website".localized()
            ),
            Info(
                url: "https://github.com/tatsuz0u/EhPanda",
                text: "GitHub"
            ),
            Info(
                url: "https://t.me/ehpanda",
                text: "Telegram"
            )
        ]
    }

    private var acknowledgements: [Info] {
        [
            Info(
                url: "https://github.com/taylorlannister",
                text: "taylorlannister"
            ),
            Info(
                url: "https://github.com/honjow",
                text: "honjow"
            ),
            Info(
                url: "https://github.com/tid-kijyun/Kanna",
                text: "Kanna"
            ),
            Info(
                url: "https://github.com/onevcat/Kingfisher",
                text: "Kingfisher"
            ),
            Info(
                url: "https://github.com/honkmaster/TTProgressHUD",
                text: "TTProgressHUD"
            ),
            Info(
                url: "https://github.com/SDWebImage/SDWebImageSwiftUI",
                text: "SDWebImageSwiftUI"
            )
        ]
    }

    private var version: String {
        [
            "Version".localized(),
            appVersion,
            "(\(appBuild))"
        ]
        .joined(separator: " ")
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Copyright © 2021 荒木辰造")
                    .captionTextStyle()
                Text(version)
                    .captionTextStyle()
            }
            Spacer()
        }
        .padding(.horizontal)
        Form {
            if isTokenMatched || environment.isPreview {
                Section(header: Text("Contacts")) {
                    ForEach(contacts) { contact in
                        if let url = URL(string: contact.url) {
                            LinkRow(url: url, text: contact.text)
                        }
                    }
                }
            }
            Section(header: Text("Acknowledgement")) {
                ForEach(acknowledgements) { acknowledgement in
                    if let url = URL(string: acknowledgement.url) {
                        LinkRow(url: url, text: acknowledgement.text)
                    }
                }
            }
        }
        .navigationBarTitle("EhPanda")
    }
}

private struct Info: Identifiable {
    var id = UUID()

    let url: String
    let text: String
}

private struct LinkRow: View {
    let url: URL
    let text: String

    var body: some View {
        Link(destination: url, label: {
            Text(text)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .withArrow()
        })
    }
}

private extension Text {
    func captionTextStyle() -> some View {
        self
            .fontWeight(.bold)
            .foregroundColor(.gray)
            .font(.caption2)
    }
}
