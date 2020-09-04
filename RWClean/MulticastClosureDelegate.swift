//
//  MulticastClosureDelegate.swift
//  RWClean
//
//  Created by Jamie Chu on 9/4/20.
//  Copyright © 2020 Razeware, LLC. All rights reserved.
//

import Foundation

typealias Success = () -> Void
typealias Failure = () -> Void

public class MulticastClosureDelegate<Success, Failure> {

    // MARK: - Callback

    class Callback {
        let success: Success
        let failure: Failure
        let queue: DispatchQueue
        
        init(success: Success, failure: Failure, queue: DispatchQueue) {
            self.success = success
            self.failure = failure
            self.queue = queue
        }
        
    }

    // MARK: - Instance Properties

    private let mapTable = NSMapTable<AnyObject, NSMutableArray>.weakToStrongObjects()
        
    // MARK: - Public API
    
    var count: Int {
        getAllCallBacks(removeAfter: false).count
    }

    // adds one Callback object for an object/delegate
    func addClosurePair(
        for objectKey: AnyObject,
        queue: DispatchQueue = .main,
        success: Success,
        failure: Failure
    ) {
        let callBack = Callback(success: success, failure: failure, queue: queue)
        let array = mapTable.object(forKey: objectKey) ?? NSMutableArray()
        array.add(callBack)
        mapTable.setObject(array, forKey: objectKey)
    }
    
    func getSuccessCallbacks(removeAfter: Bool = true) -> [(Success, DispatchQueue)] {
        getAllCallBacks(removeAfter: removeAfter).map { ($0.success, $0.queue) }
    }

    func getFailureCallbacks(removeAfter: Bool = true) -> [(Failure, DispatchQueue)] {
        getAllCallBacks(removeAfter: removeAfter).map { ($0.failure, $0.queue) }
    }

    // MARK: - Helpers
    
    // returns all callbacks. after they are retrieved, entries are removed by default unless specified otherwise
    private func getAllCallBacks(removeAfter: Bool = true) -> [Callback] {
        let objects = mapTable.keyEnumerator().allObjects as [AnyObject]
        
        let callbacks: [[Callback]] = objects.compactMap { object in
            mapTable.object(forKey: object) as? [Callback]
        }
         
        // NOTE: - temporal coupling
        
        if removeAfter {
            objects.forEach(mapTable.removeObject)
        }
        
        return callbacks.flatMap { $0 }
    }
        
}
