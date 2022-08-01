//
//  Tests_macOSImageDownloaderTest.swift
//  Tests macOS
//
//  Created by Junjie Chen on 2022/8/1.
//

import iARVis
import Kingfisher
import XCTest

class Tests_macOSImageDownloaderTest: XCTestCase {
    actor SingleTaskCache {
        var task: Task<Void, Error>?
        func cancel() {
            task?.cancel()
            task = nil
        }

        func start(task: Task<Void, Error>) {
            cancel()
            self.task = task
        }
    }

    let exampleImageURL1 = URL(string: "https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2022/default/namecard.png")!
    
    func testImageDownloaderCancellation() async {
        let imageDownloader = ImageDownloader.default
        let singleTaskCache = SingleTaskCache()

        await singleTaskCache.start(task:
            Task {
                do {
                    let _ = try await imageDownloader.download(url: exampleImageURL1)
                } catch {
                    printDebug(error.localizedDescription)
                    XCTAssert(error is CancellationError)
                }
            }
        )
        let _ = await singleTaskCache.task?.result

        await singleTaskCache.start(task:
            Task {
                do {
                    let _ = try await imageDownloader.download(url: exampleImageURL1)
                } catch {
                    printDebug(error.localizedDescription)
                    XCTAssert(error is CancellationError)
                }
            }
        )
        let _ = await singleTaskCache.task?.result

        await singleTaskCache.start(task:
            Task {
                do {
                    let _ = try await imageDownloader.download(url: exampleImageURL1)
                } catch {
                    printDebug(error.localizedDescription)
                    XCTFail("No error should be thrown.")
                }
            }
        )
        let _ = await singleTaskCache.task?.result
    }

    func testImageDownloaderCancellation2() async {
        let imageDownloader = ImageDownloader.default
        let singleTaskCache = SingleTaskCache()

        await singleTaskCache.start(task:
            Task {
                do {
                    let _ = try await imageDownloader.download(url: exampleImageURL1)
                } catch {
                    printDebug(error.localizedDescription)
                    XCTAssert(error is KingfisherError)
                }
            }
        )
        let _ = await singleTaskCache.task?.result

        try! await Task.sleep(nanoseconds: 10_000_000)
        await singleTaskCache.start(task:
            Task {
                do {
                    let _ = try await imageDownloader.download(url: exampleImageURL1)
                } catch {
                    printDebug(error.localizedDescription)
                    XCTAssert(error is KingfisherError)
                }
            }
        )
        let _ = await singleTaskCache.task?.result

        try! await Task.sleep(nanoseconds: 10_000_000)
        await singleTaskCache.start(task:
            Task {
                do {
                    let _ = try await imageDownloader.download(url: exampleImageURL1)
                } catch {
                    printDebug(error.localizedDescription)
                    XCTFail("No error should be thrown.")
                }
            }
        )

        let _ = await singleTaskCache.task?.result
    }
}
