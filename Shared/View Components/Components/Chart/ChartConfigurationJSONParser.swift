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
        let chartData = ChartData(data: json["data"])
        chartConfig.chartData = chartData

        // Components
        var components: [ChartComponent] = []
        for component in json["components"].arrayValue {
            if let typeString = component["type"].string,
               let componentType = ChartComponentType(rawValue: typeString) {
                // Mark
                var chartComponent: ChartComponent?
                switch componentType {
                case .barMark:
                    let config = component["config"]
                    if let xStartField = config["xStart"]["field"].string,
                       let xEndField = config["xEnd"]["field"].string,
                       let yField = config["y"]["field"].string {
                        var height: CGFloat?
                        if let heightDouble = config["height"].double {
                            height = heightDouble
                        }
                        chartComponent = .barMarkRepeat1(xStart: .value(xStartField),
                                                         xEnd: .value(xEndField),
                                                         y: .value(yField),
                                                         height: height)
                        components.append(chartComponent!)
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
                                                       let valueString = hoverManualConfig["value"].string,
                                                       let contentViewElementComponent = hoverManualConfig["content"].decode(ViewElementComponent.self) {
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

        // ChartXScale
        if let chartXScale = json["xScale"].decode(ChartXScale.self) {
            chartConfig.chartXScale = chartXScale
        } else {
            if json["xScale"] != .null {
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
}

extension ChartConfigurationJSONParser {
    static let exampleJSONString1 = """
    {
      "chartConfig": {
        "data": {
          "Name": [
            "James Ensor",
            "Alexandra Daveluy",
            "Casino Communal",
            "Louis Franck",
            "Foudation Socindec",
            "Getty Museum"
          ],
          "Start": [
            "1888-01-01",
            "1949-01-01",
            "1950-01-01",
            "1954-01-01",
            "1969-01-01",
            "1987-01-01"
          ],
          "End": [
            "1949-01-01",
            "1950-01-01",
            "1954-01-01",
            "1969-01-01",
            "1987-01-01",
            "2022-01-01"
          ]
        },
        "components": [
          {
            "type": "BarMark",
            "config": {
              "xStart": {
                "field": "Start"
              },
              "xEnd": {
                "field": "End"
              },
              "y": {
                "field": "Name"
              },
              "height": 20
            },
            "interactions": [
              {
                "type": "Hover",
                "content": {
                  "type": "Manual",
                  "config": [
                    {
                      "field": "Name",
                      "value": "James Ensor",
                      "content": {}
                    }
                  ]
                }
              },
              {
                "type": "Hover",
                "tooltip": {
                  "type": "Manual",
                  "config": [
                    {
                      "field": "Name",
                      "value": "Alexandra Daveluy",
                      "content": {
                        "vStack": {
                          "elements": [
                            {
                              "text": {
                                "content": "Alexandra Daveluy"
                              }
                            },
                            {
                              "text": {
                                "content": "Alexandra Daveluy, who is James Ensor's niece, inherited the painting from James Ensor."
                              }
                            },
                            {
                              "text": {
                                "content": "1949-01-01 to 1950-01-01"
                              }
                            }
                          ]
                        }
                      }
                    }
                  ]
                }
              },
              {
                "type": "Click",
                "action": {
                  "type": "OpenURL",
                  "config": {
                    "url": "https://www.google.com"
                  }
                }
              }
            ]
          }
        ],
        "xScale": {
          "domain": [10, 20]
        },
        "styleConfig": {
          "maxHeight": 250
        }
      }
    }
    """
}
