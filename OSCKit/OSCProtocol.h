#import <Foundation/Foundation.h>

#import "OSCMessage.h"

@interface OSCProtocol : NSObject

typedef void (^OSCMessageCallback)(OSCMessage*);

+ (NSData*)packMessage:(OSCMessage*)message;
+ (void)unpackMessages:(NSData*)data withCallback:(OSCMessageCallback)callback;

@end
