#import <Foundation/Foundation.h>
#import "CocoaAsyncSocket.h"

#import "OSCMessage.h"

@interface OSCClient : NSObject <GCDAsyncUdpSocketDelegate>

- (void)sendMessage:(OSCMessage*)message to:(NSString*)uri;
- (void)sendMessages:(NSArray*)messages to:(NSString*)uri;

@end
