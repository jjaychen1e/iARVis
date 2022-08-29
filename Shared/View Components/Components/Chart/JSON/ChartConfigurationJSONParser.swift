//
//  ChartConfigurationJSONParser.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/14.
//

import CoreGraphics
import Foundation
import SwiftyJSON

class ChartConfigurationJSONParser {
    static let `default` = ChartConfigurationJSONParser()

    func parse(_ json: JSON) -> ChartConfiguration {
        var chartConfig = ChartConfiguration()

        // Chart Data
        if let dataSources = json["dataSources"].array {
            let chartData = ChartData(dataSources)
            chartConfig.chartData = chartData
        }

        // Components
        var componentConfigs: [ChartComponentConfiguration] = []
        for component in json["components"].arrayValue {
            if let typeString = component["type"].string,
               let componentType = ChartComponentType(rawValue: typeString) {
                let config = component["config"]
                var dataKey = "default"
                if let extractedDataKey = config["dataKey"].string {
                    dataKey = extractedDataKey
                }

                guard chartConfig.chartData.dataItems.keys.contains(dataKey) else {
                    continue
                }

                let chartComponentCommonConfig = config.decode(ChartComponentCommonConfig.self) ?? .init()

                // Mark
                var chartComponent: ChartComponent?
                switch componentType {
                case .barMark:
                    if let xStartField = config["xStart"]["field"].string,
                       let xEndField = config["xEnd"]["field"].string,
                       let yField = config["y"]["field"].string {
                        var height: CGFloat?
                        if let heightDouble = config["height"].double {
                            height = heightDouble
                        }
                        chartComponent = .barMarkRepeat1(dataKey: dataKey,
                                                         xStart: .value(xStartField),
                                                         xEnd: .value(xEndField),
                                                         y: .value(yField),
                                                         height: height)
                        componentConfigs.append(.init(component: chartComponent!, commonConfig: chartComponentCommonConfig))
                    }
                case .lineMark:
                    let config = component["config"]
                    if let xField = config["x"]["field"].string,
                       let yField = config["y"]["field"].string {
                        chartComponent = .lineMarkRepeat1(dataKey: dataKey,
                                                          x: .value(xField),
                                                          y: .value(yField))
                        componentConfigs.append(.init(component: chartComponent!, commonConfig: chartComponentCommonConfig))
                    }
                case .rectangleMark:
                    let config = component["config"]
                    if let xStartField = config["xStart"]["field"].string,
                       let xEndField = config["xEnd"]["field"].string,
                       let yStartField = config["yStart"]["field"].string,
                       let yEndField = config["yEnd"]["field"].string {
                        chartComponent = .rectangleMarkRepeat1(dataKey: dataKey,
                                                               xStart: .value(xStartField),
                                                               xEnd: .value(xEndField),
                                                               yStart: .value(yStartField),
                                                               yEnd: .value(yEndField))
                        componentConfigs.append(.init(component: chartComponent!, commonConfig: chartComponentCommonConfig))
                    }
                case .ruleMark:
                    let config = component["config"]
                    if let xField = config["x"]["field"].string {
                        if let yStartField = config["yStart"]["field"].string,
                           let yEndField = config["yEnd"]["field"].string {
                            chartComponent = .ruleMarkRepeat1(dataKey: dataKey,
                                                              x: .value(xField),
                                                              yStart: .value(yStartField),
                                                              yEnd: .value(yEndField))
                        } else {
                            chartComponent = .ruleMarkRepeat1(dataKey: dataKey,
                                                              x: .value(xField))
                        }
                        componentConfigs.append(.init(component: chartComponent!, commonConfig: chartComponentCommonConfig))
                    }
                case .pointMark:
                    let config = component["config"]
                    if let xField = config["x"]["field"].string,
                       let yField = config["y"]["field"].string {
                        chartComponent = .pointMarkRepeat1(dataKey: dataKey, x: .value(xField), y: .value(yField))
                        componentConfigs.append(.init(component: chartComponent!, commonConfig: chartComponentCommonConfig))
                    }
                }

                // Interaction
                if let chartComponent = chartComponent {
                    var interactions: [ChartComponent: [ChartInteraction]] = [:]
                    if let interactionsJSON = component["interactions"].array {
                        for interactionJSON in interactionsJSON {
                            if let interactionTypeString = interactionJSON["type"].string,
                               let interactionType = ChartInteractionType(rawValue: interactionTypeString) {
                                switch interactionType {
                                case .hover:
                                    let tooltipJSON = interactionJSON["tooltip"]
                                    if let tooltipTypeString = tooltipJSON["type"].string,
                                       let tooltipType = ChartInteractionHoverTooltipType(rawValue: tooltipTypeString) {
                                        switch tooltipType {
                                        case .manual:
                                            var hoverManualConfigArray: [ChartInteractionHoverTooltipManualConfig] = []
                                            if let hoverManualConfigJSONArray = tooltipJSON["config"].array {
                                                for hoverManualConfig in hoverManualConfigJSONArray {
                                                    if let fieldString = hoverManualConfig["field"].string,
                                                       hoverManualConfig["value"] != .null,
                                                       let contentViewElementComponent = hoverManualConfig["content"].decode(ViewElementComponent.self) {
                                                        let valueString = hoverManualConfig["value"]
                                                        hoverManualConfigArray.append(.init(field: fieldString, value: valueString, content: contentViewElementComponent))
                                                    }
                                                }
                                            }
                                            interactions[chartComponent, default: []].append(.hover(tooltip: .manual(contents: hoverManualConfigArray)))
                                        case .auto:
                                            fatalErrorDebug()
                                        }
                                    }
                                case .click:
                                    let actionJSON = interactionJSON["action"]
                                    if let actionTypeString = actionJSON["type"].string,
                                       let actionType = ChartInteractionClickActionType(rawValue: actionTypeString) {
                                        let configJSON = actionJSON["config"]
                                        switch actionType {
                                        case .openURL:
                                            if let urlString = configJSON["url"].string,
                                               let url = URL(string: urlString) {
                                                interactions[chartComponent, default: []].append(.click(action: .openURL(url: url)))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    chartConfig.interactionData.componentInteraction = interactions
                }
            }
        }
        chartConfig.componentConfigs = componentConfigs

        // ChartXScale
        if let chartXScale = json["xScale"].decode(ChartXScale.self) {
            chartConfig.chartXScale = chartXScale
        } else {
            if json["xScale"] != .null {
                fatalErrorDebug()
            }
        }

        // ChartXAxis
        if let chartXAxis = json["chartXAxis"].decode(ChartXAxis.self) {
            chartConfig.chartXAxis = chartXAxis
        } else {
            if json["chartXAxis"] != .null {
                fatalErrorDebug()
            }
        }

        // ChartYAxis
        if let chartYAxis = json["chartYAxis"].decode(ChartYAxis.self) {
            chartConfig.chartYAxis = chartYAxis
        } else {
            if json["chartYAxis"] != .null {
                fatalErrorDebug()
            }
        }

        // Style Configuration
        if let chartStyleConfig = json["styleConfig"].decode(ChartStyleConfiguration.self) {
            chartConfig.styleConfiguration = chartStyleConfig
        } else {
            if json["styleConfig"] != .null {
                fatalErrorDebug()
            }
        }

        return chartConfig
    }

    func encode(_ chartConfiguration: ChartConfiguration) -> JSON {
        var result = JSON([:])

        // Chart Data
        result["dataSources"] = JSON(chartConfiguration.chartData.dataItems.map { label, item in
            [
                "label": label,
                "titles": item.titles,
                "data": item.data,
            ]
        })

        // Components
        result["components"] = JSON(chartConfiguration.componentConfigs.map { componentConfig in
            var componentJSON = JSON()
            componentJSON["config"] = [:]

            let component = componentConfig.component
            let commonConfig = componentConfig.commonConfig

            // Component Mark
            switch component {
            case let .barMarkRepeat1(dataKey, xStart, xEnd, y, height):
                componentJSON["type"] = "BarMark"
                componentJSON["config"]["dataKey"] = JSON(dataKey)
                componentJSON["config"]["xStart"] = [:]
                componentJSON["config"]["xStart"]["field"] = JSON(xStart.field)
                componentJSON["config"]["xEnd"] = [:]
                componentJSON["config"]["xEnd"]["field"] = JSON(xEnd.field)
                componentJSON["config"]["y"] = [:]
                componentJSON["config"]["y"]["field"] = JSON(y.field)
                if let height = height {
                    componentJSON["config"]["height"] = JSON(height)
                }
            case let .lineMarkRepeat1(dataKey, x, y):
                componentJSON["type"] = "LineMark"
                componentJSON["config"]["dataKey"] = JSON(dataKey)
                componentJSON["config"]["x"] = [:]
                componentJSON["config"]["x"]["field"] = JSON(x.field)
                componentJSON["config"]["y"] = [:]
                componentJSON["config"]["y"]["field"] = JSON(y.field)
            case let .rectangleMarkRepeat1(dataKey, xStart, xEnd, yStart, yEnd):
                componentJSON["type"] = "RectangleMark"
                componentJSON["config"]["dataKey"] = JSON(dataKey)
                componentJSON["config"]["xStart"] = [:]
                componentJSON["config"]["xStart"]["field"] = JSON(xStart.field)
                componentJSON["config"]["xEnd"] = [:]
                componentJSON["config"]["xEnd"]["field"] = JSON(xEnd.field)
                componentJSON["config"]["yStart"] = [:]
                componentJSON["config"]["yStart"]["field"] = JSON(yStart.field)
                componentJSON["config"]["yEnd"] = [:]
                componentJSON["config"]["yEnd"]["field"] = JSON(yEnd.field)
            case let .ruleMarkRepeat1(dataKey, x, yStart, yEnd):
                componentJSON["type"] = "RuleMark"
                componentJSON["config"]["dataKey"] = JSON(dataKey)
                componentJSON["config"]["x"] = [:]
                componentJSON["config"]["x"]["field"] = JSON(x.field)
                if let yStart = yStart {
                    componentJSON["config"]["yStart"] = [:]
                    componentJSON["config"]["yStart"]["field"] = JSON(yStart.field)
                }
                if let yEnd = yEnd {
                    componentJSON["config"]["yEnd"] = [:]
                    componentJSON["config"]["yEnd"]["field"] = JSON(yEnd.field)
                }
            case let .pointMarkRepeat1(dataKey, x, y):
                componentJSON["type"] = "PointMark"
                componentJSON["config"]["dataKey"] = JSON(dataKey)
                componentJSON["config"]["x"] = [:]
                componentJSON["config"]["x"]["field"] = JSON(x.field)
                componentJSON["config"]["y"] = [:]
                componentJSON["config"]["y"]["field"] = JSON(y.field)
            }

            // Component Common Config
            try? componentJSON["config"].merge(with: JSON(parseJSON: commonConfig.prettyJSON))

            // Interactions
            let interactions = chartConfiguration.interactionData.componentInteraction[component, default: []]
            if interactions.count > 0 {
                componentJSON["interactions"] = JSON(interactions.map { interaction in
                    var interactionJSON = JSON()
                    switch interaction {
                    case let .hover(tooltip):
                        interactionJSON["type"] = "Hover"
                        interactionJSON["tooltip"] = [:]
                        switch tooltip {
                        case let .manual(contents):
                            interactionJSON["tooltip"]["type"] = "Manual"
                            interactionJSON["tooltip"]["config"] = JSON(
                                contents.map { content in
                                    [
                                        "field": content.field,
                                        "value": content.value,
                                        "content": JSON(parseJSON: content.content.prettyJSON),
                                    ]
                                }
                            )
                        case .auto:
                            interactionJSON["tooltip"]["type"] = "Auto"
                            // TODO: Auto mode
                        }
                    case let .click(action):
                        interactionJSON["type"] = "Click"
                        interactionJSON["action"] = [:]
                        switch action {
                        case let .openURL(url: url):
                            interactionJSON["tooltip"]["type"] = "OpeURL"
                            interactionJSON["tooltip"]["config"] = JSON(
                                [
                                    "url": url,
                                ]
                            )
                        }
                    }
                    return interactionJSON
                })
            }

            return componentJSON
        })

        // ChartXScale
        if let chartXScale = chartConfiguration.chartXScale {
            result["xScale"] = JSON(parseJSON: chartXScale.prettyJSON)
        }

        // ChartXAxis
        if let chartXAxis = chartConfiguration.chartXAxis {
            result["chartXAxis"] = JSON(parseJSON: chartXAxis.prettyJSON)
        }

        // ChartYAxis
        if let chartYAxis = chartConfiguration.chartYAxis {
            result["chartYAxis"] = JSON(parseJSON: chartYAxis.prettyJSON)
        }

        // Style Configuration
        if let styleConfig = chartConfiguration.styleConfiguration {
            result["styleConfig"] = JSON(parseJSON: styleConfig.prettyJSON)
        }

        return result
    }
}

extension ChartConfigurationJSONParser {
    static let exampleJSONString1: String = {
        let path = Bundle(for: type(of: ChartConfigurationJSONParser.default)).bundleURL.appending(path: "chartConfigurationExample1.json")
        return try! String(contentsOfFile: path.path)
    }()

    static let exampleJSONString2: String = {
        let path = Bundle(for: type(of: ChartConfigurationJSONParser.default)).bundleURL.appending(path: "chartConfigurationExample2.json")
        return try! String(contentsOfFile: path.path)
    }()

    static let exampleJSONString3: String = {
        let path = Bundle(for: type(of: ChartConfigurationJSONParser.default)).bundleURL.appending(path: "chartConfigurationExample3.json")
        return try! String(contentsOfFile: path.path)
    }()
}
