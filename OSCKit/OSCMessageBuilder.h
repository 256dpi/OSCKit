#import <Foundation/Foundation.h>

#import "OSCBridge.h"

@class OSCMessage;

@interface OSCMessageBuilder : NSObject

@property (strong) NSString *address;
@property (strong) NSMutableArray *arguments;

+ (OSCMessageBuilder *)buildMessageTo:(NSString *)address;

- (OSCMessageBuilder *)add:(NSObject *)obj;
- (OSCMessageBuilder *)addInteger:(OSCInteger)integerValue;
- (OSCMessageBuilder *)addFloat:(OSCFloat)floatValue;
- (OSCMessageBuilder *)addString:(OSCString)stringValue;

- (OSCMessage *)build;

@end
