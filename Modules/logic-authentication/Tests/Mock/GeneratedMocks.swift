import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication






 class MockAnalyticsConfig: AnalyticsConfig, Cuckoo.ProtocolMock {
    
     typealias MocksType = AnalyticsConfig
    
     typealias Stubbing = __StubbingProxy_AnalyticsConfig
     typealias Verification = __VerificationProxy_AnalyticsConfig

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AnalyticsConfig?

     func enableDefaultImplementation(_ stub: AnalyticsConfig) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     var analyticsProviders: [String: AnalyticsProvider] {
        get {
            return cuckoo_manager.getter("analyticsProviders",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.analyticsProviders)
        }
        
    }
    
    

    

    

     struct __StubbingProxy_AnalyticsConfig: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var analyticsProviders: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAnalyticsConfig, [String: AnalyticsProvider]> {
            return .init(manager: cuckoo_manager, name: "analyticsProviders")
        }
        
        
        
    }

     struct __VerificationProxy_AnalyticsConfig: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var analyticsProviders: Cuckoo.VerifyReadOnlyProperty<[String: AnalyticsProvider]> {
            return .init(manager: cuckoo_manager, name: "analyticsProviders", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


 class AnalyticsConfigStub: AnalyticsConfig {
    
    
    
    
     var analyticsProviders: [String: AnalyticsProvider] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: AnalyticsProvider]).self)
        }
        
    }
    
    

    

    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication






public class MockAnalyticsControllerType: AnalyticsControllerType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = AnalyticsControllerType
    
    public typealias Stubbing = __StubbingProxy_AnalyticsControllerType
    public typealias Verification = __VerificationProxy_AnalyticsControllerType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AnalyticsControllerType?

    public func enableDefaultImplementation(_ stub: AnalyticsControllerType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func initialize()  {
        
    return cuckoo_manager.call(
    """
    initialize()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.initialize())
        
    }
    
    
    
    
    
    public func logScreen(screen: String, arguments: [String: String])  {
        
    return cuckoo_manager.call(
    """
    logScreen(screen: String, arguments: [String: String])
    """,
            parameters: (screen, arguments),
            escapingParameters: (screen, arguments),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.logScreen(screen: screen, arguments: arguments))
        
    }
    
    
    
    
    
    public func logEvent(event: String, arguments: [String: String])  {
        
    return cuckoo_manager.call(
    """
    logEvent(event: String, arguments: [String: String])
    """,
            parameters: (event, arguments),
            escapingParameters: (event, arguments),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.logEvent(event: event, arguments: arguments))
        
    }
    
    

    public struct __StubbingProxy_AnalyticsControllerType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func initialize() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsControllerType.self, method:
    """
    initialize()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func logScreen<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(screen: M1, arguments: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, [String: String])> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: screen) { $0.0 }, wrap(matchable: arguments) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsControllerType.self, method:
    """
    logScreen(screen: String, arguments: [String: String])
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func logEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(event: M1, arguments: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, [String: String])> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: event) { $0.0 }, wrap(matchable: arguments) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsControllerType.self, method:
    """
    logEvent(event: String, arguments: [String: String])
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_AnalyticsControllerType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func initialize() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    initialize()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func logScreen<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(screen: M1, arguments: M2) -> Cuckoo.__DoNotUse<(String, [String: String]), Void> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: screen) { $0.0 }, wrap(matchable: arguments) { $0.1 }]
            return cuckoo_manager.verify(
    """
    logScreen(screen: String, arguments: [String: String])
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func logEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(event: M1, arguments: M2) -> Cuckoo.__DoNotUse<(String, [String: String]), Void> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: event) { $0.0 }, wrap(matchable: arguments) { $0.1 }]
            return cuckoo_manager.verify(
    """
    logEvent(event: String, arguments: [String: String])
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class AnalyticsControllerTypeStub: AnalyticsControllerType {
    

    

    
    
    
    
    public func initialize()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func logScreen(screen: String, arguments: [String: String])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func logEvent(event: String, arguments: [String: String])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation






 class MockAnalyticsConfigProviderType: AnalyticsConfigProviderType, Cuckoo.ProtocolMock {
    
     typealias MocksType = AnalyticsConfigProviderType
    
     typealias Stubbing = __StubbingProxy_AnalyticsConfigProviderType
     typealias Verification = __VerificationProxy_AnalyticsConfigProviderType

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AnalyticsConfigProviderType?

     func enableDefaultImplementation(_ stub: AnalyticsConfigProviderType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func getConfig() -> AnalyticsConfig? {
        
    return cuckoo_manager.call(
    """
    getConfig() -> AnalyticsConfig?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getConfig())
        
    }
    
    

     struct __StubbingProxy_AnalyticsConfigProviderType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getConfig() -> Cuckoo.ProtocolStubFunction<(), AnalyticsConfig?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsConfigProviderType.self, method:
    """
    getConfig() -> AnalyticsConfig?
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_AnalyticsConfigProviderType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getConfig() -> Cuckoo.__DoNotUse<(), AnalyticsConfig?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getConfig() -> AnalyticsConfig?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class AnalyticsConfigProviderTypeStub: AnalyticsConfigProviderType {
    

    

    
    
    
    
     func getConfig() -> AnalyticsConfig?  {
        return DefaultValueRegistry.defaultValue(for: (AnalyticsConfig?).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication






 class MockAnalyticsProvider: AnalyticsProvider, Cuckoo.ProtocolMock {
    
     typealias MocksType = AnalyticsProvider
    
     typealias Stubbing = __StubbingProxy_AnalyticsProvider
     typealias Verification = __VerificationProxy_AnalyticsProvider

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AnalyticsProvider?

     func enableDefaultImplementation(_ stub: AnalyticsProvider) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func initialize(key: String)  {
        
    return cuckoo_manager.call(
    """
    initialize(key: String)
    """,
            parameters: (key),
            escapingParameters: (key),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.initialize(key: key))
        
    }
    
    
    
    
    
     func logScreen(screen: String, arguments: [String: String])  {
        
    return cuckoo_manager.call(
    """
    logScreen(screen: String, arguments: [String: String])
    """,
            parameters: (screen, arguments),
            escapingParameters: (screen, arguments),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.logScreen(screen: screen, arguments: arguments))
        
    }
    
    
    
    
    
     func logEvent(event: String, arguments: [String: String])  {
        
    return cuckoo_manager.call(
    """
    logEvent(event: String, arguments: [String: String])
    """,
            parameters: (event, arguments),
            escapingParameters: (event, arguments),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.logEvent(event: event, arguments: arguments))
        
    }
    
    

     struct __StubbingProxy_AnalyticsProvider: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func initialize<M1: Cuckoo.Matchable>(key: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: key) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsProvider.self, method:
    """
    initialize(key: String)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func logScreen<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(screen: M1, arguments: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, [String: String])> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: screen) { $0.0 }, wrap(matchable: arguments) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsProvider.self, method:
    """
    logScreen(screen: String, arguments: [String: String])
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func logEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(event: M1, arguments: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, [String: String])> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: event) { $0.0 }, wrap(matchable: arguments) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsProvider.self, method:
    """
    logEvent(event: String, arguments: [String: String])
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_AnalyticsProvider: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func initialize<M1: Cuckoo.Matchable>(key: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: key) { $0 }]
            return cuckoo_manager.verify(
    """
    initialize(key: String)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func logScreen<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(screen: M1, arguments: M2) -> Cuckoo.__DoNotUse<(String, [String: String]), Void> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: screen) { $0.0 }, wrap(matchable: arguments) { $0.1 }]
            return cuckoo_manager.verify(
    """
    logScreen(screen: String, arguments: [String: String])
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func logEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(event: M1, arguments: M2) -> Cuckoo.__DoNotUse<(String, [String: String]), Void> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: event) { $0.0 }, wrap(matchable: arguments) { $0.1 }]
            return cuckoo_manager.verify(
    """
    logEvent(event: String, arguments: [String: String])
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class AnalyticsProviderStub: AnalyticsProvider {
    

    

    
    
    
    
     func initialize(key: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     func logScreen(screen: String, arguments: [String: String])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     func logEvent(event: String, arguments: [String: String])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication






 class MockPinStorageConfig: PinStorageConfig, Cuckoo.ProtocolMock {
    
     typealias MocksType = PinStorageConfig
    
     typealias Stubbing = __StubbingProxy_PinStorageConfig
     typealias Verification = __VerificationProxy_PinStorageConfig

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: PinStorageConfig?

     func enableDefaultImplementation(_ stub: PinStorageConfig) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     var storageProvider: PinStorageProvider {
        get {
            return cuckoo_manager.getter("storageProvider",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.storageProvider)
        }
        
    }
    
    

    

    

     struct __StubbingProxy_PinStorageConfig: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var storageProvider: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockPinStorageConfig, PinStorageProvider> {
            return .init(manager: cuckoo_manager, name: "storageProvider")
        }
        
        
        
    }

     struct __VerificationProxy_PinStorageConfig: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var storageProvider: Cuckoo.VerifyReadOnlyProperty<PinStorageProvider> {
            return .init(manager: cuckoo_manager, name: "storageProvider", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


 class PinStorageConfigStub: PinStorageConfig {
    
    
    
    
     var storageProvider: PinStorageProvider {
        get {
            return DefaultValueRegistry.defaultValue(for: (PinStorageProvider).self)
        }
        
    }
    
    

    

    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication






public class MockPinStorageControllerType: PinStorageControllerType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = PinStorageControllerType
    
    public typealias Stubbing = __StubbingProxy_PinStorageControllerType
    public typealias Verification = __VerificationProxy_PinStorageControllerType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: PinStorageControllerType?

    public func enableDefaultImplementation(_ stub: PinStorageControllerType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func retrievePin() -> String? {
        
    return cuckoo_manager.call(
    """
    retrievePin() -> String?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.retrievePin())
        
    }
    
    
    
    
    
    public func setPin(with pin: String)  {
        
    return cuckoo_manager.call(
    """
    setPin(with: String)
    """,
            parameters: (pin),
            escapingParameters: (pin),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setPin(with: pin))
        
    }
    
    
    
    
    
    public func isPinValid(with pin: String) -> Bool {
        
    return cuckoo_manager.call(
    """
    isPinValid(with: String) -> Bool
    """,
            parameters: (pin),
            escapingParameters: (pin),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isPinValid(with: pin))
        
    }
    
    

    public struct __StubbingProxy_PinStorageControllerType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func retrievePin() -> Cuckoo.ProtocolStubFunction<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageControllerType.self, method:
    """
    retrievePin() -> String?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setPin<M1: Cuckoo.Matchable>(with pin: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageControllerType.self, method:
    """
    setPin(with: String)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isPinValid<M1: Cuckoo.Matchable>(with pin: M1) -> Cuckoo.ProtocolStubFunction<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageControllerType.self, method:
    """
    isPinValid(with: String) -> Bool
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_PinStorageControllerType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func retrievePin() -> Cuckoo.__DoNotUse<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    retrievePin() -> String?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setPin<M1: Cuckoo.Matchable>(with pin: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return cuckoo_manager.verify(
    """
    setPin(with: String)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isPinValid<M1: Cuckoo.Matchable>(with pin: M1) -> Cuckoo.__DoNotUse<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return cuckoo_manager.verify(
    """
    isPinValid(with: String) -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class PinStorageControllerTypeStub: PinStorageControllerType {
    

    

    
    
    
    
    public func retrievePin() -> String?  {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    
    
    
    
    public func setPin(with pin: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func isPinValid(with pin: String) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Combine
import Foundation
import LocalAuthentication
import SwiftUI
import logic_business






public class MockSystemBiometricsControllerType: SystemBiometricsControllerType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = SystemBiometricsControllerType
    
    public typealias Stubbing = __StubbingProxy_SystemBiometricsControllerType
    public typealias Verification = __VerificationProxy_SystemBiometricsControllerType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: SystemBiometricsControllerType?

    public func enableDefaultImplementation(_ stub: SystemBiometricsControllerType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var biometryType: LABiometryType {
        get {
            return cuckoo_manager.getter("biometryType",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.biometryType)
        }
        
    }
    
    

    

    
    
    
    
    public func canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometricsError> {
        
    return cuckoo_manager.call(
    """
    canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometricsError>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.canEvaluateForBiometrics())
        
    }
    
    
    
    
    
    public func evaluateBiometrics() -> AnyPublisher<Void, SystemBiometricsError> {
        
    return cuckoo_manager.call(
    """
    evaluateBiometrics() -> AnyPublisher<Void, SystemBiometricsError>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.evaluateBiometrics())
        
    }
    
    
    
    
    
    public func requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometricsError> {
        
    return cuckoo_manager.call(
    """
    requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometricsError>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.requestBiometricUnlock())
        
    }
    
    

    public struct __StubbingProxy_SystemBiometricsControllerType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var biometryType: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSystemBiometricsControllerType, LABiometryType> {
            return .init(manager: cuckoo_manager, name: "biometryType")
        }
        
        
        
        
        
        func canEvaluateForBiometrics() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<Bool, SystemBiometricsError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometricsControllerType.self, method:
    """
    canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometricsError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func evaluateBiometrics() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<Void, SystemBiometricsError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometricsControllerType.self, method:
    """
    evaluateBiometrics() -> AnyPublisher<Void, SystemBiometricsError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func requestBiometricUnlock() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<Void, SystemBiometricsError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometricsControllerType.self, method:
    """
    requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometricsError>
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_SystemBiometricsControllerType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var biometryType: Cuckoo.VerifyReadOnlyProperty<LABiometryType> {
            return .init(manager: cuckoo_manager, name: "biometryType", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func canEvaluateForBiometrics() -> Cuckoo.__DoNotUse<(), AnyPublisher<Bool, SystemBiometricsError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometricsError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func evaluateBiometrics() -> Cuckoo.__DoNotUse<(), AnyPublisher<Void, SystemBiometricsError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    evaluateBiometrics() -> AnyPublisher<Void, SystemBiometricsError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func requestBiometricUnlock() -> Cuckoo.__DoNotUse<(), AnyPublisher<Void, SystemBiometricsError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometricsError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class SystemBiometricsControllerTypeStub: SystemBiometricsControllerType {
    
    
    
    
    public var biometryType: LABiometryType {
        get {
            return DefaultValueRegistry.defaultValue(for: (LABiometryType).self)
        }
        
    }
    
    

    

    
    
    
    
    public func canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometricsError>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Bool, SystemBiometricsError>).self)
    }
    
    
    
    
    
    public func evaluateBiometrics() -> AnyPublisher<Void, SystemBiometricsError>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Void, SystemBiometricsError>).self)
    }
    
    
    
    
    
    public func requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometricsError>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Void, SystemBiometricsError>).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Combine
import Foundation
import LocalAuthentication
import SwiftUI
import UIKit
import logic_resources






public class MockSystemBiometricsInteractorType: SystemBiometricsInteractorType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = SystemBiometricsInteractorType
    
    public typealias Stubbing = __StubbingProxy_SystemBiometricsInteractorType
    public typealias Verification = __VerificationProxy_SystemBiometricsInteractorType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: SystemBiometricsInteractorType?

    public func enableDefaultImplementation(_ stub: SystemBiometricsInteractorType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var biometricsImage: Image? {
        get {
            return cuckoo_manager.getter("biometricsImage",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.biometricsImage)
        }
        
    }
    
    
    
    
    
    public var currentBiometricsMethod: String {
        get {
            return cuckoo_manager.getter("currentBiometricsMethod",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.currentBiometricsMethod)
        }
        
    }
    
    
    
    
    
    public var biometryType: LABiometryType {
        get {
            return cuckoo_manager.getter("biometryType",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.biometryType)
        }
        
    }
    
    

    

    
    
    
    
    public func authenticate() -> AnyPublisher<BiometricsState, Never> {
        
    return cuckoo_manager.call(
    """
    authenticate() -> AnyPublisher<BiometricsState, Never>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.authenticate())
        
    }
    
    
    
    
    
    public func openSettingsURL(action: @escaping () -> Void)  {
        
    return cuckoo_manager.call(
    """
    openSettingsURL(action: @escaping () -> Void)
    """,
            parameters: (action),
            escapingParameters: (action),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.openSettingsURL(action: action))
        
    }
    
    

    public struct __StubbingProxy_SystemBiometricsInteractorType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var biometricsImage: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSystemBiometricsInteractorType, Image?> {
            return .init(manager: cuckoo_manager, name: "biometricsImage")
        }
        
        
        
        
        var currentBiometricsMethod: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSystemBiometricsInteractorType, String> {
            return .init(manager: cuckoo_manager, name: "currentBiometricsMethod")
        }
        
        
        
        
        var biometryType: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSystemBiometricsInteractorType, LABiometryType> {
            return .init(manager: cuckoo_manager, name: "biometryType")
        }
        
        
        
        
        
        func authenticate() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<BiometricsState, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometricsInteractorType.self, method:
    """
    authenticate() -> AnyPublisher<BiometricsState, Never>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openSettingsURL<M1: Cuckoo.Matchable>(action: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(() -> Void)> where M1.MatchedType == () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometricsInteractorType.self, method:
    """
    openSettingsURL(action: @escaping () -> Void)
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_SystemBiometricsInteractorType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var biometricsImage: Cuckoo.VerifyReadOnlyProperty<Image?> {
            return .init(manager: cuckoo_manager, name: "biometricsImage", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var currentBiometricsMethod: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "currentBiometricsMethod", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var biometryType: Cuckoo.VerifyReadOnlyProperty<LABiometryType> {
            return .init(manager: cuckoo_manager, name: "biometryType", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func authenticate() -> Cuckoo.__DoNotUse<(), AnyPublisher<BiometricsState, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    authenticate() -> AnyPublisher<BiometricsState, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openSettingsURL<M1: Cuckoo.Matchable>(action: M1) -> Cuckoo.__DoNotUse<(() -> Void), Void> where M1.MatchedType == () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
            return cuckoo_manager.verify(
    """
    openSettingsURL(action: @escaping () -> Void)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class SystemBiometricsInteractorTypeStub: SystemBiometricsInteractorType {
    
    
    
    
    public var biometricsImage: Image? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Image?).self)
        }
        
    }
    
    
    
    
    
    public var currentBiometricsMethod: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
    
    
    
    public var biometryType: LABiometryType {
        get {
            return DefaultValueRegistry.defaultValue(for: (LABiometryType).self)
        }
        
    }
    
    

    

    
    
    
    
    public func authenticate() -> AnyPublisher<BiometricsState, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<BiometricsState, Never>).self)
    }
    
    
    
    
    
    public func openSettingsURL(action: @escaping () -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication






 class MockPinStorageConfigProviderType: PinStorageConfigProviderType, Cuckoo.ProtocolMock {
    
     typealias MocksType = PinStorageConfigProviderType
    
     typealias Stubbing = __StubbingProxy_PinStorageConfigProviderType
     typealias Verification = __VerificationProxy_PinStorageConfigProviderType

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: PinStorageConfigProviderType?

     func enableDefaultImplementation(_ stub: PinStorageConfigProviderType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func getConfig() -> PinStorageConfig {
        
    return cuckoo_manager.call(
    """
    getConfig() -> PinStorageConfig
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getConfig())
        
    }
    
    

     struct __StubbingProxy_PinStorageConfigProviderType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getConfig() -> Cuckoo.ProtocolStubFunction<(), PinStorageConfig> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageConfigProviderType.self, method:
    """
    getConfig() -> PinStorageConfig
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_PinStorageConfigProviderType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getConfig() -> Cuckoo.__DoNotUse<(), PinStorageConfig> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getConfig() -> PinStorageConfig
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class PinStorageConfigProviderTypeStub: PinStorageConfigProviderType {
    

    

    
    
    
    
     func getConfig() -> PinStorageConfig  {
        return DefaultValueRegistry.defaultValue(for: (PinStorageConfig).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication






 class MockPinStorageProvider: PinStorageProvider, Cuckoo.ProtocolMock {
    
     typealias MocksType = PinStorageProvider
    
     typealias Stubbing = __StubbingProxy_PinStorageProvider
     typealias Verification = __VerificationProxy_PinStorageProvider

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: PinStorageProvider?

     func enableDefaultImplementation(_ stub: PinStorageProvider) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func retrievePin() -> String? {
        
    return cuckoo_manager.call(
    """
    retrievePin() -> String?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.retrievePin())
        
    }
    
    
    
    
    
     func setPin(with pin: String)  {
        
    return cuckoo_manager.call(
    """
    setPin(with: String)
    """,
            parameters: (pin),
            escapingParameters: (pin),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setPin(with: pin))
        
    }
    
    
    
    
    
     func isPinValid(with pin: String) -> Bool {
        
    return cuckoo_manager.call(
    """
    isPinValid(with: String) -> Bool
    """,
            parameters: (pin),
            escapingParameters: (pin),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isPinValid(with: pin))
        
    }
    
    

     struct __StubbingProxy_PinStorageProvider: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func retrievePin() -> Cuckoo.ProtocolStubFunction<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageProvider.self, method:
    """
    retrievePin() -> String?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setPin<M1: Cuckoo.Matchable>(with pin: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageProvider.self, method:
    """
    setPin(with: String)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isPinValid<M1: Cuckoo.Matchable>(with pin: M1) -> Cuckoo.ProtocolStubFunction<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageProvider.self, method:
    """
    isPinValid(with: String) -> Bool
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_PinStorageProvider: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func retrievePin() -> Cuckoo.__DoNotUse<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    retrievePin() -> String?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setPin<M1: Cuckoo.Matchable>(with pin: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return cuckoo_manager.verify(
    """
    setPin(with: String)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isPinValid<M1: Cuckoo.Matchable>(with pin: M1) -> Cuckoo.__DoNotUse<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return cuckoo_manager.verify(
    """
    isPinValid(with: String) -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class PinStorageProviderStub: PinStorageProvider {
    

    

    
    
    
    
     func retrievePin() -> String?  {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    
    
    
    
     func setPin(with pin: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     func isPinValid(with pin: String) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import logic_business

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation






public class MockConfigLogic: ConfigLogic, Cuckoo.ProtocolMock {
    
    public typealias MocksType = ConfigLogic
    
    public typealias Stubbing = __StubbingProxy_ConfigLogic
    public typealias Verification = __VerificationProxy_ConfigLogic

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: ConfigLogic?

    public func enableDefaultImplementation(_ stub: ConfigLogic) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var walletHostUrl: String {
        get {
            return cuckoo_manager.getter("walletHostUrl",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.walletHostUrl)
        }
        
    }
    
    
    
    
    
    public var appBuildType: AppBuildType {
        get {
            return cuckoo_manager.getter("appBuildType",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.appBuildType)
        }
        
    }
    
    
    
    
    
    public var appVersion: String {
        get {
            return cuckoo_manager.getter("appVersion",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.appVersion)
        }
        
    }
    
    
    
    
    
    public var verifierConfig: VerifierConfig {
        get {
            return cuckoo_manager.getter("verifierConfig",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.verifierConfig)
        }
        
    }
    
    
    
    
    
    public var vciConfig: VciConfig {
        get {
            return cuckoo_manager.getter("vciConfig",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.vciConfig)
        }
        
    }
    
    
    
    
    
    public var proxmityConfig: ProximityConfig {
        get {
            return cuckoo_manager.getter("proxmityConfig",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.proxmityConfig)
        }
        
    }
    
    
    
    
    
    public var userAuthenticationRequired: Bool {
        get {
            return cuckoo_manager.getter("userAuthenticationRequired",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.userAuthenticationRequired)
        }
        
    }
    
    

    

    

    public struct __StubbingProxy_ConfigLogic: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var walletHostUrl: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic, String> {
            return .init(manager: cuckoo_manager, name: "walletHostUrl")
        }
        
        
        
        
        var appBuildType: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic, AppBuildType> {
            return .init(manager: cuckoo_manager, name: "appBuildType")
        }
        
        
        
        
        var appVersion: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic, String> {
            return .init(manager: cuckoo_manager, name: "appVersion")
        }
        
        
        
        
        var verifierConfig: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic, VerifierConfig> {
            return .init(manager: cuckoo_manager, name: "verifierConfig")
        }
        
        
        
        
        var vciConfig: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic, VciConfig> {
            return .init(manager: cuckoo_manager, name: "vciConfig")
        }
        
        
        
        
        var proxmityConfig: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic, ProximityConfig> {
            return .init(manager: cuckoo_manager, name: "proxmityConfig")
        }
        
        
        
        
        var userAuthenticationRequired: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic, Bool> {
            return .init(manager: cuckoo_manager, name: "userAuthenticationRequired")
        }
        
        
        
    }

    public struct __VerificationProxy_ConfigLogic: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var walletHostUrl: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "walletHostUrl", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var appBuildType: Cuckoo.VerifyReadOnlyProperty<AppBuildType> {
            return .init(manager: cuckoo_manager, name: "appBuildType", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var appVersion: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "appVersion", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var verifierConfig: Cuckoo.VerifyReadOnlyProperty<VerifierConfig> {
            return .init(manager: cuckoo_manager, name: "verifierConfig", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var vciConfig: Cuckoo.VerifyReadOnlyProperty<VciConfig> {
            return .init(manager: cuckoo_manager, name: "vciConfig", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var proxmityConfig: Cuckoo.VerifyReadOnlyProperty<ProximityConfig> {
            return .init(manager: cuckoo_manager, name: "proxmityConfig", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var userAuthenticationRequired: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "userAuthenticationRequired", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


public class ConfigLogicStub: ConfigLogic {
    
    
    
    
    public var walletHostUrl: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
    
    
    
    public var appBuildType: AppBuildType {
        get {
            return DefaultValueRegistry.defaultValue(for: (AppBuildType).self)
        }
        
    }
    
    
    
    
    
    public var appVersion: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
    
    
    
    public var verifierConfig: VerifierConfig {
        get {
            return DefaultValueRegistry.defaultValue(for: (VerifierConfig).self)
        }
        
    }
    
    
    
    
    
    public var vciConfig: VciConfig {
        get {
            return DefaultValueRegistry.defaultValue(for: (VciConfig).self)
        }
        
    }
    
    
    
    
    
    public var proxmityConfig: ProximityConfig {
        get {
            return DefaultValueRegistry.defaultValue(for: (ProximityConfig).self)
        }
        
    }
    
    
    
    
    
    public var userAuthenticationRequired: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    

    

    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation






public class MockConfigSecurityLogic: ConfigSecurityLogic, Cuckoo.ProtocolMock {
    
    public typealias MocksType = ConfigSecurityLogic
    
    public typealias Stubbing = __StubbingProxy_ConfigSecurityLogic
    public typealias Verification = __VerificationProxy_ConfigSecurityLogic

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: ConfigSecurityLogic?

    public func enableDefaultImplementation(_ stub: ConfigSecurityLogic) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var blockRootAccess: Bool {
        get {
            return cuckoo_manager.getter("blockRootAccess",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.blockRootAccess)
        }
        
    }
    
    
    
    
    
    public var blockEmulator: Bool {
        get {
            return cuckoo_manager.getter("blockEmulator",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.blockEmulator)
        }
        
    }
    
    
    
    
    
    public var blockDebugMode: Bool {
        get {
            return cuckoo_manager.getter("blockDebugMode",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.blockDebugMode)
        }
        
    }
    
    
    
    
    
    public var blockReverseEngineering: Bool {
        get {
            return cuckoo_manager.getter("blockReverseEngineering",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.blockReverseEngineering)
        }
        
    }
    
    
    
    
    
    public var blockScreenCapture: Bool {
        get {
            return cuckoo_manager.getter("blockScreenCapture",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.blockScreenCapture)
        }
        
    }
    
    
    
    
    
    public var blockUnsecureWebContent: Bool {
        get {
            return cuckoo_manager.getter("blockUnsecureWebContent",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.blockUnsecureWebContent)
        }
        
    }
    
    
    
    
    
    public var bindToDevice: Bool {
        get {
            return cuckoo_manager.getter("bindToDevice",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.bindToDevice)
        }
        
    }
    
    
    
    
    
    public var profileInformation: (bundleId: String, signature: String)? {
        get {
            return cuckoo_manager.getter("profileInformation",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.profileInformation)
        }
        
    }
    
    
    
    
    
    public var useNetworkLogger: Bool {
        get {
            return cuckoo_manager.getter("useNetworkLogger",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.useNetworkLogger)
        }
        
    }
    
    
    
    
    
    public var networkLoggerExclusionList: [String] {
        get {
            return cuckoo_manager.getter("networkLoggerExclusionList",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.networkLoggerExclusionList)
        }
        
    }
    
    

    

    

    public struct __StubbingProxy_ConfigSecurityLogic: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var blockRootAccess: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, Bool> {
            return .init(manager: cuckoo_manager, name: "blockRootAccess")
        }
        
        
        
        
        var blockEmulator: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, Bool> {
            return .init(manager: cuckoo_manager, name: "blockEmulator")
        }
        
        
        
        
        var blockDebugMode: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, Bool> {
            return .init(manager: cuckoo_manager, name: "blockDebugMode")
        }
        
        
        
        
        var blockReverseEngineering: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, Bool> {
            return .init(manager: cuckoo_manager, name: "blockReverseEngineering")
        }
        
        
        
        
        var blockScreenCapture: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, Bool> {
            return .init(manager: cuckoo_manager, name: "blockScreenCapture")
        }
        
        
        
        
        var blockUnsecureWebContent: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, Bool> {
            return .init(manager: cuckoo_manager, name: "blockUnsecureWebContent")
        }
        
        
        
        
        var bindToDevice: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, Bool> {
            return .init(manager: cuckoo_manager, name: "bindToDevice")
        }
        
        
        
        
        var profileInformation: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, (bundleId: String, signature: String)?> {
            return .init(manager: cuckoo_manager, name: "profileInformation")
        }
        
        
        
        
        var useNetworkLogger: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, Bool> {
            return .init(manager: cuckoo_manager, name: "useNetworkLogger")
        }
        
        
        
        
        var networkLoggerExclusionList: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, [String]> {
            return .init(manager: cuckoo_manager, name: "networkLoggerExclusionList")
        }
        
        
        
    }

    public struct __VerificationProxy_ConfigSecurityLogic: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var blockRootAccess: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "blockRootAccess", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var blockEmulator: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "blockEmulator", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var blockDebugMode: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "blockDebugMode", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var blockReverseEngineering: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "blockReverseEngineering", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var blockScreenCapture: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "blockScreenCapture", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var blockUnsecureWebContent: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "blockUnsecureWebContent", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var bindToDevice: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "bindToDevice", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var profileInformation: Cuckoo.VerifyReadOnlyProperty<(bundleId: String, signature: String)?> {
            return .init(manager: cuckoo_manager, name: "profileInformation", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var useNetworkLogger: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "useNetworkLogger", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var networkLoggerExclusionList: Cuckoo.VerifyReadOnlyProperty<[String]> {
            return .init(manager: cuckoo_manager, name: "networkLoggerExclusionList", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


public class ConfigSecurityLogicStub: ConfigSecurityLogic {
    
    
    
    
    public var blockRootAccess: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
    public var blockEmulator: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
    public var blockDebugMode: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
    public var blockReverseEngineering: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
    public var blockScreenCapture: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
    public var blockUnsecureWebContent: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
    public var bindToDevice: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
    public var profileInformation: (bundleId: String, signature: String)? {
        get {
            return DefaultValueRegistry.defaultValue(for: ((bundleId: String, signature: String)?).self)
        }
        
    }
    
    
    
    
    
    public var useNetworkLogger: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
    public var networkLoggerExclusionList: [String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String]).self)
        }
        
    }
    
    

    

    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation
import KeychainAccess






public class MockKeychainWrapper: KeychainWrapper, Cuckoo.ProtocolMock {
    
    public typealias MocksType = KeychainWrapper
    
    public typealias Stubbing = __StubbingProxy_KeychainWrapper
    public typealias Verification = __VerificationProxy_KeychainWrapper

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: KeychainWrapper?

    public func enableDefaultImplementation(_ stub: KeychainWrapper) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var value: String {
        get {
            return cuckoo_manager.getter("value",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.value)
        }
        
    }
    
    

    

    

    public struct __StubbingProxy_KeychainWrapper: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var value: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockKeychainWrapper, String> {
            return .init(manager: cuckoo_manager, name: "value")
        }
        
        
        
    }

    public struct __VerificationProxy_KeychainWrapper: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var value: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "value", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


public class KeychainWrapperStub: KeychainWrapper {
    
    
    
    
    public var value: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    

    

    
}










public class MockKeyChainControllerType: KeyChainControllerType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = KeyChainControllerType
    
    public typealias Stubbing = __StubbingProxy_KeyChainControllerType
    public typealias Verification = __VerificationProxy_KeyChainControllerType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: KeyChainControllerType?

    public func enableDefaultImplementation(_ stub: KeyChainControllerType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func storeValue(key: KeychainWrapper, value: String)  {
        
    return cuckoo_manager.call(
    """
    storeValue(key: KeychainWrapper, value: String)
    """,
            parameters: (key, value),
            escapingParameters: (key, value),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.storeValue(key: key, value: value))
        
    }
    
    
    
    
    
    public func getValue(key: KeychainWrapper) -> String? {
        
    return cuckoo_manager.call(
    """
    getValue(key: KeychainWrapper) -> String?
    """,
            parameters: (key),
            escapingParameters: (key),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getValue(key: key))
        
    }
    
    
    
    
    
    public func removeObject(key: KeychainWrapper)  {
        
    return cuckoo_manager.call(
    """
    removeObject(key: KeychainWrapper)
    """,
            parameters: (key),
            escapingParameters: (key),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.removeObject(key: key))
        
    }
    
    
    
    
    
    public func validateKeyChainBiometry() throws {
        
    return try cuckoo_manager.callThrows(
    """
    validateKeyChainBiometry() throws
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.validateKeyChainBiometry())
        
    }
    
    
    
    
    
    public func clearKeyChainBiometry()  {
        
    return cuckoo_manager.call(
    """
    clearKeyChainBiometry()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.clearKeyChainBiometry())
        
    }
    
    
    
    
    
    public func clear()  {
        
    return cuckoo_manager.call(
    """
    clear()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.clear())
        
    }
    
    

    public struct __StubbingProxy_KeyChainControllerType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func storeValue<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(key: M1, value: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(KeychainWrapper, String)> where M1.MatchedType == KeychainWrapper, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper, String)>] = [wrap(matchable: key) { $0.0 }, wrap(matchable: value) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainControllerType.self, method:
    """
    storeValue(key: KeychainWrapper, value: String)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getValue<M1: Cuckoo.Matchable>(key: M1) -> Cuckoo.ProtocolStubFunction<(KeychainWrapper), String?> where M1.MatchedType == KeychainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper)>] = [wrap(matchable: key) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainControllerType.self, method:
    """
    getValue(key: KeychainWrapper) -> String?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func removeObject<M1: Cuckoo.Matchable>(key: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(KeychainWrapper)> where M1.MatchedType == KeychainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper)>] = [wrap(matchable: key) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainControllerType.self, method:
    """
    removeObject(key: KeychainWrapper)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func validateKeyChainBiometry() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainControllerType.self, method:
    """
    validateKeyChainBiometry() throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func clearKeyChainBiometry() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainControllerType.self, method:
    """
    clearKeyChainBiometry()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func clear() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainControllerType.self, method:
    """
    clear()
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_KeyChainControllerType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func storeValue<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(key: M1, value: M2) -> Cuckoo.__DoNotUse<(KeychainWrapper, String), Void> where M1.MatchedType == KeychainWrapper, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper, String)>] = [wrap(matchable: key) { $0.0 }, wrap(matchable: value) { $0.1 }]
            return cuckoo_manager.verify(
    """
    storeValue(key: KeychainWrapper, value: String)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getValue<M1: Cuckoo.Matchable>(key: M1) -> Cuckoo.__DoNotUse<(KeychainWrapper), String?> where M1.MatchedType == KeychainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper)>] = [wrap(matchable: key) { $0 }]
            return cuckoo_manager.verify(
    """
    getValue(key: KeychainWrapper) -> String?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func removeObject<M1: Cuckoo.Matchable>(key: M1) -> Cuckoo.__DoNotUse<(KeychainWrapper), Void> where M1.MatchedType == KeychainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper)>] = [wrap(matchable: key) { $0 }]
            return cuckoo_manager.verify(
    """
    removeObject(key: KeychainWrapper)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func validateKeyChainBiometry() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    validateKeyChainBiometry() throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func clearKeyChainBiometry() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    clearKeyChainBiometry()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func clear() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    clear()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class KeyChainControllerTypeStub: KeyChainControllerType {
    

    

    
    
    
    
    public func storeValue(key: KeychainWrapper, value: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func getValue(key: KeychainWrapper) -> String?  {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    
    
    
    
    public func removeObject(key: KeychainWrapper)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func validateKeyChainBiometry() throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func clearKeyChainBiometry()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func clear()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation






public class MockPrefsControllerType: PrefsControllerType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = PrefsControllerType
    
    public typealias Stubbing = __StubbingProxy_PrefsControllerType
    public typealias Verification = __VerificationProxy_PrefsControllerType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: PrefsControllerType?

    public func enableDefaultImplementation(_ stub: PrefsControllerType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func setValue(_ value: Any?, forKey: PrefsController.Key)  {
        
    return cuckoo_manager.call(
    """
    setValue(_: Any?, forKey: PrefsController.Key)
    """,
            parameters: (value, forKey),
            escapingParameters: (value, forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setValue(value, forKey: forKey))
        
    }
    
    
    
    
    
    public func getString(forKey: PrefsController.Key) -> String? {
        
    return cuckoo_manager.call(
    """
    getString(forKey: PrefsController.Key) -> String?
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getString(forKey: forKey))
        
    }
    
    
    
    
    
    public func getOptionalString(forKey: PrefsController.Key) -> String {
        
    return cuckoo_manager.call(
    """
    getOptionalString(forKey: PrefsController.Key) -> String
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getOptionalString(forKey: forKey))
        
    }
    
    
    
    
    
    public func getBool(forKey: PrefsController.Key) -> Bool {
        
    return cuckoo_manager.call(
    """
    getBool(forKey: PrefsController.Key) -> Bool
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getBool(forKey: forKey))
        
    }
    
    
    
    
    
    public func getFloat(forKey: PrefsController.Key) -> Float {
        
    return cuckoo_manager.call(
    """
    getFloat(forKey: PrefsController.Key) -> Float
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getFloat(forKey: forKey))
        
    }
    
    
    
    
    
    public func getInt(forKey: PrefsController.Key) -> Int {
        
    return cuckoo_manager.call(
    """
    getInt(forKey: PrefsController.Key) -> Int
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getInt(forKey: forKey))
        
    }
    
    
    
    
    
    public func remove(forKey: PrefsController.Key)  {
        
    return cuckoo_manager.call(
    """
    remove(forKey: PrefsController.Key)
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.remove(forKey: forKey))
        
    }
    
    
    
    
    
    public func getValue(forKey: PrefsController.Key) -> Any? {
        
    return cuckoo_manager.call(
    """
    getValue(forKey: PrefsController.Key) -> Any?
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getValue(forKey: forKey))
        
    }
    
    
    
    
    
    public func getUserLocale() -> String {
        
    return cuckoo_manager.call(
    """
    getUserLocale() -> String
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getUserLocale())
        
    }
    
    

    public struct __StubbingProxy_PrefsControllerType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func setValue<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable>(_ value: M1, forKey: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(Any?, PrefsController.Key)> where M1.OptionalMatchedType == Any, M2.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Any?, PrefsController.Key)>] = [wrap(matchable: value) { $0.0 }, wrap(matchable: forKey) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsControllerType.self, method:
    """
    setValue(_: Any?, forKey: PrefsController.Key)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getString<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubFunction<(PrefsController.Key), String?> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsControllerType.self, method:
    """
    getString(forKey: PrefsController.Key) -> String?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getOptionalString<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubFunction<(PrefsController.Key), String> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsControllerType.self, method:
    """
    getOptionalString(forKey: PrefsController.Key) -> String
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getBool<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubFunction<(PrefsController.Key), Bool> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsControllerType.self, method:
    """
    getBool(forKey: PrefsController.Key) -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getFloat<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubFunction<(PrefsController.Key), Float> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsControllerType.self, method:
    """
    getFloat(forKey: PrefsController.Key) -> Float
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getInt<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubFunction<(PrefsController.Key), Int> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsControllerType.self, method:
    """
    getInt(forKey: PrefsController.Key) -> Int
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func remove<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(PrefsController.Key)> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsControllerType.self, method:
    """
    remove(forKey: PrefsController.Key)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getValue<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubFunction<(PrefsController.Key), Any?> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsControllerType.self, method:
    """
    getValue(forKey: PrefsController.Key) -> Any?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getUserLocale() -> Cuckoo.ProtocolStubFunction<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsControllerType.self, method:
    """
    getUserLocale() -> String
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_PrefsControllerType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func setValue<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable>(_ value: M1, forKey: M2) -> Cuckoo.__DoNotUse<(Any?, PrefsController.Key), Void> where M1.OptionalMatchedType == Any, M2.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Any?, PrefsController.Key)>] = [wrap(matchable: value) { $0.0 }, wrap(matchable: forKey) { $0.1 }]
            return cuckoo_manager.verify(
    """
    setValue(_: Any?, forKey: PrefsController.Key)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getString<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(PrefsController.Key), String?> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    getString(forKey: PrefsController.Key) -> String?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getOptionalString<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(PrefsController.Key), String> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    getOptionalString(forKey: PrefsController.Key) -> String
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getBool<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(PrefsController.Key), Bool> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    getBool(forKey: PrefsController.Key) -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getFloat<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(PrefsController.Key), Float> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    getFloat(forKey: PrefsController.Key) -> Float
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getInt<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(PrefsController.Key), Int> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    getInt(forKey: PrefsController.Key) -> Int
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func remove<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(PrefsController.Key), Void> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    remove(forKey: PrefsController.Key)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getValue<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(PrefsController.Key), Any?> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    getValue(forKey: PrefsController.Key) -> Any?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getUserLocale() -> Cuckoo.__DoNotUse<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getUserLocale() -> String
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class PrefsControllerTypeStub: PrefsControllerType {
    

    

    
    
    
    
    public func setValue(_ value: Any?, forKey: PrefsController.Key)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func getString(forKey: PrefsController.Key) -> String?  {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    
    
    
    
    public func getOptionalString(forKey: PrefsController.Key) -> String  {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    
    
    
    
    public func getBool(forKey: PrefsController.Key) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func getFloat(forKey: PrefsController.Key) -> Float  {
        return DefaultValueRegistry.defaultValue(for: (Float).self)
    }
    
    
    
    
    
    public func getInt(forKey: PrefsController.Key) -> Int  {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    
    
    
    
    public func remove(forKey: PrefsController.Key)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func getValue(forKey: PrefsController.Key) -> Any?  {
        return DefaultValueRegistry.defaultValue(for: (Any?).self)
    }
    
    
    
    
    
    public func getUserLocale() -> String  {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import BluetoothKit
import Combine
import Foundation
import Network
import UIKit






public class MockReachabilityControllerType: ReachabilityControllerType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = ReachabilityControllerType
    
    public typealias Stubbing = __StubbingProxy_ReachabilityControllerType
    public typealias Verification = __VerificationProxy_ReachabilityControllerType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: ReachabilityControllerType?

    public func enableDefaultImplementation(_ stub: ReachabilityControllerType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var networkPath: NWPath {
        get {
            return cuckoo_manager.getter("networkPath",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.networkPath)
        }
        
    }
    
    

    

    
    
    
    
    public func getBleAvailibity() -> AnyPublisher<ReachabilityController.BleAvailibity, Never> {
        
    return cuckoo_manager.call(
    """
    getBleAvailibity() -> AnyPublisher<ReachabilityController.BleAvailibity, Never>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getBleAvailibity())
        
    }
    
    
    
    
    
    public func openBleSettings()  {
        
    return cuckoo_manager.call(
    """
    openBleSettings()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.openBleSettings())
        
    }
    
    

    public struct __StubbingProxy_ReachabilityControllerType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var networkPath: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockReachabilityControllerType, NWPath> {
            return .init(manager: cuckoo_manager, name: "networkPath")
        }
        
        
        
        
        
        func getBleAvailibity() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<ReachabilityController.BleAvailibity, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReachabilityControllerType.self, method:
    """
    getBleAvailibity() -> AnyPublisher<ReachabilityController.BleAvailibity, Never>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openBleSettings() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReachabilityControllerType.self, method:
    """
    openBleSettings()
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_ReachabilityControllerType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var networkPath: Cuckoo.VerifyReadOnlyProperty<NWPath> {
            return .init(manager: cuckoo_manager, name: "networkPath", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func getBleAvailibity() -> Cuckoo.__DoNotUse<(), AnyPublisher<ReachabilityController.BleAvailibity, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getBleAvailibity() -> AnyPublisher<ReachabilityController.BleAvailibity, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openBleSettings() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openBleSettings()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class ReachabilityControllerTypeStub: ReachabilityControllerType {
    
    
    
    
    public var networkPath: NWPath {
        get {
            return DefaultValueRegistry.defaultValue(for: (NWPath).self)
        }
        
    }
    
    

    

    
    
    
    
    public func getBleAvailibity() -> AnyPublisher<ReachabilityController.BleAvailibity, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<ReachabilityController.BleAvailibity, Never>).self)
    }
    
    
    
    
    
    public func openBleSettings()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Combine
import Foundation
import IOSSecuritySuite
import UIKit






public class MockSecurityControllerType: SecurityControllerType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = SecurityControllerType
    
    public typealias Stubbing = __StubbingProxy_SecurityControllerType
    public typealias Verification = __VerificationProxy_SecurityControllerType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: SecurityControllerType?

    public func enableDefaultImplementation(_ stub: SecurityControllerType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func isRunningOnEmulator() -> Bool {
        
    return cuckoo_manager.call(
    """
    isRunningOnEmulator() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isRunningOnEmulator())
        
    }
    
    
    
    
    
    public func isDeviceJailBroken() -> Bool {
        
    return cuckoo_manager.call(
    """
    isDeviceJailBroken() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isDeviceJailBroken())
        
    }
    
    
    
    
    
    public func isReverseEngineered() -> Bool {
        
    return cuckoo_manager.call(
    """
    isReverseEngineered() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isReverseEngineered())
        
    }
    
    
    
    
    
    public func isSignatureValid() -> Bool {
        
    return cuckoo_manager.call(
    """
    isSignatureValid() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isSignatureValid())
        
    }
    
    
    
    
    
    public func isDebuggable() -> Bool {
        
    return cuckoo_manager.call(
    """
    isDebuggable() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isDebuggable())
        
    }
    
    
    
    
    
    public func isApplicationSecure() -> AnyPublisher<SecurityController.SecurityValidation, Never> {
        
    return cuckoo_manager.call(
    """
    isApplicationSecure() -> AnyPublisher<SecurityController.SecurityValidation, Never>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isApplicationSecure())
        
    }
    
    
    
    
    
    public func isScreenCaptureDisabled() -> Bool {
        
    return cuckoo_manager.call(
    """
    isScreenCaptureDisabled() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isScreenCaptureDisabled())
        
    }
    
    
    
    
    
    public func isBlockUnsecureWebContentEnabled() -> Bool {
        
    return cuckoo_manager.call(
    """
    isBlockUnsecureWebContentEnabled() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isBlockUnsecureWebContentEnabled())
        
    }
    
    
    
    
    
    public func isDeviceBindingValid() -> Bool {
        
    return cuckoo_manager.call(
    """
    isDeviceBindingValid() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isDeviceBindingValid())
        
    }
    
    

    public struct __StubbingProxy_SecurityControllerType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func isRunningOnEmulator() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityControllerType.self, method:
    """
    isRunningOnEmulator() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isDeviceJailBroken() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityControllerType.self, method:
    """
    isDeviceJailBroken() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isReverseEngineered() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityControllerType.self, method:
    """
    isReverseEngineered() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isSignatureValid() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityControllerType.self, method:
    """
    isSignatureValid() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isDebuggable() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityControllerType.self, method:
    """
    isDebuggable() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isApplicationSecure() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<SecurityController.SecurityValidation, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityControllerType.self, method:
    """
    isApplicationSecure() -> AnyPublisher<SecurityController.SecurityValidation, Never>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isScreenCaptureDisabled() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityControllerType.self, method:
    """
    isScreenCaptureDisabled() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isBlockUnsecureWebContentEnabled() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityControllerType.self, method:
    """
    isBlockUnsecureWebContentEnabled() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isDeviceBindingValid() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityControllerType.self, method:
    """
    isDeviceBindingValid() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_SecurityControllerType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func isRunningOnEmulator() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isRunningOnEmulator() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isDeviceJailBroken() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isDeviceJailBroken() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isReverseEngineered() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isReverseEngineered() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isSignatureValid() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isSignatureValid() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isDebuggable() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isDebuggable() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isApplicationSecure() -> Cuckoo.__DoNotUse<(), AnyPublisher<SecurityController.SecurityValidation, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isApplicationSecure() -> AnyPublisher<SecurityController.SecurityValidation, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isScreenCaptureDisabled() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isScreenCaptureDisabled() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isBlockUnsecureWebContentEnabled() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isBlockUnsecureWebContentEnabled() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isDeviceBindingValid() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isDeviceBindingValid() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class SecurityControllerTypeStub: SecurityControllerType {
    

    

    
    
    
    
    public func isRunningOnEmulator() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func isDeviceJailBroken() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func isReverseEngineered() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func isSignatureValid() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func isDebuggable() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func isApplicationSecure() -> AnyPublisher<SecurityController.SecurityValidation, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<SecurityController.SecurityValidation, Never>).self)
    }
    
    
    
    
    
    public func isScreenCaptureDisabled() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func isBlockUnsecureWebContentEnabled() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func isDeviceBindingValid() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Combine
import Foundation
import logic_core
import logic_resources






public class MockWalletKitControllerType: WalletKitControllerType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = WalletKitControllerType
    
    public typealias Stubbing = __StubbingProxy_WalletKitControllerType
    public typealias Verification = __VerificationProxy_WalletKitControllerType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: WalletKitControllerType?

    public func enableDefaultImplementation(_ stub: WalletKitControllerType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var wallet: EudiWallet {
        get {
            return cuckoo_manager.getter("wallet",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.wallet)
        }
        
    }
    
    
    
    
    
    public var activeCoordinator: PresentationSessionCoordinatorType? {
        get {
            return cuckoo_manager.getter("activeCoordinator",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.activeCoordinator)
        }
        
    }
    
    

    

    
    
    
    
    public func startProximityPresentation() -> PresentationSessionCoordinatorType {
        
    return cuckoo_manager.call(
    """
    startProximityPresentation() -> PresentationSessionCoordinatorType
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.startProximityPresentation())
        
    }
    
    
    
    
    
    public func startSameDevicePresentation(deepLink: URLComponents) -> PresentationSessionCoordinatorType {
        
    return cuckoo_manager.call(
    """
    startSameDevicePresentation(deepLink: URLComponents) -> PresentationSessionCoordinatorType
    """,
            parameters: (deepLink),
            escapingParameters: (deepLink),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.startSameDevicePresentation(deepLink: deepLink))
        
    }
    
    
    
    
    
    public func startCrossDevicePresentation(urlString: String) -> PresentationSessionCoordinatorType {
        
    return cuckoo_manager.call(
    """
    startCrossDevicePresentation(urlString: String) -> PresentationSessionCoordinatorType
    """,
            parameters: (urlString),
            escapingParameters: (urlString),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.startCrossDevicePresentation(urlString: urlString))
        
    }
    
    
    
    
    
    public func stopPresentation()  {
        
    return cuckoo_manager.call(
    """
    stopPresentation()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.stopPresentation())
        
    }
    
    
    
    
    
    public func fetchDocuments() -> [MdocDecodable] {
        
    return cuckoo_manager.call(
    """
    fetchDocuments() -> [MdocDecodable]
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchDocuments())
        
    }
    
    
    
    
    
    public func fetchDocument(with id: String) -> MdocDecodable? {
        
    return cuckoo_manager.call(
    """
    fetchDocument(with: String) -> MdocDecodable?
    """,
            parameters: (id),
            escapingParameters: (id),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchDocument(with: id))
        
    }
    
    
    
    
    
    public func loadSampleData(dataFiles: [String]) async throws {
        
    return try await cuckoo_manager.callThrows(
    """
    loadSampleData(dataFiles: [String]) async throws
    """,
            parameters: (dataFiles),
            escapingParameters: (dataFiles),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.loadSampleData(dataFiles: dataFiles))
        
    }
    
    
    
    
    
    public func clearDocuments() async throws {
        
    return try await cuckoo_manager.callThrows(
    """
    clearDocuments() async throws
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.clearDocuments())
        
    }
    
    
    
    
    
    public func deleteDocument(with type: String) async throws {
        
    return try await cuckoo_manager.callThrows(
    """
    deleteDocument(with: String) async throws
    """,
            parameters: (type),
            escapingParameters: (type),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.deleteDocument(with: type))
        
    }
    
    
    
    
    
    public func loadDocuments() async throws {
        
    return try await cuckoo_manager.callThrows(
    """
    loadDocuments() async throws
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.loadDocuments())
        
    }
    
    
    
    
    
    public func issueDocument(docType: String, format: DataFormat) async throws -> WalletStorage.Document {
        
    return try await cuckoo_manager.callThrows(
    """
    issueDocument(docType: String, format: DataFormat) async throws -> WalletStorage.Document
    """,
            parameters: (docType, format),
            escapingParameters: (docType, format),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.issueDocument(docType: docType, format: format))
        
    }
    
    

    public struct __StubbingProxy_WalletKitControllerType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var wallet: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitControllerType, EudiWallet> {
            return .init(manager: cuckoo_manager, name: "wallet")
        }
        
        
        
        
        var activeCoordinator: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitControllerType, PresentationSessionCoordinatorType?> {
            return .init(manager: cuckoo_manager, name: "activeCoordinator")
        }
        
        
        
        
        
        func startProximityPresentation() -> Cuckoo.ProtocolStubFunction<(), PresentationSessionCoordinatorType> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    startProximityPresentation() -> PresentationSessionCoordinatorType
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func startSameDevicePresentation<M1: Cuckoo.Matchable>(deepLink: M1) -> Cuckoo.ProtocolStubFunction<(URLComponents), PresentationSessionCoordinatorType> where M1.MatchedType == URLComponents {
            let matchers: [Cuckoo.ParameterMatcher<(URLComponents)>] = [wrap(matchable: deepLink) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    startSameDevicePresentation(deepLink: URLComponents) -> PresentationSessionCoordinatorType
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func startCrossDevicePresentation<M1: Cuckoo.Matchable>(urlString: M1) -> Cuckoo.ProtocolStubFunction<(String), PresentationSessionCoordinatorType> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: urlString) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    startCrossDevicePresentation(urlString: String) -> PresentationSessionCoordinatorType
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func stopPresentation() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    stopPresentation()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchDocuments() -> Cuckoo.ProtocolStubFunction<(), [MdocDecodable]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    fetchDocuments() -> [MdocDecodable]
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchDocument<M1: Cuckoo.Matchable>(with id: M1) -> Cuckoo.ProtocolStubFunction<(String), MdocDecodable?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: id) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    fetchDocument(with: String) -> MdocDecodable?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func loadSampleData<M1: Cuckoo.Matchable>(dataFiles: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<([String])> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: dataFiles) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    loadSampleData(dataFiles: [String]) async throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func clearDocuments() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    clearDocuments() async throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func deleteDocument<M1: Cuckoo.Matchable>(with type: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: type) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    deleteDocument(with: String) async throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func loadDocuments() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    loadDocuments() async throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func issueDocument<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(docType: M1, format: M2) -> Cuckoo.ProtocolStubThrowingFunction<(String, DataFormat), WalletStorage.Document> where M1.MatchedType == String, M2.MatchedType == DataFormat {
            let matchers: [Cuckoo.ParameterMatcher<(String, DataFormat)>] = [wrap(matchable: docType) { $0.0 }, wrap(matchable: format) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    issueDocument(docType: String, format: DataFormat) async throws -> WalletStorage.Document
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_WalletKitControllerType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var wallet: Cuckoo.VerifyReadOnlyProperty<EudiWallet> {
            return .init(manager: cuckoo_manager, name: "wallet", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var activeCoordinator: Cuckoo.VerifyReadOnlyProperty<PresentationSessionCoordinatorType?> {
            return .init(manager: cuckoo_manager, name: "activeCoordinator", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func startProximityPresentation() -> Cuckoo.__DoNotUse<(), PresentationSessionCoordinatorType> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    startProximityPresentation() -> PresentationSessionCoordinatorType
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func startSameDevicePresentation<M1: Cuckoo.Matchable>(deepLink: M1) -> Cuckoo.__DoNotUse<(URLComponents), PresentationSessionCoordinatorType> where M1.MatchedType == URLComponents {
            let matchers: [Cuckoo.ParameterMatcher<(URLComponents)>] = [wrap(matchable: deepLink) { $0 }]
            return cuckoo_manager.verify(
    """
    startSameDevicePresentation(deepLink: URLComponents) -> PresentationSessionCoordinatorType
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func startCrossDevicePresentation<M1: Cuckoo.Matchable>(urlString: M1) -> Cuckoo.__DoNotUse<(String), PresentationSessionCoordinatorType> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: urlString) { $0 }]
            return cuckoo_manager.verify(
    """
    startCrossDevicePresentation(urlString: String) -> PresentationSessionCoordinatorType
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func stopPresentation() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    stopPresentation()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchDocuments() -> Cuckoo.__DoNotUse<(), [MdocDecodable]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    fetchDocuments() -> [MdocDecodable]
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchDocument<M1: Cuckoo.Matchable>(with id: M1) -> Cuckoo.__DoNotUse<(String), MdocDecodable?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: id) { $0 }]
            return cuckoo_manager.verify(
    """
    fetchDocument(with: String) -> MdocDecodable?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func loadSampleData<M1: Cuckoo.Matchable>(dataFiles: M1) -> Cuckoo.__DoNotUse<([String]), Void> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: dataFiles) { $0 }]
            return cuckoo_manager.verify(
    """
    loadSampleData(dataFiles: [String]) async throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func clearDocuments() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    clearDocuments() async throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func deleteDocument<M1: Cuckoo.Matchable>(with type: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: type) { $0 }]
            return cuckoo_manager.verify(
    """
    deleteDocument(with: String) async throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func loadDocuments() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    loadDocuments() async throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func issueDocument<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(docType: M1, format: M2) -> Cuckoo.__DoNotUse<(String, DataFormat), WalletStorage.Document> where M1.MatchedType == String, M2.MatchedType == DataFormat {
            let matchers: [Cuckoo.ParameterMatcher<(String, DataFormat)>] = [wrap(matchable: docType) { $0.0 }, wrap(matchable: format) { $0.1 }]
            return cuckoo_manager.verify(
    """
    issueDocument(docType: String, format: DataFormat) async throws -> WalletStorage.Document
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class WalletKitControllerTypeStub: WalletKitControllerType {
    
    
    
    
    public var wallet: EudiWallet {
        get {
            return DefaultValueRegistry.defaultValue(for: (EudiWallet).self)
        }
        
    }
    
    
    
    
    
    public var activeCoordinator: PresentationSessionCoordinatorType? {
        get {
            return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinatorType?).self)
        }
        
    }
    
    

    

    
    
    
    
    public func startProximityPresentation() -> PresentationSessionCoordinatorType  {
        return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinatorType).self)
    }
    
    
    
    
    
    public func startSameDevicePresentation(deepLink: URLComponents) -> PresentationSessionCoordinatorType  {
        return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinatorType).self)
    }
    
    
    
    
    
    public func startCrossDevicePresentation(urlString: String) -> PresentationSessionCoordinatorType  {
        return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinatorType).self)
    }
    
    
    
    
    
    public func stopPresentation()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func fetchDocuments() -> [MdocDecodable]  {
        return DefaultValueRegistry.defaultValue(for: ([MdocDecodable]).self)
    }
    
    
    
    
    
    public func fetchDocument(with id: String) -> MdocDecodable?  {
        return DefaultValueRegistry.defaultValue(for: (MdocDecodable?).self)
    }
    
    
    
    
    
    public func loadSampleData(dataFiles: [String]) async throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func clearDocuments() async throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func deleteDocument(with type: String) async throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func loadDocuments() async throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func issueDocument(docType: String, format: DataFormat) async throws -> WalletStorage.Document  {
        return DefaultValueRegistry.defaultValue(for: (WalletStorage.Document).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Combine
import Foundation
import logic_core
import logic_resources






public class MockPresentationSessionCoordinatorType: PresentationSessionCoordinatorType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = PresentationSessionCoordinatorType
    
    public typealias Stubbing = __StubbingProxy_PresentationSessionCoordinatorType
    public typealias Verification = __VerificationProxy_PresentationSessionCoordinatorType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: PresentationSessionCoordinatorType?

    public func enableDefaultImplementation(_ stub: PresentationSessionCoordinatorType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var presentationStateSubject: CurrentValueSubject<PresentationState, Never> {
        get {
            return cuckoo_manager.getter("presentationStateSubject",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.presentationStateSubject)
        }
        
    }
    
    

    
    
    
    public required init(session: PresentationSession) {
        
    }
    
    

    
    
    
    
    public func initialize() async {
        
    return await cuckoo_manager.call(
    """
    initialize() async
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.initialize())
        
    }
    
    
    
    
    
    public func startQrEngagement() async throws -> Data {
        
    return try await cuckoo_manager.callThrows(
    """
    startQrEngagement() async throws -> Data
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.startQrEngagement())
        
    }
    
    
    
    
    
    public func requestReceived() async throws -> PresentationRequest {
        
    return try await cuckoo_manager.callThrows(
    """
    requestReceived() async throws -> PresentationRequest
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.requestReceived())
        
    }
    
    
    
    
    
    public func sendResponse(response: RequestItemConvertible, onSuccess: ((URL?) -> Void)?, onCancel: (() -> Void)?) async throws {
        
    return try await cuckoo_manager.callThrows(
    """
    sendResponse(response: RequestItemConvertible, onSuccess: ((URL?) -> Void)?, onCancel: (() -> Void)?) async throws
    """,
            parameters: (response, onSuccess, onCancel),
            escapingParameters: (response, onSuccess, onCancel),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.sendResponse(response: response, onSuccess: onSuccess, onCancel: onCancel))
        
    }
    
    
    
    
    
    public func onSuccess(completion: () -> Void)  {
        return withoutActuallyEscaping(completion, do: { (completion: @escaping () -> Void) -> Void in

    return cuckoo_manager.call(
    """
    onSuccess(completion: () -> Void)
    """,
            parameters: (completion),
            escapingParameters: ({ () in fatalError("This is a stub! It's not supposed to be called!") }),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.onSuccess(completion: completion))
        })

    }
    
    
    
    
    
    public func getState() async -> PresentationState {
        
    return await cuckoo_manager.call(
    """
    getState() async -> PresentationState
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.getState())
        
    }
    
    
    
    
    
    public func setState(presentationState: PresentationState)  {
        
    return cuckoo_manager.call(
    """
    setState(presentationState: PresentationState)
    """,
            parameters: (presentationState),
            escapingParameters: (presentationState),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setState(presentationState: presentationState))
        
    }
    
    

    public struct __StubbingProxy_PresentationSessionCoordinatorType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var presentationStateSubject: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockPresentationSessionCoordinatorType, CurrentValueSubject<PresentationState, Never>> {
            return .init(manager: cuckoo_manager, name: "presentationStateSubject")
        }
        
        
        
        
        
        func initialize() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinatorType.self, method:
    """
    initialize() async
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func startQrEngagement() -> Cuckoo.ProtocolStubThrowingFunction<(), Data> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinatorType.self, method:
    """
    startQrEngagement() async throws -> Data
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func requestReceived() -> Cuckoo.ProtocolStubThrowingFunction<(), PresentationRequest> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinatorType.self, method:
    """
    requestReceived() async throws -> PresentationRequest
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func sendResponse<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable>(response: M1, onSuccess: M2, onCancel: M3) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(RequestItemConvertible, ((URL?) -> Void)?, (() -> Void)?)> where M1.MatchedType == RequestItemConvertible, M2.OptionalMatchedType == ((URL?) -> Void), M3.OptionalMatchedType == (() -> Void) {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible, ((URL?) -> Void)?, (() -> Void)?)>] = [wrap(matchable: response) { $0.0 }, wrap(matchable: onSuccess) { $0.1 }, wrap(matchable: onCancel) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinatorType.self, method:
    """
    sendResponse(response: RequestItemConvertible, onSuccess: ((URL?) -> Void)?, onCancel: (() -> Void)?) async throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func onSuccess<M1: Cuckoo.Matchable>(completion: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(() -> Void)> where M1.MatchedType == () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: completion) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinatorType.self, method:
    """
    onSuccess(completion: () -> Void)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getState() -> Cuckoo.ProtocolStubFunction<(), PresentationState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinatorType.self, method:
    """
    getState() async -> PresentationState
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setState<M1: Cuckoo.Matchable>(presentationState: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(PresentationState)> where M1.MatchedType == PresentationState {
            let matchers: [Cuckoo.ParameterMatcher<(PresentationState)>] = [wrap(matchable: presentationState) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinatorType.self, method:
    """
    setState(presentationState: PresentationState)
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_PresentationSessionCoordinatorType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var presentationStateSubject: Cuckoo.VerifyReadOnlyProperty<CurrentValueSubject<PresentationState, Never>> {
            return .init(manager: cuckoo_manager, name: "presentationStateSubject", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func initialize() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    initialize() async
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func startQrEngagement() -> Cuckoo.__DoNotUse<(), Data> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    startQrEngagement() async throws -> Data
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func requestReceived() -> Cuckoo.__DoNotUse<(), PresentationRequest> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    requestReceived() async throws -> PresentationRequest
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func sendResponse<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable>(response: M1, onSuccess: M2, onCancel: M3) -> Cuckoo.__DoNotUse<(RequestItemConvertible, ((URL?) -> Void)?, (() -> Void)?), Void> where M1.MatchedType == RequestItemConvertible, M2.OptionalMatchedType == ((URL?) -> Void), M3.OptionalMatchedType == (() -> Void) {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible, ((URL?) -> Void)?, (() -> Void)?)>] = [wrap(matchable: response) { $0.0 }, wrap(matchable: onSuccess) { $0.1 }, wrap(matchable: onCancel) { $0.2 }]
            return cuckoo_manager.verify(
    """
    sendResponse(response: RequestItemConvertible, onSuccess: ((URL?) -> Void)?, onCancel: (() -> Void)?) async throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func onSuccess<M1: Cuckoo.Matchable>(completion: M1) -> Cuckoo.__DoNotUse<(() -> Void), Void> where M1.MatchedType == () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: completion) { $0 }]
            return cuckoo_manager.verify(
    """
    onSuccess(completion: () -> Void)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getState() -> Cuckoo.__DoNotUse<(), PresentationState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getState() async -> PresentationState
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setState<M1: Cuckoo.Matchable>(presentationState: M1) -> Cuckoo.__DoNotUse<(PresentationState), Void> where M1.MatchedType == PresentationState {
            let matchers: [Cuckoo.ParameterMatcher<(PresentationState)>] = [wrap(matchable: presentationState) { $0 }]
            return cuckoo_manager.verify(
    """
    setState(presentationState: PresentationState)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class PresentationSessionCoordinatorTypeStub: PresentationSessionCoordinatorType {
    
    
    
    
    public var presentationStateSubject: CurrentValueSubject<PresentationState, Never> {
        get {
            return DefaultValueRegistry.defaultValue(for: (CurrentValueSubject<PresentationState, Never>).self)
        }
        
    }
    
    

    
    
    public required init(session: PresentationSession) {
        
    }
    
    

    
    
    
    
    public func initialize() async  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func startQrEngagement() async throws -> Data  {
        return DefaultValueRegistry.defaultValue(for: (Data).self)
    }
    
    
    
    
    
    public func requestReceived() async throws -> PresentationRequest  {
        return DefaultValueRegistry.defaultValue(for: (PresentationRequest).self)
    }
    
    
    
    
    
    public func sendResponse(response: RequestItemConvertible, onSuccess: ((URL?) -> Void)?, onCancel: (() -> Void)?) async throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func onSuccess(completion: () -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func getState() async -> PresentationState  {
        return DefaultValueRegistry.defaultValue(for: (PresentationState).self)
    }
    
    
    
    
    
    public func setState(presentationState: PresentationState)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Combine
import Foundation
import logic_core
import logic_resources

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Combine
import Foundation
import logic_core
import logic_resources

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation
import logic_resources

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Combine
import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation
import UIKit

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import SwiftUI
import logic_core
import logic_resources

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation
import logic_core
import logic_resources

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation
import logic_core
import logic_resources

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Foundation
import logic_core






public class MockRequestItemConvertible: RequestItemConvertible, Cuckoo.ProtocolMock {
    
    public typealias MocksType = RequestItemConvertible
    
    public typealias Stubbing = __StubbingProxy_RequestItemConvertible
    public typealias Verification = __VerificationProxy_RequestItemConvertible

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: RequestItemConvertible?

    public func enableDefaultImplementation(_ stub: RequestItemConvertible) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func asRequestItems() -> RequestConvertibleItems {
        
    return cuckoo_manager.call(
    """
    asRequestItems() -> RequestConvertibleItems
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.asRequestItems())
        
    }
    
    

    public struct __StubbingProxy_RequestItemConvertible: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func asRequestItems() -> Cuckoo.ProtocolStubFunction<(), RequestConvertibleItems> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRequestItemConvertible.self, method:
    """
    asRequestItems() -> RequestConvertibleItems
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_RequestItemConvertible: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func asRequestItems() -> Cuckoo.__DoNotUse<(), RequestConvertibleItems> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    asRequestItems() -> RequestConvertibleItems
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class RequestItemConvertibleStub: RequestItemConvertible {
    

    

    
    
    
    
    public func asRequestItems() -> RequestConvertibleItems  {
        return DefaultValueRegistry.defaultValue(for: (RequestConvertibleItems).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import class Foundation.Bundle






public class MockConfigProviderType: ConfigProviderType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = ConfigProviderType
    
    public typealias Stubbing = __StubbingProxy_ConfigProviderType
    public typealias Verification = __VerificationProxy_ConfigProviderType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: ConfigProviderType?

    public func enableDefaultImplementation(_ stub: ConfigProviderType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func getConfigLogic() -> ConfigLogic {
        
    return cuckoo_manager.call(
    """
    getConfigLogic() -> ConfigLogic
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getConfigLogic())
        
    }
    
    
    
    
    
    public func getConfigSecurityLogic() -> ConfigSecurityLogic {
        
    return cuckoo_manager.call(
    """
    getConfigSecurityLogic() -> ConfigSecurityLogic
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getConfigSecurityLogic())
        
    }
    
    

    public struct __StubbingProxy_ConfigProviderType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getConfigLogic() -> Cuckoo.ProtocolStubFunction<(), ConfigLogic> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockConfigProviderType.self, method:
    """
    getConfigLogic() -> ConfigLogic
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getConfigSecurityLogic() -> Cuckoo.ProtocolStubFunction<(), ConfigSecurityLogic> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockConfigProviderType.self, method:
    """
    getConfigSecurityLogic() -> ConfigSecurityLogic
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_ConfigProviderType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getConfigLogic() -> Cuckoo.__DoNotUse<(), ConfigLogic> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getConfigLogic() -> ConfigLogic
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getConfigSecurityLogic() -> Cuckoo.__DoNotUse<(), ConfigSecurityLogic> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getConfigSecurityLogic() -> ConfigSecurityLogic
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class ConfigProviderTypeStub: ConfigProviderType {
    

    

    
    
    
    
    public func getConfigLogic() -> ConfigLogic  {
        return DefaultValueRegistry.defaultValue(for: (ConfigLogic).self)
    }
    
    
    
    
    
    public func getConfigSecurityLogic() -> ConfigSecurityLogic  {
        return DefaultValueRegistry.defaultValue(for: (ConfigSecurityLogic).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Combine
import Foundation
import Peppermint
import libPhoneNumber






public class MockFormValidatorType: FormValidatorType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = FormValidatorType
    
    public typealias Stubbing = __StubbingProxy_FormValidatorType
    public typealias Verification = __VerificationProxy_FormValidatorType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: FormValidatorType?

    public func enableDefaultImplementation(_ stub: FormValidatorType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never> {
        
    return cuckoo_manager.call(
    """
    validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>
    """,
            parameters: (form),
            escapingParameters: (form),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.validateForm(form: form))
        
    }
    
    
    
    
    
    public func validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never> {
        
    return cuckoo_manager.call(
    """
    validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>
    """,
            parameters: (forms),
            escapingParameters: (forms),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.validateForms(forms: forms))
        
    }
    
    

    public struct __StubbingProxy_FormValidatorType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func validateForm<M1: Cuckoo.Matchable>(form: M1) -> Cuckoo.ProtocolStubFunction<(ValidatableForm), AnyPublisher<FormValidationResult, Never>> where M1.MatchedType == ValidatableForm {
            let matchers: [Cuckoo.ParameterMatcher<(ValidatableForm)>] = [wrap(matchable: form) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFormValidatorType.self, method:
    """
    validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func validateForms<M1: Cuckoo.Matchable>(forms: M1) -> Cuckoo.ProtocolStubFunction<([ValidatableForm]), AnyPublisher<FormsValidationResult, Never>> where M1.MatchedType == [ValidatableForm] {
            let matchers: [Cuckoo.ParameterMatcher<([ValidatableForm])>] = [wrap(matchable: forms) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFormValidatorType.self, method:
    """
    validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_FormValidatorType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func validateForm<M1: Cuckoo.Matchable>(form: M1) -> Cuckoo.__DoNotUse<(ValidatableForm), AnyPublisher<FormValidationResult, Never>> where M1.MatchedType == ValidatableForm {
            let matchers: [Cuckoo.ParameterMatcher<(ValidatableForm)>] = [wrap(matchable: form) { $0 }]
            return cuckoo_manager.verify(
    """
    validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func validateForms<M1: Cuckoo.Matchable>(forms: M1) -> Cuckoo.__DoNotUse<([ValidatableForm]), AnyPublisher<FormsValidationResult, Never>> where M1.MatchedType == [ValidatableForm] {
            let matchers: [Cuckoo.ParameterMatcher<([ValidatableForm])>] = [wrap(matchable: forms) { $0 }]
            return cuckoo_manager.verify(
    """
    validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class FormValidatorTypeStub: FormValidatorType {
    

    

    
    
    
    
    public func validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<FormValidationResult, Never>).self)
    }
    
    
    
    
    
    public func validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<FormsValidationResult, Never>).self)
    }
    
    
}










public class MockFormValidatorInteractor: FormValidatorInteractor, Cuckoo.ProtocolMock {
    
    public typealias MocksType = FormValidatorInteractor
    
    public typealias Stubbing = __StubbingProxy_FormValidatorInteractor
    public typealias Verification = __VerificationProxy_FormValidatorInteractor

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: FormValidatorInteractor?

    public func enableDefaultImplementation(_ stub: FormValidatorInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never> {
        
    return cuckoo_manager.call(
    """
    validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>
    """,
            parameters: (form),
            escapingParameters: (form),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.validateForm(form: form))
        
    }
    
    
    
    
    
    public func validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never> {
        
    return cuckoo_manager.call(
    """
    validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>
    """,
            parameters: (forms),
            escapingParameters: (forms),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.validateForms(forms: forms))
        
    }
    
    

    public struct __StubbingProxy_FormValidatorInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func validateForm<M1: Cuckoo.Matchable>(form: M1) -> Cuckoo.ProtocolStubFunction<(ValidatableForm), AnyPublisher<FormValidationResult, Never>> where M1.MatchedType == ValidatableForm {
            let matchers: [Cuckoo.ParameterMatcher<(ValidatableForm)>] = [wrap(matchable: form) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFormValidatorInteractor.self, method:
    """
    validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func validateForms<M1: Cuckoo.Matchable>(forms: M1) -> Cuckoo.ProtocolStubFunction<([ValidatableForm]), AnyPublisher<FormsValidationResult, Never>> where M1.MatchedType == [ValidatableForm] {
            let matchers: [Cuckoo.ParameterMatcher<([ValidatableForm])>] = [wrap(matchable: forms) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFormValidatorInteractor.self, method:
    """
    validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_FormValidatorInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func validateForm<M1: Cuckoo.Matchable>(form: M1) -> Cuckoo.__DoNotUse<(ValidatableForm), AnyPublisher<FormValidationResult, Never>> where M1.MatchedType == ValidatableForm {
            let matchers: [Cuckoo.ParameterMatcher<(ValidatableForm)>] = [wrap(matchable: form) { $0 }]
            return cuckoo_manager.verify(
    """
    validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func validateForms<M1: Cuckoo.Matchable>(forms: M1) -> Cuckoo.__DoNotUse<([ValidatableForm]), AnyPublisher<FormsValidationResult, Never>> where M1.MatchedType == [ValidatableForm] {
            let matchers: [Cuckoo.ParameterMatcher<([ValidatableForm])>] = [wrap(matchable: forms) { $0 }]
            return cuckoo_manager.verify(
    """
    validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class FormValidatorInteractorStub: FormValidatorInteractor {
    

    

    
    
    
    
    public func validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<FormValidationResult, Never>).self)
    }
    
    
    
    
    
    public func validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<FormsValidationResult, Never>).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import Cuckoo
@testable import logic_business
@testable import logic_analytics
@testable import logic_core
@testable import logic_authentication

import EudiWalletKit
import MdocDataModel18013
import MdocDataTransfer18013
import MdocSecurity18013
import WalletStorage