//
//  URLHandler.swift
//  URLProxy
//
//  Created by ibbi on 5/27/23.
//

import Foundation
import UIKit

public class URLHandler {
    public init() {}

    public func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
