# OSCKit

**obj-c OSC protocol implementation**

[![Version](https://img.shields.io/cocoapods/v/OSCKit.svg?style=flat)](http://cocoadocs.org/docsets/OSCKit)
[![License](https://img.shields.io/cocoapods/l/OSCKit.svg?style=flat)](http://cocoadocs.org/docsets/OSCKit)
[![Platform](https://img.shields.io/cocoapods/p/OSCKit.svg?style=flat)](http://cocoadocs.org/docsets/OSCKit)

## Installation

OSCKit is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'OSCKit'
```
    
## Usage

Create a server:

```objc
OSCServer *server = [[OSCServer alloc] init];
server.delegate = self;
[server listen:@"udp://0.0.0.0:8000"];
```

Delegate method:

```objc
- (void)handleMessage:(OSCMessage*)message {
  // do something with the message
}
```

Using the client:

```objc
OSCClient *client = [[OSCClient alloc] init];
[client sendMessage:message to:@"udp://localhost:8000"];
[client sendBundle:bundle to:@"udp://localhost:8000"];
```

## Author

Joël Gähwiler, joel.gaehwiler@gmail.com

## License

OSCKit is available under the MIT license. See the LICENSE file for more info.
