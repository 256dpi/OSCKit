#import <Foundation/Foundation.h>

#import "OSCMessageBuilder.h"

@interface OSCMessage : NSObject

@property (strong) NSString *address;
@property (strong) NSArray *arguments;

+ (OSCMessage*)to:(NSString*)address with:(NSArray*)arguments;

- (id)initWithAddress:(NSString *)address arguments:(NSArray *)arguments;

@end
