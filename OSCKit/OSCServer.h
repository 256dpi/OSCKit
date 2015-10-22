#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncUdpSocket.h>

#import "OSCMessage.h"

@protocol OSCServerDelegate <NSObject>

- (void)handleMessage:(OSCMessage*)message;

@end

@interface OSCServer : NSObject <GCDAsyncUdpSocketDelegate>

@property (strong) id <OSCServerDelegate> delegate;

- (void)listen:(NSInteger)port;
- (void)stop;

@end
