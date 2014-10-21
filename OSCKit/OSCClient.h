#import <Foundation/Foundation.h>
#import <GCDAsyncUdpSocket.h>

#import "OSCMessage.h"
#import "OSCBundle.h"

@interface OSCClient : NSObject <GCDAsyncUdpSocketDelegate>

- (void)sendMessage:(OSCMessage*)message to:(NSString*)uri;
- (void)sendBundle:(OSCBundle*)bundle to:(NSString*)uri;

@end
