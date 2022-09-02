//
//  ChartView+Annotation.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/31.
//

import Charts
import Foundation
import SwiftUI
import SwiftyJSON

@available(iOS 16, *)
extension ChartView {
    @ViewBuilder
    func chartAnnotationHandler(proxy: ChartProxy, chartConfiguration: ChartConfiguration) -> some View {
        let componentConfigs = chartConfiguration.componentConfigs
        ForEach(0 ..< componentConfigs.count, id: \.self) { index in
            let componentConfig = componentConfigs[index]
            let component = componentConfig.component
            let commonConfig = componentConfig.commonConfig
            if let dataItem = chartConfiguration.chartData.dataItems[component.dataKey] {
                if let annotations = commonConfig.annotations {
                    annotationsView(proxy: proxy, component: component, annotations: annotations, dataItem: dataItem)
                }

                if let conditionalAnnotations = commonConfig.conditionalAnnotations {
                    conditionalAnnotationsView(proxy: proxy, component: component, conditionalAnnotations: conditionalAnnotations, dataItem: dataItem)
                }
            }
        }
    }

    private func annotationsView(proxy: ChartProxy, component: ChartComponent, annotations: [ARVisAnnotation], dataItem: ChartDataItem) -> some View {
        ForEach(0 ..< annotations.count, id: \.self) { annotationIndex in
            let annotation = annotations[annotationIndex]
            if let datum = dataItem.datum(at: 0) {
                annotationView(proxy: proxy, component: component, annotation: annotation, datum: datum)
            }
        }
    }

    private func conditionalAnnotationsView(proxy: ChartProxy, component: ChartComponent, conditionalAnnotations: [ARVisConditionalAnnotation], dataItem: ChartDataItem) -> some View {
        ForEach(0 ..< conditionalAnnotations.count, id: \.self) { conditionalAnnotationIndex in
            let conditionalAnnotation = conditionalAnnotations[conditionalAnnotationIndex]
            let field = conditionalAnnotation.field
            let value = conditionalAnnotation.value
            let datum: JSON = {
                for i in 0 ..< dataItem.length {
                    if dataItem.data[field].array?[safe: i] == value {
                        return dataItem.datum(at: i)
                    }
                }
                return .null
            }()
            if datum != .null {
                annotationView(proxy: proxy, component: component, annotation: conditionalAnnotation.annotation, datum: datum)
            }
        }
    }

    @ViewBuilder
    private func annotationView(proxy: ChartProxy, component: ChartComponent, annotation: ARVisAnnotation, datum: JSON) -> some View {
        GeometryReader { geoProxy in
            let additionalOffset = CGPoint(x: geoProxy[proxy.plotAreaFrame].origin.x, y: geoProxy[proxy.plotAreaFrame].origin.y)
            switch component {
            case let .barMarkRepeat1(_, xStart, xEnd, y, height):
                if let xStartPosition = proxy.position(atX: datum[xStart.field]),
                   let xEndPosition = proxy.position(atX: datum[xEnd.field]),
                   let yPosition = proxy.position(atY: datum[y.field]),
                   let yRange = proxy.positionRange(atY: datum[y.field]) {
                    let yHeight = yPosition - yRange.lowerBound
                    let rectangle = CGRect(origin: CGPoint(x: xStartPosition, y: yPosition), size: CGSize(width: xEndPosition - xStartPosition, height: height ?? yHeight))
                    place(geoProxy: geoProxy, annotation: annotation, in: CGRect(origin: rectangle.origin + additionalOffset, size: rectangle.size))
                }
            case let .barMarkRepeat2(dataKey, x, y, height):
                if let xPosition = proxy.position(atX: datum[x.field]),
                   let yPosition = proxy.position(atY: datum[y.field]),
                   let xRange = proxy.positionRange(atX: datum[x.field]),
                   let yRange = proxy.positionRange(atY: datum[y.field]) {
                    let yHeight = proxy.plotAreaSize.height - yPosition
                    let rectangle = CGRect(origin: CGPoint(x: xPosition - xRange.length / 2, y: yPosition), size: CGSize(width: xRange.length, height: height ?? yHeight))
                    place(geoProxy: geoProxy, annotation: annotation, in: CGRect(origin: rectangle.origin + additionalOffset, size: rectangle.size))
                }
            case let .lineMarkRepeat1(_, x, y):
                if let xPosition = proxy.position(atX: datum[x.field]),
                   let yPosition = proxy.position(atY: datum[y.field]) {
                    let rectangle = CGRect(origin: CGPoint(x: xPosition, y: yPosition), size: CGSize(width: 1, height: 1))
                    place(geoProxy: geoProxy, annotation: annotation, in: CGRect(origin: rectangle.origin + additionalOffset, size: rectangle.size))
                }
            case let .lineMarkRepeat2(dataKey: dataKey, x: x, ySeries: ySeries):
                // TODO: lineMarkRepeat2
                EmptyView()
            case let .rectangleMarkRepeat1(_, xStart, xEnd, yStart, yEnd):
                if let xStartPosition = proxy.position(atX: datum[xStart.field]),
                   let xEndPosition = proxy.position(atX: datum[xEnd.field]),
                   let yStartPosition = proxy.position(atX: datum[yStart.field]),
                   let yEndPosition = proxy.position(atX: datum[yEnd.field]) {
                    let rectangle = CGRect(origin: CGPoint(x: xStartPosition, y: yStartPosition), size: CGSize(width: xEndPosition - xStartPosition, height: yEndPosition - yStartPosition))
                    place(geoProxy: geoProxy, annotation: annotation, in: CGRect(origin: rectangle.origin + additionalOffset, size: rectangle.size))
                }
            case let .ruleMarkRepeat1(_, x, yStart, yEnd):
                if let xRange = proxy.positionRange(atX: datum[x.field]) {
                    let yStartPosition: CGFloat = {
                        if let yStart = yStart {
                            return proxy.position(atY: datum[yStart.field]) ?? 0
                        } else {
                            return 0
                        }
                    }()
                    let yEndPosition: CGFloat = {
                        let plotAreaHeight = proxy.plotAreaSize.height
                        if let yEnd = yEnd {
                            return proxy.position(atY: datum[yEnd.field]) ?? plotAreaHeight
                        } else {
                            return plotAreaHeight
                        }
                    }()
                    let rectangle = CGRect(origin: CGPoint(x: xRange.lowerBound, y: yStartPosition), size: CGSize(width: xRange.length, height: yEndPosition - yStartPosition))
                    place(geoProxy: geoProxy, annotation: annotation, in: CGRect(origin: rectangle.origin + additionalOffset, size: rectangle.size))
                }
            case let .pointMarkRepeat1(_, x, y):
                if let xPosition = proxy.position(atX: datum[x.field]),
                   let yPosition = proxy.position(atY: datum[y.field]) {
                    let rectangle = CGRect(origin: CGPoint(x: xPosition, y: yPosition), size: CGSize(width: 1, height: 1))
                    place(geoProxy: geoProxy, annotation: annotation, in: CGRect(origin: rectangle.origin + additionalOffset, size: rectangle.size))
                }
            }
        }
    }

    @ViewBuilder
    private func place(geoProxy: GeometryProxy, annotation: ARVisAnnotation, in rectangle: CGRect) -> some View {
        let position = annotation.position
        Rectangle()
//            .fill(.red.opacity(0.5))
            .fill(.clear)
            .frame(width: max(1, rectangle.size.width), height: max(1, rectangle.size.height))
            .outsideOverlay(alignment: .init(position)) {
                annotation.content.view()
            }
            .offset(rectangle.origin)
    }
}

private extension ClosedRange where Bound == CGFloat {
    var length: CGFloat {
        upperBound - lowerBound
    }
}
