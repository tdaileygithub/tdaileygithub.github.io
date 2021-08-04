---
title:  "Promises in Swift"
date:   2021-08-04 00:00:01 -0700
categories: swift
tags: [swift, ios]

---
# Promises in Swift

PromisesSwift from **Google**

- [https://cocoapods.org/pods/PromisesSwift]()

The google man pages are worth a read.

## Cocoa Podfile

{% highlight swift %}
pod 'PromisesSwift'
{% endhighlight %}

{% highlight bash %}
pod install
{% endhighlight %}

## Single Promise

{% highlight swift %}
import Promises

protocol IExampleServiceAsync {
  func getData() -> Promise<[Int]>
}

class ExampleService1 {
}

extension ExampleService1 : IExampleServiceAsync {
  func getData() -> Promise<[Int]> {
    return Promise<[Int]>(on: .main) { fullfill, reject in
      fullfill([10,20,30])
    }
  }
}

var svc1 = ExampleService1()
svc1.getData().then { result in 
  dump(result)
}

{% endhighlight %}

## Chained Promises

{% highlight swift %}
import Promises

protocol IExampleServiceAsync {
  func getData1() -> Promise<[Int]>
  func getData2() -> Promise<[Int]>
  func getAllData() -> Promise<[Int]>
}

class ExampleService1 {
}

class CustomError : Error{
}

extension ExampleService1 : IExampleServiceAsync {
  func getData1() -> Promise<[Int]> {
    return Promise<[Int]>(on: .main) { fullfill, reject in
        fullfill([10,20,30])
        //let e = CustomError()
        //reject(e)
    }
  }
  func getData2() -> Promise<[Int]> {
    return Promise<[Int]>(on: .main) { fullfill, reject in
      fullfill([40,50,60])
    }
  }

  func getAllData() -> Promise<[Int]> {
    return Promise<[Int]>(on: .main) { fullfill, reject in

        all([self.getData1(), self.getData2()]).then { result in
            var ret  = [Int]()
            ret += result.first ?? []
            ret += result.last ?? []
            fullfill(ret)
        }.catch { error in
            print ("error: \(error)")
        }
    }
  }

  var svc1 = ExampleService1()
  svc1.getAllData().then { result in
    print("result: \(result)")
  }

}

{% endhighlight %}