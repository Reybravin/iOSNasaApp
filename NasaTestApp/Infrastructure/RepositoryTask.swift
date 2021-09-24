//
//  RepositoryTask.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 26.08.2021.
//

import Foundation

struct RepositoryTask: Cancellable {
    
    let networkTask: NetworkCancellable?
    
    func cancel() {
        networkTask?.cancel()
    }
    
}
