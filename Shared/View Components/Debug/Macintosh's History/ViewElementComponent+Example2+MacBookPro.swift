//
//  ViewElementComponent+Example2+MacBookPro.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/8/29.
//

import Foundation

extension ViewElementComponent {
    static let example2_MacBookPro: ViewElementComponent = .vStack(elements: [
        .hStack(elements: [
            .vStack(elements: [
                .text(content: "MacBook Pro (16-inch, 2021)", fontStyle: ARVisFontStyle(size: 40, weight: .bold)),
                .text(content: """
                The **MacBook Pro (16-inch, 2021)** was introduced at Apple's **'Unleashed'** event on 18 October 2021, and is the first MacBook Pro (16-inch) to feature [Apple Silicon](https://en.wikipedia.org/wiki/Apple_silicon#M_series) as part of the transition from x86_64-based Intel processors.
                It was made available for preorder on 18 October 2021, and for purchase on 26 October 2021.
                The firmware identifiers are [MacBookPro18,1](https://www.theiphonewiki.com/wiki/J316sAP) ([M1 Pro](https://www.theiphonewiki.com/wiki/T6000)) and [MacBookPro18,2](https://www.theiphonewiki.com/wiki/J316cAP) ([M1 Max](https://www.theiphonewiki.com/wiki/T6001)).
                """, fontStyle: ARVisFontStyle(size: 22)),
            ], alignment: .leading),
            .spacer,
            .image(url: "https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2022/default/large_0074.jpg", width: 500),
        ], alignment: .top),
        .divider(),
        .segmentedControl(items: [
            ARVisSegmentedControlItem(title: "Specifications", component: .table(configuration:
                TableConfiguration(tableData: TableData(data: [
                    "Color Options": "**Silver** or **Space Gray**",
                    "Processor": "**M1 Pro** with 10-core CPU and 16-core GPU,\n**M1 Max** with 10-core CPU and 24-core GPU,\n**M1 Max** with 10-core CPU and 32-core GPU",
                    "Memory": "**16GB** or **32GB** LPDDR5-6400 (M1 Pro) (204.8 GB/s),\n**32GB** or **64GB** LPDDR5-6400 (M1 Max) (409.6 GB/s)",
                    "Storage": "**512GB**, **1TB**, **2TB**, **4TB** or **8TB**",
                    "Size": "0.66 inches (1.68 cm) (height) x 14.01 inches (35.57 cm) (width) x 9.77 inches (24.81 cm) (depth)",
                    "Weight": "**4.7 pounds** (2.1 kg) (M1 Pro) or **4.8 pounds** (2.2 kg) (M1 Max)",
                    "Display": """
                    **Liquid Retina XDR display**:
                    16.2-inch (diagonal) Liquid Retina XDR display; 3456-by-2234 native resolution at 254 pixels per inch

                    **XDR (Extreme Dynamic Range)**:
                    1,000,000:1 contrast ratiom
                    **XDR brightness**: 1000 nits sustained full-screen, 1600 nits peak (HDR content only)
                    **SDR brightness**: 500 nits

                    **Color**:
                    1 billion colors (8-bit + FRC)
                    **Wide Color (P3)**
                    **True Tone** technology

                    **Refresh rates**:
                    **ProMotion** technology for **adaptive** refresh rates **up to 120Hz**
                    **Fixed refresh rates**: 47.95Hz, 48.00Hz, 50.00Hz, 59.94Hz, 60.00Hz

                    **Reference modes**:
                    **Apple XDR Display (P3-1600 nits)**
                    **Apple Display (P3-500 nits)**
                    HDR Video (P3-ST 2084)
                    HDTV Video (BT.709-BT.1886)
                    NTSC Video (BT.601 SMPTE-C)
                    PAL & SECAM Video (BT.601 EBU)
                    Digital Cinema (P3-DCI)
                    Digital Cinema (P3-D65)
                    Design & Print (P3-D50)
                    Photography (P3-D65)
                    Internet & Web (sRGB)
                    """,
                    "Camera": "1080p FaceTime HD camera\nAdvanced image signal processor with computational video",
                    "Audio": "High-fidelity six-speaker sound system with force-cancelling woofers\nWide stereo sound\nSupport for spatial audio when playing music or video with Dolby Atmos on built-in speakers\nSpatial audio with dynamic head tracking when using AirPods (3rd generation), AirPods Pro, and AirPods Max\nStudio-quality three-mic array with high signal-to-noise ratio and directional beamforming\n3.5mm headphone jack with advanced support for high-impedance headphones",
                    "Charging and Expansion": "MagSafe 3 port\nThree Thunderbolt 4 (USB-C) ports with support for:\nCharging\nDisplayPort\nThunderbolt 4 (up to 40Gb/s)\nUSB 4 (up to 40Gb/s)\nHDMI port\nSDXC card slot\n3.5mm headphone jack",
                    "Wireless": "Wi-Fi\n802.11ax Wi-Fi 6 wireless networking\nIEEE 802.11a/b/g/n/ac compatible\nBluetooth\nBluetooth 5.0 wireless technology",
                    "Battery and Power": "100-watt-hour lithium-polymer battery\nCurrent: 8,693 mA⋅h\nPower: 99.6 W⋅h\nVoltage: 11.45 V\n140W USB-C Power Adapter",
                ], titles: ["Color Options", "Processor", "Memory", "Storage", "Size", "Weight", "Display", "Camera", "Audio", "Charging and Expansion", "Wireless", "Battery and Power"]),
                orientation: .vertical)
            )),
            ARVisSegmentedControlItem(title: "Family History", component: .vStack(elements: [
                .text(content: "MacBook Pro Sesries", fontStyle: ARVisFontStyle(size: 19, weight: .medium, color: .rgbaHex(string: "#3e3e43"))),
                example2_MacBookProFamilyChartViewElementComponent,
            ], alignment: .leading)),
            ARVisSegmentedControlItem(title: "Performance", component: .vStack(elements: [
                .divider(opacity: 0.2),
                .segmentedControl(items: [
                    ARVisSegmentedControlItem(title: "CPU", component: .vStack(elements: [
                        .vStack(elements: [
                            .image(url: "https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2022/default/Apple_M1-Pro-M1-Max_CPU-Performance_10182021.jpg", height: 400),
                            .text(content: "M1 Pro and M1 Max feature an up-to-10-core CPU that is up to 1.7x faster than the latest 8-core PC laptop chip at the same power level,\nand achieves the PC chip’s peak performance at up to 70 percent less power.", fontStyle: ARVisFontStyle(size: 12, weight: .medium, color: .rgbaHex(string: "#6e6e73"))),
                            example2MacBookProPerformanceLineChartViewElementComponent,
                        ]),
                    ])),
                    ARVisSegmentedControlItem(title: "GPU", component: .vStack(elements: [
                        .vStack(elements: [
                            .image(url: "https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2022/default/Apple_M1-Pro-M1-Max_M1-Max-GPU-Performance-vs-PC_10182021.jpg", height: 400),
                            .text(content: "M1 Max has an up-to-32-core GPU that delivers graphics performance comparable to that in a high-end compact PC pro laptop using up to 40 percent less power.", fontStyle: ARVisFontStyle(size: 12, weight: .medium, color: .rgbaHex(string: "#6e6e73"))),
                        ]),
                    ])),
                ]),
            ])),
            ARVisSegmentedControlItem(title: "Technical Reviews", component: .spacer),
        ]),
    ])

    static let example2_MacBookProFamilyChartViewElementComponentJSONStr = """
    {
        "vStack": {
            "elements": [
                {
                    "chart": \(ChartConfigurationExample.chartConfigurationExample2_MacBookProFamilyChart)
                },
            ]
        }
    }
    """

    static let example2MacBookProPerformanceLineChartViewElementComponentJSONStr = """
    {
        "vStack": {
            "elements": [
                {
                    "chart": \(ChartConfigurationExample.chartConfigurationExample2_MacBookProPerformanceLineChart)
                },
            ]
        }
    }
    """

    static let example2_MacBookProFamilyChartViewElementComponent: ViewElementComponent = try! JSONDecoder().decode(ViewElementComponent.self, from: example2_MacBookProFamilyChartViewElementComponentJSONStr.data(using: .utf8)!)

    static let example2MacBookProPerformanceLineChartViewElementComponent: ViewElementComponent = try! JSONDecoder().decode(ViewElementComponent.self, from: example2MacBookProPerformanceLineChartViewElementComponentJSONStr.data(using: .utf8)!)
}
