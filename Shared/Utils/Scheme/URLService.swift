//
//  URLService.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/21.
//

import Foundation
import SceneKit
import SwiftyJSON

enum URLServiceType: String, RawRepresentable {
    case link
    case openComponent
}

enum OpenComponentType: String, RawRepresentable, CaseIterable {
    case url
    case json
}

enum OpenComponent {
    case url(url: String)
    case json(json: String)
}

enum URLService {
    static let scheme = "iARVis"

    case link(href: String)
    case openComponent(config: OpenComponent, anchor: WidgetAnchorPoint, relativePosition: SCNVector3)

    var schemePrefix: String {
        Self.scheme + "://"
    }

    var url: String {
        switch self {
        case let .link(href):
            return schemePrefix + "link?" + "href=\(href.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"
        case let .openComponent(config, anchor, relativePosition):
            switch config {
            case let .url(url):
                return schemePrefix
                    + "openComponent?"
                    + "url=\(url.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"
                    + "&anchor=\(anchor.rawValue)"
                    + "&relativePosition=\(relativePosition.prettyJSON.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"
            case let .json(json):
                return schemePrefix
                    + "openComponent?"
                    + "json=\(json.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"
                    + "&anchor=\(anchor.rawValue)"
                    + "&relativePosition=\(relativePosition.prettyJSON.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"
            }
        }
    }
}

extension URL {
    var urlService: URLService? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let scheme = components.scheme,
              let host = components.host,
              let params = components.queryItems
        else { return nil }

        // URLComponents already decode url once
        if let urlService = URLServiceType(rawValue: host) {
            switch urlService {
            case .link:
                if let href = params.first(where: { $0.name == "href" })?.value,
                   let url = URL(string: href) {
                    return .link(href: href)
                }
            case .openComponent:
                for type in OpenComponentType.allCases {
                    if let value = params.first(where: { $0.name == type.rawValue })?.value {
                        var anchor: WidgetAnchorPoint
                        if let anchorValue = params.first(where: { $0.name == "anchor" })?.value,
                           let _anchor = WidgetAnchorPoint(rawValue: anchorValue) {
                            anchor = _anchor
                        } else {
                            anchor = .auto
                        }
                        var position: SCNVector3
                        if let positionValue = params.first(where: { $0.name == "relativePosition" })?.value,
                           let _position = JSON(positionValue).decode(SCNVector3.self) {
                            position = _position
                        } else {
                            position = .init(0, 0, 0)
                        }
                        switch type {
                        case .url:
                            return .openComponent(config: .url(url: value), anchor: anchor, relativePosition: position)
                        case .json:
                            return .openComponent(config: .json(json: value), anchor: anchor, relativePosition: position)
                        }
                    }
                }
            }
        }

        return nil
    }
}

extension String {
    var url: URL? {
        URL(string: self)
    }
}
