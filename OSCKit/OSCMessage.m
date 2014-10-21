#import "OSCMessage.h"

@implementation OSCMessage

+ (OSCMessage *)to:(NSString *)address with:(NSArray *)arguments {
  OSCMessageBuilder *builder = [OSCMessageBuilder buildMessageTo:address];
  for (NSObject *obj in arguments) {
    [builder add:obj];
  }
  return [builder build];
}

- (id)initWithAddress:(NSString *)address arguments:(NSArray *)arguments {
  self = [self init];
  
  if(self) {
    self.address = address;
    self.arguments = arguments;
  }

  return self;
}

@end
