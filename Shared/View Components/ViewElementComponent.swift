//
//  ViewElementComponent.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/8/10.
//

import AVKit
import Foundation
import SwiftUI
import SwiftyJSON

enum ViewElementComponent: Codable, Equatable {
    // font
    case text(content: String, multilineTextAlignment: ARVisTextAlignment? = nil, fontStyle: ARVisFontStyle? = nil)
    case image(url: String, contentMode: ARVisContentMode = .fit)
    case video(url: String)
    case link(url: String) // how to integrate into text?
    //    case superLink(link: AnyView)
    case hStack(elements: [ViewElementComponent], alignment: ARVisVerticalAlignment? = nil, spacing: CGFloat? = nil)
    case vStack(elements: [ViewElementComponent], alignment: ARVisHorizontalAlignment? = nil, spacing: CGFloat? = nil)
    case spacer
    case table(configuration: TableConfiguration)
    case chart(configuration: ChartConfiguration) // This should be manually decoded/encoded

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var allKeys = ArraySlice(container.allKeys)
        guard let onlyKey = allKeys.popFirst(), allKeys.isEmpty else {
            throw DecodingError.typeMismatch(ViewElementComponent.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Invalid number of keys found, expected one.", underlyingError: nil))
        }
        switch onlyKey {
        case .text:
            let nestedContainer = try container.nestedContainer(keyedBy: ViewElementComponent.TextCodingKeys.self, forKey: .text)
            self = ViewElementComponent.text(content: try nestedContainer.decode(String.self, forKey: ViewElementComponent.TextCodingKeys.content), multilineTextAlignment: try nestedContainer.decodeIfPresent(ARVisTextAlignment.self, forKey: ViewElementComponent.TextCodingKeys.multilineTextAlignment), fontStyle: try nestedContainer.decodeIfPresent(ARVisFontStyle.self, forKey: ViewElementComponent.TextCodingKeys.fontStyle))
        case .image:
            let nestedContainer = try container.nestedContainer(keyedBy: ViewElementComponent.ImageCodingKeys.self, forKey: .image)
            self = ViewElementComponent.image(url: try nestedContainer.decode(String.self, forKey: ViewElementComponent.ImageCodingKeys.url), contentMode: try nestedContainer.decode(ARVisContentMode.self, forKey: ViewElementComponent.ImageCodingKeys.contentMode))
        case .video:
            let nestedContainer = try container.nestedContainer(keyedBy: ViewElementComponent.VideoCodingKeys.self, forKey: .video)
            self = ViewElementComponent.video(url: try nestedContainer.decode(String.self, forKey: ViewElementComponent.VideoCodingKeys.url))
        case .link:
            let nestedContainer = try container.nestedContainer(keyedBy: ViewElementComponent.LinkCodingKeys.self, forKey: .link)
            self = ViewElementComponent.link(url: try nestedContainer.decode(String.self, forKey: ViewElementComponent.LinkCodingKeys.url))
        case .hStack:
            let nestedContainer = try container.nestedContainer(keyedBy: ViewElementComponent.HStackCodingKeys.self, forKey: .hStack)
            self = ViewElementComponent.hStack(elements: try nestedContainer.decode([ViewElementComponent].self, forKey: ViewElementComponent.HStackCodingKeys.elements), alignment: try nestedContainer.decodeIfPresent(ARVisVerticalAlignment.self, forKey: ViewElementComponent.HStackCodingKeys.alignment), spacing: try nestedContainer.decodeIfPresent(CGFloat.self, forKey: ViewElementComponent.HStackCodingKeys.spacing))
        case .vStack:
            let nestedContainer = try container.nestedContainer(keyedBy: ViewElementComponent.VStackCodingKeys.self, forKey: .vStack)
            self = ViewElementComponent.vStack(elements: try nestedContainer.decode([ViewElementComponent].self, forKey: ViewElementComponent.VStackCodingKeys.elements), alignment: try nestedContainer.decodeIfPresent(ARVisHorizontalAlignment.self, forKey: ViewElementComponent.VStackCodingKeys.alignment), spacing: try nestedContainer.decodeIfPresent(CGFloat.self, forKey: ViewElementComponent.VStackCodingKeys.spacing))
        case .spacer:
            _ = try container.nestedContainer(keyedBy: ViewElementComponent.SpacerCodingKeys.self, forKey: .spacer)
            self = ViewElementComponent.spacer
        case .table:
            let nestedContainer = try container.nestedContainer(keyedBy: ViewElementComponent.TableCodingKeys.self, forKey: .table)
            self = ViewElementComponent.table(configuration: try nestedContainer.decode(TableConfiguration.self, forKey: ViewElementComponent.TableCodingKeys.configuration))
        case .chart:
            let dict = try container.decode([String: Any].self, forKey: .chart)
            let json = JSON(dict)
            self = ViewElementComponent.chart(configuration: ChartConfigurationJSONParser.default.parse(json))
        }
    }
}

extension ViewElementComponent {
    @ViewBuilder
    func view() -> some View {
        switch self {
        case let .text(content, multilineTextAlignment, fontStyle):
            Text(.init(content))
                .font(.init(fontStyle))
                .if(fontStyle?.color != nil, transform: { view in
                    view.foregroundColor(.init(fontStyle?.color))
                })
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
        case .link(url: _):
            fatalError()
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
        case let .table(configuration):
            ARVisTableView(configuration: configuration)
        case let .chart(configuration):
            ChartView(chartConfiguration: configuration)
        }
    }
}
