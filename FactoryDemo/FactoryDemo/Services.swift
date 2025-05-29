//
//  Services.swift
//  Injectable2
//
//  Created by Michael Long on 5/8/22.
//

import Foundation
import FactoryMacros

public class SimpleService {
    func text() -> String{
        "Hello World!"
    }
}


public protocol MyServiceType {
    var id: UUID { get }
    func text() -> String
}

public class MyService: MyServiceType {
    public let id = UUID()
    public func text() -> String {
        "Hello World!"
    }
}


public class MockService1: MyServiceType {
    public let id = UUID()
    public func text() -> String {
        "Mock World!"
    }
}

public class MockService2: MyServiceType {
    public let id = UUID()
    public func text() -> String {
        "Mock Worlds!"
    }
}

public class MockServiceN: MyServiceType {
    public let id = UUID()
    let n: Int
    internal init(_ n: Int) {
        self.n = n
    }
    public func text() -> String {
        "Mock Number \(n)!"
    }
}

class ParameterService: MyServiceType {
    public let id = UUID()
    public let count: Int
    init(count: Int) {
        self.count = count
    }
    public func text() -> String {
        "Number is \(count)!"
    }
}

class MyConstructedService: MyServiceType {

    public let id = UUID()

    private let service: MyServiceType

    init(service: MyServiceType) {
        self.service = service
    }

    func text() -> String {
        "Well, " + service.text()
    }

}

class InjectedService: MyServiceType {

    var id = UUID()
    
    @Injected(\.simpleService) var service

    func text() -> String {
        "Well, " + service.text()
    }

}
