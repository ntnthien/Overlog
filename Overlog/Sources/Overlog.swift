//
//  Overlog.swift
//
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// An Overlog abstraction
public final class Overlog {
    
    /// Overlog configuration.
    public let configuration = Configuration()
    
    /// A Boolean value that determines whether the overlog floating button is hidden.
    /// - Discussion:
    ///     - Setting the value of this property to true hides the floating button and setting it to false shows the it. The default value is false.
    public var isHidden: Bool = false {
        didSet {
            /// Extract the root view controller and configure the floating button
            guard let rootViewController = flowController?.rootViewController else { return }
            rootViewController.overlayView.floatingButton.isHidden = isHidden
        }
    }

    /// Overlay's root flow controller
    fileprivate var flowController: OverlayFlowController?

    /// Initialzer
    internal init() {
        flowController = nil
    }

    /// Show overlay
    ///
    /// - Parameters:
    ///   - window: application's main window
    ///   - viewController: the main window's root view controller
    public func show(in window: UIWindow, rootViewController viewController: UIViewController) {
        flowController = OverlayFlowController(with: viewController, window: window, configuration: configuration)

        /// Extract the root view controller and configure the events
        guard let rootViewController = flowController?.rootViewController else { return }
        rootViewController.didPerformShakeEvent = didPerformShake(event:)
    }

    /// Enable network debugging
    ///
    /// - Parameter configuration: URLSessionConfiguration to be used
    public func enableNetworkDebugging(inConfiguration configuration: URLSessionConfiguration) {
        NetworkMonitor.shared.watch(on: configuration)
    }

    /// Shared instance
    public static let shared = Overlog()

    /// Presents floating button
    /// - Discussion:
    ///     - This methods sets `isHidden` to `false` on `OverlayView`'s `floatingButton` only
    public func present() {
        /// Extract the root view controller and configure the floating button
        guard let rootViewController = flowController?.rootViewController else { return }
        rootViewController.overlayView.floatingButton.isHidden = false
    }
    
    /// Shake event
    ///
    /// - Parameter overlayView: overlayView description
    private func didPerformShake(event _: UIEvent?) {
        if configuration.toggleOnShakeGesture {
            /// Extract the root view controller and configure the floating button
            guard let rootViewController = flowController?.rootViewController else { return }
            let overlayView = rootViewController.overlayView
            overlayView.floatingButton.isHidden = !overlayView.floatingButton.isHidden
        }
    }
    
}
