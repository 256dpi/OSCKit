#import <Foundation/Foundation.h>

#import "OSCMessage.h"

@interface OSCProtocol : NSObject

+ (NSData*)packMessage:(OSCMessage*)message;
+ (OSCMessage*)unpackMessage:(NSData*)data;

@end
