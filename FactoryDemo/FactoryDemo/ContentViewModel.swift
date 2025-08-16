//
//  ContentViewModel.swift
//  FactoryDemo
//
//  Created by Michael Long on 6/2/22.
//

import Foundation
import FactoryMacros
import Common
import Networking

@MainActor
class ContentViewModel: ObservableObject {

    @Injected(\.myServiceType) private var service
    @Injected(\.networkType) private var network
    @Injected(\.fatalType) private var fatal

    @Injected(\.$macroCommonType) private var macro

    private let simpleService = Container.shared.simpleService()

    @Published var name: String = "Michael"

    init() {
        print("ContentViewModel Initialized")
        testFactory()
        testResolving()
    }

    func text() -> String {
        return service.text()
    }

    var testing: String {
        let test = NSClassFromString("XCTest") != nil
        return test ? "Yes" : "No"
    }

    func testFactory() {
        let m0 = Container.shared.myServiceType()
        print("MyServiceType - \(m0.text())")
        let m1 = CycleDemo()
        print("CycleDemo - W/O ROOT \(m1.aService === m1.bService)")
        let m2 = Container.shared.cycleDemo()
        print("CycleDemo - W/ROOT \(m2.aService === m2.bService)")

        let p1 = Container.shared.promisedType()
        p1?.test()

        let f1 = Container.shared.fatalType()
        f1.test()

        let n1 = Container.shared.networkType()
        n1.test()

        macro.test()

        let processors = Container.shared.processors()
        processors.forEach { p in
            print(p.name)
        }

        DispatchQueue.main.async {
            let m9 = Container.shared.myServiceType()
            print("MyServiceType - \(m9.text())")
        }
    }

    @InjectedType private var simple: SimpleService?

    func testResolving() {
        let c = Container.shared
        let s1: MyService? = c.resolve()
        print(s1?.id as Any)
        c.register { MyService() as MyServiceType }
            .scope(.singleton)
        let s2: MyServiceType? = c.resolve()
        print(s2?.id as Any)
        let s3: MyServiceType? = c.resolve()
        print(s3?.id as Any)
        // injected
        print(simple?.text() as Any)
    }

}

internal class MyCommonType: CommonType {
    public init() {}
    public func test() {
        print("My Common Test")
    }
}
