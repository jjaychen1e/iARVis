//
//  ViewElementComponent.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/8/10.
//

import AVKit
import Foundation
import Kingfisher
import SwiftUI
import SwiftyJSON
#if os(iOS)
    import VideoPlayer
#endif

enum ViewElementComponent: Codable, Equatable {
    // font
    case text(content: String, multilineTextAlignment: ARVisTextAlignment? = nil, fontStyle: ARVisFontStyle? = nil)
    case image(url: String, contentMode: ARVisContentMode = .fit, width: CGFloat? = nil, height: CGFloat? = nil)
    case audio(title: String? = nil, url: String)
    case video(url: String, width: CGFloat? = nil, height: CGFloat? = nil)
    case link(url: String) // how to integrate into text?
    //    case superLink(link: AnyView)
    case hStack(elements: [ViewElementComponent], alignment: ARVisVerticalAlignment? = nil, spacing: CGFloat? = nil)
    case vStack(elements: [ViewElementComponent], alignment: ARVisHorizontalAlignment? = nil, spacing: CGFloat? = nil)
    case spacer
    case divider(opacity: CGFloat = 0.5)
    case table(configuration: TableConfiguration)
    case chart(configuration: ChartConfiguration) // This should be manually decoded/encoded
    case segmentedControl(items: [ARVisSegmentedControlItem])
    case grid(rows: [ViewElementComponent])
    case gridRow(rowElements: [ViewElementComponent])

    enum CodingKeys: CodingKey {
        case text
        case image
        case audio
        case video
        case link
        case hStack
        case vStack
        case spacer
        case divider
        case table
        case chart
        case segmentedControl
        case grid
        case gridRow
    }

    enum TextCodingKeys: CodingKey {
        case content
        case multilineTextAlignment
        case fontStyle
    }

    enum ImageCodingKeys: CodingKey {
        case url
        case contentMode
        case width
        case height
    }

    enum AudioCodingKeys: CodingKey {
        case title
        case url
    }

    enum VideoCodingKeys: CodingKey {
        case url
        case width
        case height
    }

    enum LinkCodingKeys: CodingKey {
        case url
    }

    enum HStackCodingKeys: CodingKey {
        case elements
        case alignment
        case spacing
    }

    enum VStackCodingKeys: CodingKey {
        case elements
        case alignment
        case spacing
    }

    enum SpacerCodingKeys: CodingKey {}

    enum DividerCodingKeys: CodingKey {
        case opacity
    }

    enum TableCodingKeys: CodingKey {
        case configuration
    }

    enum ChartCodingKeys: CodingKey {
        case configuration
    }

    enum SegmentedControlCodingKeys: CodingKey {
        case items
    }

    enum GridCodingKeys: CodingKey {
        case rows
    }

    enum GridRowCodingKeys: CodingKey {
        case rowElements
    }

    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<ViewElementComponent.CodingKeys> = try decoder.container(keyedBy: ViewElementComponent.CodingKeys.self)
        var allKeys = ArraySlice<ViewElementComponent.CodingKeys>(container.allKeys)
        guard let onlyKey = allKeys.popFirst(), allKeys.isEmpty else {
            throw DecodingError.typeMismatch(ViewElementComponent.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Invalid number of keys found, expected one.", underlyingError: nil))
        }
        switch onlyKey {
        case .text:
            let nestedContainer: KeyedDecodingContainer<ViewElementComponent.TextCodingKeys> = try container.nestedContainer(keyedBy: ViewElementComponent.TextCodingKeys.self, forKey: ViewElementComponent.CodingKeys.text)
            self = ViewElementComponent.text(content: try nestedContainer.decode(String.self, forKey: ViewElementComponent.TextCodingKeys.content), multilineTextAlignment: try nestedContainer.decodeIfPresent(ARVisTextAlignment.self, forKey: ViewElementComponent.TextCodingKeys.multilineTextAlignment), fontStyle: try nestedContainer.decodeIfPresent(ARVisFontStyle.self, forKey: ViewElementComponent.TextCodingKeys.fontStyle))
        case .image:
            let nestedContainer: KeyedDecodingContainer<ViewElementComponent.ImageCodingKeys> = try container.nestedContainer(keyedBy: ViewElementComponent.ImageCodingKeys.self, forKey: ViewElementComponent.CodingKeys.image)
            self = ViewElementComponent.image(url: try nestedContainer.decode(String.self, forKey: ViewElementComponent.ImageCodingKeys.url), contentMode: try nestedContainer.decode(ARVisContentMode.self, forKey: ViewElementComponent.ImageCodingKeys.contentMode), width: try nestedContainer.decodeIfPresent(CGFloat.self, forKey: ViewElementComponent.ImageCodingKeys.width), height: try nestedContainer.decodeIfPresent(CGFloat.self, forKey: ViewElementComponent.ImageCodingKeys.height))
        case .audio:
            let nestedContainer: KeyedDecodingContainer<ViewElementComponent.AudioCodingKeys> = try container.nestedContainer(keyedBy: ViewElementComponent.AudioCodingKeys.self, forKey: ViewElementComponent.CodingKeys.audio)
            self = ViewElementComponent.audio(title: try nestedContainer.decodeIfPresent(String.self, forKey: ViewElementComponent.AudioCodingKeys.title), url: try nestedContainer.decode(String.self, forKey: ViewElementComponent.AudioCodingKeys.url))
        case .video:
            let nestedContainer: KeyedDecodingContainer<ViewElementComponent.VideoCodingKeys> = try container.nestedContainer(keyedBy: ViewElementComponent.VideoCodingKeys.self, forKey: ViewElementComponent.CodingKeys.video)
            self = ViewElementComponent.video(url: try nestedContainer.decode(String.self, forKey: ViewElementComponent.VideoCodingKeys.url), width: try nestedContainer.decodeIfPresent(CGFloat.self, forKey: ViewElementComponent.VideoCodingKeys.width), height: try nestedContainer.decodeIfPresent(CGFloat.self, forKey: ViewElementComponent.VideoCodingKeys.height))
        case .link:
            let nestedContainer: KeyedDecodingContainer<ViewElementComponent.LinkCodingKeys> = try container.nestedContainer(keyedBy: ViewElementComponent.LinkCodingKeys.self, forKey: ViewElementComponent.CodingKeys.link)
            self = ViewElementComponent.link(url: try nestedContainer.decode(String.self, forKey: ViewElementComponent.LinkCodingKeys.url))
        case .hStack:
            let nestedContainer: KeyedDecodingContainer<ViewElementComponent.HStackCodingKeys> = try container.nestedContainer(keyedBy: ViewElementComponent.HStackCodingKeys.self, forKey: ViewElementComponent.CodingKeys.hStack)
            self = ViewElementComponent.hStack(elements: try nestedContainer.decode([ViewElementComponent].self, forKey: ViewElementComponent.HStackCodingKeys.elements), alignment: try nestedContainer.decodeIfPresent(ARVisVerticalAlignment.self, forKey: ViewElementComponent.HStackCodingKeys.alignment), spacing: try nestedContainer.decodeIfPresent(CGFloat.self, forKey: ViewElementComponent.HStackCodingKeys.spacing))
        case .vStack:
            let nestedContainer: KeyedDecodingContainer<ViewElementComponent.VStackCodingKeys> = try container.nestedContainer(keyedBy: ViewElementComponent.VStackCodingKeys.self, forKey: ViewElementComponent.CodingKeys.vStack)
            self = ViewElementComponent.vStack(elements: try nestedContainer.decode([ViewElementComponent].self, forKey: ViewElementComponent.VStackCodingKeys.elements), alignment: try nestedContainer.decodeIfPresent(ARVisHorizontalAlignment.self, forKey: ViewElementComponent.VStackCodingKeys.alignment), spacing: try nestedContainer.decodeIfPresent(CGFloat.self, forKey: ViewElementComponent.VStackCodingKeys.spacing))
        case .spacer:
            let _: KeyedDecodingContainer<ViewElementComponent.SpacerCodingKeys> = try container.nestedContainer(keyedBy: ViewElementComponent.SpacerCodingKeys.self, forKey: ViewElementComponent.CodingKeys.spacer)
            self = ViewElementComponent.spacer
        case .divider:
            let nestedContainer: KeyedDecodingContainer<ViewElementComponent.DividerCodingKeys> = try container.nestedContainer(keyedBy: ViewElementComponent.DividerCodingKeys.self, forKey: ViewElementComponent.CodingKeys.divider)
            self = ViewElementComponent.divider(opacity: try nestedContainer.decode(CGFloat.self, forKey: ViewElementComponent.DividerCodingKeys.opacity))
        case .table:
            let nestedContainer: KeyedDecodingContainer<ViewElementComponent.TableCodingKeys> = try container.nestedContainer(keyedBy: ViewElementComponent.TableCodingKeys.self, forKey: ViewElementComponent.CodingKeys.table)
            self = ViewElementComponent.table(configuration: try nestedContainer.decode(TableConfiguration.self, forKey: ViewElementComponent.TableCodingKeys.configuration))
        case .chart:
            if #available(iOS 16, *) {
                let dict = try container.decode([String: Any].self, forKey: .chart)
                let json = JSON(dict)
                self = ViewElementComponent.chart(configuration: ChartConfigurationJSONParser.default.parse(json))
            } else {
                self = .text(content: "Chart component is not supported in iOS 15.")
            }
        case .segmentedControl:
            let nestedContainer: KeyedDecodingContainer<ViewElementComponent.SegmentedControlCodingKeys> = try container.nestedContainer(keyedBy: ViewElementComponent.SegmentedControlCodingKeys.self, forKey: ViewElementComponent.CodingKeys.segmentedControl)
            self = ViewElementComponent.segmentedControl(items: try nestedContainer.decode([ARVisSegmentedControlItem].self, forKey: ViewElementComponent.SegmentedControlCodingKeys.items))
        case .grid:
            let nestedContainer: KeyedDecodingContainer<ViewElementComponent.GridCodingKeys> = try container.nestedContainer(keyedBy: ViewElementComponent.GridCodingKeys.self, forKey: ViewElementComponent.CodingKeys.grid)
            self = ViewElementComponent.grid(rows: try nestedContainer.decode([ViewElementComponent].self, forKey: ViewElementComponent.GridCodingKeys.rows))
        case .gridRow:
            let nestedContainer: KeyedDecodingContainer<ViewElementComponent.GridRowCodingKeys> = try container.nestedContainer(keyedBy: ViewElementComponent.GridRowCodingKeys.self, forKey: ViewElementComponent.CodingKeys.gridRow)
            self = ViewElementComponent.gridRow(rowElements: try nestedContainer.decode([ViewElementComponent].self, forKey: ViewElementComponent.GridRowCodingKeys.rowElements))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<ViewElementComponent.CodingKeys> = encoder.container(keyedBy: ViewElementComponent.CodingKeys.self)
        switch self {
        case let .text(content, multilineTextAlignment, fontStyle):
            var nestedContainer: KeyedEncodingContainer<ViewElementComponent.TextCodingKeys> = container.nestedContainer(keyedBy: ViewElementComponent.TextCodingKeys.self, forKey: ViewElementComponent.CodingKeys.text)
            try nestedContainer.encode(content, forKey: ViewElementComponent.TextCodingKeys.content)
            try nestedContainer.encodeIfPresent(multilineTextAlignment, forKey: ViewElementComponent.TextCodingKeys.multilineTextAlignment)
            try nestedContainer.encodeIfPresent(fontStyle, forKey: ViewElementComponent.TextCodingKeys.fontStyle)
        case let .image(url, contentMode, width, height):
            var nestedContainer: KeyedEncodingContainer<ViewElementComponent.ImageCodingKeys> = container.nestedContainer(keyedBy: ViewElementComponent.ImageCodingKeys.self, forKey: ViewElementComponent.CodingKeys.image)
            try nestedContainer.encode(url, forKey: ViewElementComponent.ImageCodingKeys.url)
            try nestedContainer.encode(contentMode, forKey: ViewElementComponent.ImageCodingKeys.contentMode)
            try nestedContainer.encodeIfPresent(width, forKey: ViewElementComponent.ImageCodingKeys.width)
            try nestedContainer.encodeIfPresent(height, forKey: ViewElementComponent.ImageCodingKeys.height)
        case let .audio(title, url):
            var nestedContainer: KeyedEncodingContainer<ViewElementComponent.AudioCodingKeys> = container.nestedContainer(keyedBy: ViewElementComponent.AudioCodingKeys.self, forKey: ViewElementComponent.CodingKeys.audio)
            try nestedContainer.encodeIfPresent(title, forKey: ViewElementComponent.AudioCodingKeys.title)
            try nestedContainer.encode(url, forKey: ViewElementComponent.AudioCodingKeys.url)
        case let .video(url, width, height):
            var nestedContainer: KeyedEncodingContainer<ViewElementComponent.VideoCodingKeys> = container.nestedContainer(keyedBy: ViewElementComponent.VideoCodingKeys.self, forKey: ViewElementComponent.CodingKeys.video)
            try nestedContainer.encode(url, forKey: ViewElementComponent.VideoCodingKeys.url)
            try nestedContainer.encodeIfPresent(width, forKey: ViewElementComponent.VideoCodingKeys.width)
            try nestedContainer.encodeIfPresent(height, forKey: ViewElementComponent.VideoCodingKeys.height)
        case let .link(url):
            var nestedContainer: KeyedEncodingContainer<ViewElementComponent.LinkCodingKeys> = container.nestedContainer(keyedBy: ViewElementComponent.LinkCodingKeys.self, forKey: ViewElementComponent.CodingKeys.link)
            try nestedContainer.encode(url, forKey: ViewElementComponent.LinkCodingKeys.url)
        case let .hStack(elements, alignment, spacing):
            var nestedContainer: KeyedEncodingContainer<ViewElementComponent.HStackCodingKeys> = container.nestedContainer(keyedBy: ViewElementComponent.HStackCodingKeys.self, forKey: ViewElementComponent.CodingKeys.hStack)
            try nestedContainer.encode(elements, forKey: ViewElementComponent.HStackCodingKeys.elements)
            try nestedContainer.encodeIfPresent(alignment, forKey: ViewElementComponent.HStackCodingKeys.alignment)
            try nestedContainer.encodeIfPresent(spacing, forKey: ViewElementComponent.HStackCodingKeys.spacing)
        case let .vStack(elements, alignment, spacing):
            var nestedContainer: KeyedEncodingContainer<ViewElementComponent.VStackCodingKeys> = container.nestedContainer(keyedBy: ViewElementComponent.VStackCodingKeys.self, forKey: ViewElementComponent.CodingKeys.vStack)
            try nestedContainer.encode(elements, forKey: ViewElementComponent.VStackCodingKeys.elements)
            try nestedContainer.encodeIfPresent(alignment, forKey: ViewElementComponent.VStackCodingKeys.alignment)
            try nestedContainer.encodeIfPresent(spacing, forKey: ViewElementComponent.VStackCodingKeys.spacing)
        case .spacer:
            var _: KeyedEncodingContainer<ViewElementComponent.SpacerCodingKeys> = container.nestedContainer(keyedBy: ViewElementComponent.SpacerCodingKeys.self, forKey: ViewElementComponent.CodingKeys.spacer)
        case let .divider(opacity):
            var nestedContainer: KeyedEncodingContainer<ViewElementComponent.DividerCodingKeys> = container.nestedContainer(keyedBy: ViewElementComponent.DividerCodingKeys.self, forKey: ViewElementComponent.CodingKeys.divider)
            try nestedContainer.encode(opacity, forKey: ViewElementComponent.DividerCodingKeys.opacity)
        case let .table(configuration):
            var nestedContainer: KeyedEncodingContainer<ViewElementComponent.TableCodingKeys> = container.nestedContainer(keyedBy: ViewElementComponent.TableCodingKeys.self, forKey: ViewElementComponent.CodingKeys.table)
            try nestedContainer.encode(configuration, forKey: ViewElementComponent.TableCodingKeys.configuration)
        case let .chart(configuration):
            if #available(iOS 16, *) {
                if let encodedDict = ChartConfigurationJSONParser.default.encode(configuration).dictionaryObject {
                    try container.encodeIfPresent(encodedDict, forKey: ViewElementComponent.CodingKeys.chart)
                }
            }
        case let .segmentedControl(items):
            var nestedContainer: KeyedEncodingContainer<ViewElementComponent.SegmentedControlCodingKeys> = container.nestedContainer(keyedBy: ViewElementComponent.SegmentedControlCodingKeys.self, forKey: ViewElementComponent.CodingKeys.segmentedControl)
            try nestedContainer.encode(items, forKey: ViewElementComponent.SegmentedControlCodingKeys.items)
        case let .grid(rows):
            var nestedContainer: KeyedEncodingContainer<ViewElementComponent.GridCodingKeys> = container.nestedContainer(keyedBy: ViewElementComponent.GridCodingKeys.self, forKey: ViewElementComponent.CodingKeys.grid)
            try nestedContainer.encode(rows, forKey: ViewElementComponent.GridCodingKeys.rows)
        case let .gridRow(rowElements):
            var nestedContainer: KeyedEncodingContainer<ViewElementComponent.GridRowCodingKeys> = container.nestedContainer(keyedBy: ViewElementComponent.GridRowCodingKeys.self, forKey: ViewElementComponent.CodingKeys.gridRow)
            try nestedContainer.encode(rowElements, forKey: ViewElementComponent.GridRowCodingKeys.rowElements)
        }
    }
}

extension ViewElementComponent {
    @ViewBuilder
    func view() -> some View {
        Group {
            switch self {
            case let .text(content, multilineTextAlignment, fontStyle):
                Text(.init(content))
                    .font(.init(fontStyle))
                    .if(fontStyle?.color != nil, transform: { view in
                        view.foregroundColor(.init(fontStyle?.color))
                    })
                    .multilineTextAlignment(.init(multilineTextAlignment))
            case let .image(url, contentMode, width, height):
                KFImage(URL(string: url))
                    .placeholder {
                        Image(systemName: "arrow.2.circlepath.circle")
                            .font(.largeTitle)
                            .opacity(0.3)
                    }
                    .resizable()
                    .aspectRatio(contentMode: .init(contentMode))
                    .frame(width: width, height: height)
            case let .audio(title, url):
                AudioPlayerView(title: title, audioUrl: url)
            case let .video(url, width, height):
                if let url = URL(string: url),
                   let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                   let host = components.host {
                    if let _ = url.absoluteString.youtubeVideoID {
                        YoutubeThumbnailView(url: url.absoluteString)
                            .frame(width: width, height: height)
                    } else {
                        #if os(iOS)
                            VideoPlayer(url: url, play: .constant(true))
                                .frame(width: width, height: height)
                        #endif
                    }
                }
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
                Spacer(minLength: 0)
            case let .divider(opacity):
                Rectangle()
                    .fill(Color.primary.opacity(opacity))
                    .frame(height: 1)
                    .padding(.vertical, 8)
            case let .table(configuration):
                ARVisTableView(configuration: configuration)
            case let .chart(configuration):
                if #available(iOS 16, *) {
                    ChartView(chartConfiguration: configuration)
                        .id(UUID())
                }
            case let .segmentedControl(items):
                ARVisSegmentedControlView(items: items)
            case let .grid(rows):
                if #available(iOS 16, *) {
                    Grid {
                        ForEach(Array(zip(rows.indices, rows)), id: \.0) { _, row in
                            AnyView(row.view())
                        }
                    }
                } else {
                    Text("Grid component is not supported in iOS 15.")
                }
            case let .gridRow(rowElements):
                if #available(iOS 16, *) {
                    GridRow {
                        ForEach(Array(zip(rowElements.indices, rowElements)), id: \.0) { _, rowElement in
                            AnyView(rowElement.view())
                        }
                    }
                } else {
                    Text("GridRow component is not supported in iOS 15.")
                }
            }
        }
    }
}
