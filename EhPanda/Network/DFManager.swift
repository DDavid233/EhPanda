//
//  DFManager.swift
//  EhPanda
//
//  Created by 荒木辰造 on R 3/04/07.
//

import Foundation

class DFManager: NSObject, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let trust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: trust))
        }
    }
}
