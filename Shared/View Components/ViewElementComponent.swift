//
//  ViewElementComponent.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/8/10.
//

import Foundation
import SwiftUI
import AVKit

enum ViewElementComponent: Codable, Equatable {
    // font
    case text(content: String, multilineTextAlignment: ARVisTextAlignment = .leading, fontStyle: ARVisFontStyle? = nil)
    case image(url: String, contentMode: ARVisContentMode = .fit)
    case video(url: String)
    case link(url: String) // how to integrate into text?
    //    case superLink(link: AnyView)
    case hStack(elements: [ViewElementComponent], alignment: ARVisVerticalAlignment = .center, spacing: CGFloat? = nil)
    case vStack(elements: [ViewElementComponent], alignment: ARVisHorizontalAlignment = .center, spacing: CGFloat? = nil)
    case spacer
}

extension ViewElementComponent {
    @ViewBuilder
    func view() -> some View {
        switch self {
        case let .text(content, multilineTextAlignment, fontStyle):
            Text(LocalizedStringKey(content), tableName: nil)
                .font(.init(fontStyle))
                .foregroundColor(.init(fontStyle?.color))
                .multilineTextAlignment(.init(multilineTextAlignment))
        case let .image(url, contentMode):
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .init(contentMode))
            } placeholder: {
                ProgressView()
            }
        case let .video(url):
            VideoPlayer(player: URL(string: url) != nil ? AVPlayer(url: URL(string: url)!) : nil)
                .frame(minHeight: 200, maxHeight: 900)
        case let .hStack(elements, alignment, spacing):
            HStack(alignment: .init(alignment), spacing: spacing) {
                ForEach(Array(zip(elements.indices, elements)), id: \.0) { _, element in
                    AnyView(element.view())
                }
            }
        case let .vStack(elements, alignment, spacing):
            VStack(alignment: .init(alignment), spacing: spacing) {
                ForEach(Array(zip(elements.indices, elements)), id: \.0) { _, element in
                    AnyView(element.view())
                }
            }
        case .spacer:
            Spacer()
        default:
            Text("Default")
        }
    }
}
