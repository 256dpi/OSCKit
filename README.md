# OSCKit

**objc OSC protocol implementation**

[![Version](https://img.shields.io/cocoapods/v/OSCKit.svg?style=flat)](http://cocoadocs.org/docsets/OSCKit)
[![License](https://img.shields.io/cocoapods/l/OSCKit.svg?style=flat)](http://cocoadocs.org/docsets/OSCKit)
[![Platform](https://img.shields.io/cocoapods/p/OSCKit.svg?style=flat)](http://cocoadocs.org/docsets/OSCKit)

## Installation

OSCKit is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'OSCKit'
```

Then import it and use it:

```objc
#import <OSCKit/OSCKit.h>
```
    
## Usage

**Receiving messages:**

```objc
OSCServer *server = [[OSCServer alloc] init];
server.delegate = self;
[server listen:8000];
```

```objc
- (void)handleMessage:(OSCMessage*)message {
  // do something with the message
}
```

Bundles are handled by the server automatically and delegated using the same callback.

**Sending messages:**

```objc
OSCClient *client = [[OSCClient alloc] init];

OSCMessage *message = [OSCMessage to:@"/hello" with:@[@1, @"cool", @0.5f]]
[client sendMessage:message to:@"udp://localhost:8000"];
```

**Sending bundles:**

```objc
OSCClient *client = [[OSCClient alloc] init];

OSCMessage *message1 = [OSCMessage to:@"/hello" with:@[@1, @"cool", @0.5f]]
OSCMessage *message2 = [OSCMessage to:@"/world" with:@[@"crazy", @876]]
[client sendMessages:@[message1, message2] to:@"udp://localhost:8000"];
```

## Author

Joël Gähwiler, joel.gaehwiler@gmail.com

## License

OSCKit is available under the MIT license. See the LICENSE file for more info.

## Credits

- @heisters: Source code taken from his [repository](https://github.com/heisters/iOS-oscpack) to bootstrap development.
- @codeflows: Thanks for the pull requests, testings and improvements.
