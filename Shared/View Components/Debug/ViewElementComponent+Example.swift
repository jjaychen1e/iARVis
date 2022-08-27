//
//  ViewElementComponent+Example.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/11.
//

import Foundation

extension ViewElementComponent {
    static let example1: ViewElementComponent = {
        .vStack(elements: [
        ])
    }()

    static let exampleVStack: ViewElementComponent = {
        .vStack(elements: [
        ])
    }()

    static let exampleArtworkTimeSheetTooltip: ViewElementComponent = {
        .vStack(elements: [
            .text(content: "Alexandra Daveluy"),
            .text(content: "Alexandra Daveluy, who is James Ensor's niece, inherited the painting from James Ensor."),
            .text(content: "1949-01-01 to 1950-01-01"),
        ])
    }()

    static let exampleChartConfigurationDecodeJSONStr = """
    {
        "vStack": {
            "elements": [
                {
                    "chart": \(ChartConfigurationJSONParser.exampleJSONString1)
                },
                {
                    "text": {
                        "content": "History of this Artwork - Provenance",
                        "fontStyle" : {
                            "size": 15,
                            "weight": "light"
                        }
                    }
                },
                \(ViewElementComponent.text(content: "[Additional Widget Test](\(URLService.openComponent(config: .json(json: exampleArtworkTimeSheetTooltip.prettyJSON), anchor: .leading, relativePosition: .zero).url))", fontStyle: ARVisFontStyle(size: 24, weight: .bold)).prettyJSON)
            ]
        }
    }
    """

    static let exampleLineChartConfigurationDecodeJSONStr = """
    {
        "vStack": {
            "elements": [
                {
                    "chart": \(ChartConfigurationJSONParser.exampleJSONString2)
                },
                {
                    "text": {
                        "content": "History of this Artwork - Historical Price",
                        "fontStyle" : {
                            "size": 15,
                            "weight": "light"
                        }
                    }
                }
            ]
        }
    }
    """

    static let exampleChartConfigurationDecode: ViewElementComponent = try! JSONDecoder().decode(ViewElementComponent.self, from: exampleChartConfigurationDecodeJSONStr.data(using: .utf8)!)

    static let exampleLineChartConfigurationDecode: ViewElementComponent = try! JSONDecoder().decode(ViewElementComponent.self, from: exampleLineChartConfigurationDecodeJSONStr.data(using: .utf8)!)

    static let exampleArtworkWidgetVideo: ViewElementComponent = .video(url: "https://youtu.be/D7WdO4DcHaA", height: 300)

    static let exampleArtworkWidget: ViewElementComponent = {
        .vStack(elements: [
            .hStack(elements: [
                .vStack(elements: [
                    .text(content: "Christ's Entry into Brussels in 1889", fontStyle: ARVisFontStyle(size: 24, weight: .bold)),
                    .text(content: "[Additional Widget Test](\(URLService.openComponent(config: .json(json: exampleChartConfigurationDecodeJSONStr), anchor: .top, relativePosition: .zero).url))", fontStyle: ARVisFontStyle(size: 24, weight: .bold)),
                    .text(content: "1888", fontStyle: ARVisFontStyle(size: 20, weight: .medium)),
                    .text(content: "[James Ensor](https://www.getty.edu/art/collection/person/103JT2) (Belgian, 1860 - 1949)",
                          fontStyle: ARVisFontStyle(size: 20)),
                    .text(content: "On view at [Getty Center, Museum West Pavilion, Gallery W103](https://www.getty.edu/art/collection/gallery/103M5Q)"),
                    .spacer,
                    .text(content: "Introduction audio(English)", fontStyle: ARVisFontStyle(size: 17, weight: .light)),
                    .audio(title: "Christ's Entry into Brussels in 1889 (Highlights)", url: "https://dea3n992em6cn.cloudfront.net/museumcollection/000932-en-20210324-v1.mp3"),
                ], alignment: .leading, spacing: 4),
                .image(url: "https://media.getty.edu/iiif/image/ce4d5a1f-ee25-44b3-afa2-d597d43056ff/full/1024,/0/default.jpg?download=ce4d5a1f-ee25-44b3-afa2-d597d43056ff_1024.jpg&size=small"),
            ], alignment: .top),
            .divider(),
            .segmentedControl(items: [
                ARVisSegmentedControlItem(title: "Introduction", component: .vStack(elements: [
                    .text(content: "Introduction", fontStyle: ARVisFontStyle(size: 22, weight: .medium)),
                    .hStack(elements: [
                        .spacer,
                        exampleArtworkWidgetVideo,
                        .spacer,
                    ]),
                    .text(content: "James Ensor took on religion, politics, and art in this scene of Christ entering contemporary Brussels in a Mardi Gras parade. In response to the French pointillist style, Ensor used palette knives, spatulas, and both ends of his brush to put down patches of colors with expressive freedom. He made several preparatory drawings for the painting, including one in the J. Paul Getty Museum's collection."),
                    .text(content: "Ensor's society is a mob, threatening to trample the viewer -- a crude, ugly, chaotic, dehumanized sea of masks, frauds, clowns, and caricatures. Public, historical, and allegorical figures, along with the artist's family and friends, make up the crowd. The haloed Christ at the center of the turbulence is in part a self-portrait: mostly ignored, a precarious, isolated visionary amidst the herdlike masses of modern society. Ensor's Christ functions as a political spokesman for the poor and oppressed--a humble leader of the true religion, in opposition to the atheist social reformer Emile Littré, shown in bishop's garb holding a drum major's baton and leading on the eager, mindless crowd."),
                    .text(content: "After rejection by Les XX, the artists' association that Ensor had helped to found, the painting was not exhibited publicly until 1929. Ensor displayed Christ's Entry prominently in his home and studio throughout his life. With its aggressive, painterly style and merging of the public with the deeply personal, Christ's Entry was a forerunner of twentieth-century Expressionism."),
                ], alignment: .leading, spacing: 8)),
                ARVisSegmentedControlItem(title: "Provenance", component: .vStack(elements: [
                    .text(content: "Provenance", fontStyle: ARVisFontStyle(size: 22, weight: .medium)),
                    exampleChartConfigurationDecode,
                ], alignment: .leading, spacing: 4)),
                ARVisSegmentedControlItem(title: "Historical Price", component: .vStack(elements: [
                    .text(content: "Historical Price", fontStyle: ARVisFontStyle(size: 22, weight: .medium)),
                    exampleLineChartConfigurationDecode,
                ], alignment: .leading, spacing: 4)),
                ARVisSegmentedControlItem(title: "Full Artwork Details", component: .table(configuration:
                    TableConfiguration(tableData: TableData(data: [
                        "Title": "Christ's Entry into Brussels in 1889",
                        "Artist/Maker": "[James Ensor](https://www.getty.edu/art/collection/person/103JT2) (Belgian, 1860 - 1949)",
                        "Date": "1888",
                        "Medium": "[Oil on canvas](https://www.getty.edu/art/collection/search?materials=Oil%20on%20canvas)",
                        "Dimensions": "252.6 × 431 cm (99 7/16 × 169 11/16 in.)",
                        "Place": "[Belgium](https://www.getty.edu/art/collection/search?q=%22Belgium%22) (Place Created)",
                        "Culture": "[Belgian](https://www.getty.edu/art/collection/search?q=%22Belgium%22)",
                        "Signature(s)": "Signed and dated lower right, beneath the elevated platform: \"J. ENSOR / 1888\"",
                        "Object Number": "87.PA.96",
                        "Inscription(s)": "On red banner at top: \"VIVE LA SOCiALE\"; on lozenge-shaped banner left of center: \"FANFARES DOCTRINAiRES / TOUJOURS RÉUSSi\"; on red banner at lower right: \"VIVE JESUS / ROI DE / BrUXLLES\"",
                        "Department": "[Paintings](https://www.getty.edu/art/collection/search?department=Paintings)",
                        "Classification": "[Painting](https://www.getty.edu/art/collection/search?classification=Painting)",
                        "Object Type": "[Painting](https://www.getty.edu/art/collection/search?object_type=Painting)",
                    ], titles: ["Title", "Artist/Maker", "Date", "Medium", "Dimensions", "Place", "Culture", "Signature(s)", "Object Number", "Inscription(s)", "Department", "Classification", "Object Type"]),
                    orientation: .vertical)
                )),
            ]),
        ], alignment: .leading, spacing: 4)
    }()

    static let exampleJamesEnsorLifeChart: ViewElementComponent = try! JSONDecoder().decode(ViewElementComponent.self, from: """
    {"chart":\(ChartConfigurationJSONParser.exampleJSONString3)}
    """.data(using: .utf8)!)

    static let exampleJamesEnsorWidget: ViewElementComponent = {
        .vStack(elements: [
            .hStack(elements: [
                .vStack(elements: [
                    .text(content: "James Ensor", fontStyle: ARVisFontStyle(size: 50, weight: .bold)),
                    .text(content: "FLEMISH PAINTER, ENGRAVER, WRITER, AND MUSICIAN", fontStyle: ARVisFontStyle(size: 24, weight: .medium)),
                    .text(content: "**Born**: April 13, 1860 - Ostend, Belgium",
                          fontStyle: ARVisFontStyle(size: 22)),
                    .text(content: "**Died**: November 19, 1949 - Ostend, Belgium",
                          fontStyle: ARVisFontStyle(size: 22)),
                    .text(content: "**Movements and Styles**: [Realism](https://www.theartstory.org/movement/realism/), [Impressionism](https://www.theartstory.org/movement/impressionism/), [Neo-Impressionism](https://www.theartstory.org/movement/neo-impressionism/), [Expressionism](https://www.theartstory.org/movement/expressionism/)",
                          fontStyle: ARVisFontStyle(size: 22)),
                    exampleJamesEnsorLifeChart
                ], alignment: .leading, spacing: 4),
                .spacer,
                .image(url: "https://uploads8.wikiart.org/images/james-ensor.jpg", height: 300),
            ], alignment: .top, spacing: 8),
            .divider(),
            .hStack(elements: [
                .spacer,
                .segmentedControl(items: [
                    ARVisSegmentedControlItem(title: "Introduction", component: .vStack(elements: [
                        .text(content: "Summary of James Ensor", fontStyle: ARVisFontStyle(size: 24, weight: .medium)),
                        .vStack(elements: [
                            .text(content: "Although educated in traditional painting, Ensor quickly stepped off that path and began to develop a revolutionary style that reflected his own take on modern life. He was particularly fascinated with the popular carnival culture organized around the celebration of Mardi Gras each year throughout Belgium, most certainly influenced by the fact that his family's shop in Ostend was a main purveyor of carnival paraphernalia. The imagery he produced is consistently cynical and mocking; presenting an almost grotesque form of [Realism](https://www.theartstory.org/movement/realism/) meant to record the stresses underlying contemporary social morays of his time, and probably of all times."),
                        ]),
                        .divider(opacity: 0.2),
                        text(content: "Accomplishments", fontStyle: ARVisFontStyle(size: 24, weight: .medium)),
                        .vStack(elements: [
                            .hStack(elements: [
                                .text(content: "1️⃣"),
                                .text(content: "Ensor developed a revolutionary method of painting better suited to his personal agenda. Abandoning the usage of illusionism and one-point perspective to organize the image depicted, he began to build volume with patches of color across the surface of the canvas. The effect was imagery that no longer receded but instead, threatened to enter the viewer's space. Crowded to the point of bursting, denied room to breathe, the figures in Ensor's works impress with their presence.\n"),
                                .spacer,
                            ], alignment: .top),
                            .hStack(elements: [
                                .text(content: "2️⃣"),
                                .text(content: """
                                 The artist was particularly intrigued by the carnival theme and found it an excellent means by which to capture society's foibles. He masked his figures, giving them faces that would express their inner selves rather than their outer, anatomical ones. In this way he was able to dig beneath the surface and reveal the "true face" of society. His exploration of society unmasked eventually caused his rejection by many, even the local avant-garde artists.\n
                                """),
                                .spacer,
                            ], alignment: .top),
                            .hStack(elements: [
                                .text(content: "3️⃣"),
                                .text(content: "Ensor's social commentary, at first subtle, eventually took on a furiously cynical tone. While it could be noted in the inclusion of a jesting element within an image it could also be a full-blast attack on a subject as sacred as the Entrance of Christ into Jerusalem. There's no question that the artist's continual feeling of rejection was responsible for his frenzied critiques, but the end result was simply further alienation.\n"),
                                .spacer,
                            ], alignment: .top),
                        ]),
                        .divider(opacity: 0.2),
                        .text(content: "Introduction Video", fontStyle: ARVisFontStyle(size: 24, weight: .medium)),
                        .hStack(elements: [
                            .spacer,
                            .vStack(elements: [
                                .video(url: "https://www.youtube.com/watch?v=rC3K-b31hCA", height: 400),
                                .text(content: "Life and Art of James Ensor with Christian Conrad - Join Dr. Christina Conrad for a lecture about the life and art of James Ensor.", fontStyle: ARVisFontStyle(size: 17, weight: .light)),
                            ]),
                            .spacer,
                        ]),
                    ], alignment: .leading, spacing: 8)),
                    ARVisSegmentedControlItem(
                        title: "Progression of Art",
                        component: .vStack(elements: [
                            .text(content: "1883 - Portrait of the Painter in a Flowered Hat",
                                  fontStyle: ARVisFontStyle(size: 24, weight: .bold)),
                            .hStack(elements: [
                                .image(url: "https://www.theartstory.org/images20/works/ensor_james_1.jpg?1", width: 500),
                                .vStack(elements: [
                                    .text(content: "_Portrait of the Painter_ in a Flowered Hat represents Ensor in a three-quarter view, openly confronting the viewer's gaze. His use of loose, feathery brushstrokes and the juxtaposition of colored areas on the canvas to suggest volume and the emphasis on differentiating light in order to suggest depth, typify the contemporary portraiture work of the Impressionists who were already painting in Belgium and Holland from the 1870s.\n"),
                                    .text(content: "Like many artists before him, Ensor received great inspiration from the tradition of the great masters. This portrait recalls the Flemish painter Peter Paul Rubens' _Self-Portrait_ with Hat, (1623-25). Despite the vague similarities between the two images they actually differ quite a bit and there is a clear sense that Ensor is making a joke of the tradition of the old master who he ostensibly emulates. The hat he sports, adorned with pastel flowers and feathers, was part of a traditional Belgian costume worn by women during the mid-lent carnival. And although the facial hair seems close to that of Rubens', he works blue flame-like whiskers into his mustache in a very untraditional manner. Although both depicted figures have an intense expression, suggesting something of their state of mind, Ensor alleviates the unhappy set of his own mouth with the gaiety of the hat.\n"),
                                    .text(content: """
                                    This painting's light-hearted motifs represent a transition in Ensor's work from his "somber period" to his "light period;" the move from Realism to some form of whimsical reality. It marks the beginning of his experimentation with playful subjects and alternate meanings.\n
                                    """),
                                    .text(content: "Oil on canvas - Ensor Museum, Ostend, Belgium", fontStyle: ARVisFontStyle(size: 17, weight: .light)),
                                ], alignment: .leading),
                            ], alignment: .top, spacing: 16),
                            .divider(opacity: 0.2),
                            .text(content: "1889 - Christ's Entry into Brussels",
                                  fontStyle: ARVisFontStyle(size: 24, weight: .bold)),
                            .hStack(elements: [
                                .image(url: "https://www.theartstory.org/images20/works/ensor_james_2.jpg?1", width: 500),
                                .vStack(elements: [
                                    .text(content: "_Portrait of the Painter_ in a Flowered Hat represents Ensor in a three-quarter view, openly confronting the viewer's gaze. His use of loose, feathery brushstrokes and the juxtaposition of colored areas on the canvas to suggest volume and the emphasis on differentiating light in order to suggest depth, typify the contemporary portraiture work of the Impressionists who were already painting in Belgium and Holland from the 1870s.\n"),
                                    .text(content: "Like many artists before him, Ensor received great inspiration from the tradition of the great masters. This portrait recalls the Flemish painter Peter Paul Rubens' _Self-Portrait_ with Hat, (1623-25). Despite the vague similarities between the two images they actually differ quite a bit and there is a clear sense that Ensor is making a joke of the tradition of the old master who he ostensibly emulates. The hat he sports, adorned with pastel flowers and feathers, was part of a traditional Belgian costume worn by women during the mid-lent carnival. And although the facial hair seems close to that of Rubens', he works blue flame-like whiskers into his mustache in a very untraditional manner. Although both depicted figures have an intense expression, suggesting something of their state of mind, Ensor alleviates the unhappy set of his own mouth with the gaiety of the hat.\n"),
                                    .text(content: """
                                    This painting's light-hearted motifs represent a transition in Ensor's work from his "somber period" to his "light period;" the move from Realism to some form of whimsical reality. It marks the beginning of his experimentation with playful subjects and alternate meanings.\n
                                    """),
                                    .text(content: "Oil on canvas - The J. Paul Getty Museum, Los Angeles, California", fontStyle: ARVisFontStyle(size: 17, weight: .light)),
                                ], alignment: .leading),
                            ], alignment: .top, spacing: 16),
                            .divider(opacity: 0.2),
                            .text(content: "1890 - The Baths at Ostend",
                                  fontStyle: ARVisFontStyle(size: 24, weight: .bold)),
                            .hStack(elements: [
                                .image(url: "https://www.theartstory.org/images20/works/ensor_james_3.jpg?1", width: 500),
                                .vStack(elements: [
                                    .text(content: "Here, Ensor draws a whimsical scene, paying homage to his beloved Ostend Sea. By this time the town of Ostend had become a seaside resort, known for its casino, boardwalk, beach, and restorative baths. Ensor uses colored pencils, crayons, and oil to represent this quirky vacation spot. He adds a decorative effect by describing the water and figures with arabesque lines which resolve into a sea of caricatures, drawn on multiple planes, representing the seaside resort as a crowded spectacle. Ensor refrains from using linear perspective and instead, draws his figures across the canvas with a restricted palette of black, blue and red, creating a dream-like space.\n"),
                                    .text(content: "In total, Ensor represents this summer playground for the middle-class in a satirical manner. He paints the tourists as caricatures. While overall the scene depicted seems to be a happy one, a sunny day where tourists are enjoying themselves, it also depicts them missing clothing, and a few of which are shown upside down with their heads between their legs- in the midst of vulgar acts. Accordingly, when viewed up close, this painting takes on a somewhat comic and most definitely unsettling effect, it runs counter to the social decorum expected of the bourgeoisie. Ensor's work offers a very clear critique of the contemporary social milieu in which he lived, anticipating movements like Dadaism.\n"),
                                    .text(content: "Black crayon, colored pencil and oil on panal - Fondation Challenges, Paris, France", fontStyle: ARVisFontStyle(size: 17, weight: .light)),
                                ], alignment: .leading),
                            ], alignment: .top, spacing: 16),
                            .divider(opacity: 0.2),
                            .text(content: "1888 - The Baths at Ostend",
                                  fontStyle: ARVisFontStyle(size: 24, weight: .bold)),
                            .hStack(elements: [
                                .image(url: "https://www.theartstory.org/images20/works/ensor_james_4.jpg?1", width: 500),
                                .vStack(elements: [
                                    .text(content: "_Masks Confronting Death_ exemplifies Ensor's usage of masks to reveal the underside of society. Although the instigation for including this prop may have come with his awareness of them in his family's shop, he was most probably attracted to their ability to both hide the specific identity of the figure depicted and simultaneously add a note of intrigue and mystery. In this case the masked figures are even scarier than the figure of Death at the center. In fact, shrouded in a white garment and tucked under a hat, Death seems almost cowering in the face of society's mockery. The appearance of masks within early modern art increased around the turn of the century, as their ability as expressive tools was understood. While Ensor's masks are more mocking in nature, primitive masks were noted in works by Gauguin, Derain, and Picasso.\n"),
                                    .text(content: "In this image Death looks out at the viewer, actually confronting her with his gaze.\n"),
                                    .text(content: "Ensor was struggling with the recent death of his father at the time the work was created and his inclusion of the motif may indicate his attempt to deal with his own mortality.\n"),
                                    .text(content: "Oil on canvas - The Museum of Modern Art, New York, New York", fontStyle: ARVisFontStyle(size: 17, weight: .light)),
                                ], alignment: .leading),
                            ], alignment: .top, spacing: 16),
                            .divider(opacity: 0.2),
                            .text(content: "c. 1910, backdated to 1896 - The Vengeance of Hop Frog",
                                  fontStyle: ARVisFontStyle(size: 24, weight: .bold)),
                            .hStack(elements: [
                                .image(url: "https://www.theartstory.org/images20/works/ensor_james_5.jpg?1", width: 500),
                                .vStack(elements: [
                                    .text(content: "This work represents Edgar Allan Poe's short story, _The Vengeance of Hop Frog_ (1845) wherein the title character, a court-jester, is the victim of social and class injustice inflicted by the king and clergy. Ensor chooses to illustrate the final scene of the story when Hop-Frog exacts his revenge on the king and clergy at a masquerade ball, stringing them up on a chandelier, above the party, and setting them on fire.\n"),
                                    .text(content: """
                                    Ensor represents a whimsical scene filled with expressive, arabesque lines and pastel colors. Furthermore, the artist uses linear perspective to create a feeling of depth, capturing the enormity of receding space by framing the scene in an arched theatre. Many of the figures are grotesque, broken up in such a way that they appear more abstract concepts of human beings than realistic representations of the same. \n
                                    """),
                                    .text(content: "Beyond offering a satirical way to highlight the dark side of political and religious figures within modern society, Ensor's representation of Poe's story suggests his frustration at receiving unfair and cruel judgment on the part of contemporary critics. In general, Ensor's dependence on literature as a source of inspiration for his work aligns him with other Symbolist artists at the time like van Gogh and Gauguin.\n"),
                                    .text(content: "Oil on canvas - Kröller-Müller Museum, Otterlo, Netherlands", fontStyle: ARVisFontStyle(size: 17, weight: .light)),
                                ], alignment: .leading),
                            ], alignment: .top, spacing: 16),
                            .divider(opacity: 0.2),
                            .text(content: "1887 - The Temptation of Saint Anthony",
                                  fontStyle: ARVisFontStyle(size: 24, weight: .bold)),
                            .hStack(elements: [
                                .image(url: "https://www.theartstory.org/images20/works/ensor_james_6.jpg?1", width: 500),
                                .vStack(elements: [
                                    .text(content: "Ensor's painting represents Anthony the Great of Egypt (c. 251-356) resisting the temptations of the devil. The monumental painting includes fifty-one sheets of paper, mounted side by side on canvas. It is assumed that the individual drawings, varied in nature but all with acidic color bound by line in a volume-defying style, were part of a book of drawings inspired by Flaubert's narrative. By representing Saint Anthony surrounded by surreal figures, including, a multi-breasted goddess, a sphinx, nude women, bourgeois men, and musical instruments the artist makes a bold statement regarding the depravity of modern society.\n"),
                                    .text(content: "Representing Saint Anthony's battle with the devil may have been Ensor's response to the temptations and ethical concerns of modern society. Ensor specialist Susan M. Canning suggests that the symbolism included in the painting, elements such as distortion, exaggeration and the macabre, would have been easily identifiable to the 19th century viewer as indicators of the degeneracy of humanity within modern society.\n"),
                                    .text(content: "Colored pencils and scraping, with graphite, charcoal, pastel and water color, selectively fixed, with cut and paste elements on fifty-one sheets of paper, mounted on canvas - The Art Institute of Chicago", fontStyle: ARVisFontStyle(size: 17, weight: .light)),
                                ], alignment: .leading),
                            ], alignment: .top, spacing: 16),
                            .divider(opacity: 0.2),
                            .text(content: "1891 - Skeletons Fighting over a Pickled Herring",
                                  fontStyle: ARVisFontStyle(size: 24, weight: .bold)),
                            .hStack(elements: [
                                .image(url: "https://www.theartstory.org/images20/works/ensor_james_7.jpg?1", width: 500),
                                .vStack(elements: [
                                    .text(content: "This painting depicts two skeletal figures fighting over a pickled herring in an amorphous landscape with pastel sky. The sky engulfs the two figures, whose dark tones make them stand out against the background - infusing the work with a lighthearted, comical nature. While the feathery brushstrokes and palette of the sky somewhat recall Impressionism, the fantastic, grotesque subject in a no-man's land actually anticipates much later takes on reality, such as found in Surrealism.\n"),
                                    .text(content: """
                                    The painting represents the two critics: Édouard Fétis and Max Sulberger. Their negative responses to Ensor's artwork drove him to portray them in multiple satirical paintings. In this particular work Ensor represents himself as a pickled herring being torn apart by their hateful criticism. The word herring in French, hareng-saur-close, if said with the proper pronunciation, apparently sounded like "art Ensor" or "Ensor's art."\n
                                    """),
                                    .text(content: """
                                    Ensor's intention here, as in many of his other works, was clear: "My favorite occupation is to make others famous, to uglify them, to enrich their ugliness." Ensor discovered an iconography of the grotesque that best enabled him to comment on the injustice and superficiality by which he was surrounded. His development of the macabre was part and parcel of his revelation of society's malaise.\n
                                    """),
                                    .text(content: "Oil on canvas - Musées Royaux des Beaux-Arts de Belgique, Brussels", fontStyle: ARVisFontStyle(size: 17, weight: .light)),
                                ], alignment: .leading),
                            ], alignment: .top, spacing: 16),
                            .divider(opacity: 0.2),
                        ], alignment: .leading)
                    ),
                    ARVisSegmentedControlItem(title: "Related Work", component: .spacer),
                ]),
                .spacer,
            ]),
        ], alignment: .leading, spacing: 4)
    }()
}
