//
//  Apollo.swift
//  SpaceySpaceChallenge
//
//  Created by Horacio Lopez on 2/17/22.
//

import Foundation
import Apollo

class Network {
    static let shared = Network()
    lazy var apollo = ApolloClient(url: URL(string: "https://api.spacex.land/graphql/")!)
}
