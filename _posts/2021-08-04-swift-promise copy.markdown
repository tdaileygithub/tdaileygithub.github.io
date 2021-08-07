---
title:  "Swift - Dependency Injection with Swinject"
date:   2021-08-06 00:00:01 -0700
categories: swift
tags: [swift, ios]

---
# Swinject - Dependency Injection

- [https://github.com/Swinject/Swinject]()
- [https://github.com/Swinject/SwinjectStoryboard]()

Many of the online swift tutorials use development practices that are outdated in the c++, java, c# / OO communities.  There are relatively few tutorials describing a DDD or SOA type architeture for apps.  This makes sense from the fact that most ios apps are very simple do not need the flexibility of future proofing or swapping out components in the future but it is not ideal.

Swinject is a very easy to use DI framework that sufficiently handles DI to the viewcontrollers.  It is unfortunate that it does that through public property setting on the controllers but it is much better than tightly coupling in the class.

## Cocoa Podfile

{% highlight swift %}
pod 'Swinject'
pod 'SwinjectStoryboard'
{% endhighlight %}

{% highlight bash %}
pod install
{% endhighlight %}

## SwinjectDependencySetup.swift

The following code sets up a sample container that registers both view controllers and their associated services.  There is a breakout for simulated versus not simulated concretes that makes testing bluetooth apps in the simulator possible without putting #ifdef inside the service concretes.

{% highlight swift %}
import Swinject
import SwinjectStoryboard

func GetSwinjectContainer() -> Container {
    
    let container = Container()
    container.storyboardInitCompleted(MainNavigationController.self) { r, c in
        //
    }
    container.storyboardInitCompleted(DeviceSearchViewController.self) { r, c in
        c.bluetoothService     = r.resolve(IBluetoothDeviceService.self)
        c.timeService          = r.resolve(ITimeService.self)
    }
    container.storyboardInitCompleted(DeviceInfoViewController.self) { r, c in
        c.deviceInfoService     = r.resolve(IDeviceService.self)
    }
    container.storyboardInitCompleted(WatchAppDetailsViewController.self) { r, c in
        //
    }
    container.storyboardInitCompleted(DFUViewController.self) { r, c in
        //
    }
    container.storyboardInitCompleted(WatchAppListViewController.self) { r, c in
        c.heartRateService      = r.resolve(IHeartRateService.self)
        c.batteryLevelService   = r.resolve(IBatteryLevelService.self)
        c.watchAppService       = r.resolve(IWatchAppService.self)
    }
    #if targetEnvironment(simulator)
    container.register(IDeviceService.self)              { _ in DeviceInfoServiceSimluated() }
    container.register(IHeartRateService.self)           { _ in HeartRateServiceSimluated() }
    container.register(IBatteryLevelService.self)        { _ in BatteryLevelServiceSimulated() }
    container.register(IBluetoothDeviceService.self)     { _ in BluetoothServiceSimulated() }
    container.register(IWatchAppService.self)            { _ in WatchAppService() }
    container.register(ITimeService.self)                { _ in TimeServiceSimulated() }
    #else
    container.register(IDeviceService.self)              { _ in DeviceInfoService() }
    container.register(IHeartRateService.self)           { _ in HeartRateService() }
    container.register(IBatteryLevelService.self)        { _ in BatteryLevelService() }
    container.register(IBluetoothDeviceService.self)     { _ in BluetoothService() }
    container.register(IWatchAppService.self)            { _ in WatchAppService() }
    container.register(ITimeService.self)                { _ in TimeService() }
    #endif
    
    return container
}

//this function is supposed to automaticlly register storyboards
extension SwinjectStoryboard {
    @objc class func setup() {
        defaultContainer = GetSwinjectContainer()
    }
}
{% endhighlight %}

## AppDelegate.swift

Register Swinject container object above in AppDelegate too.
Both the simulator and real instance would not work without using the @objc class func setup() and registration in AppDelegate too.

{% highlight swift %}
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window

        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: GetSwinjectContainer())
        window.rootViewController = storyboard.instantiateInitialViewController()

        //...
        
        return true
    }
    //...
}

{% endhighlight %}
