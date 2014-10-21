#import "OSCMessage.h"

@implementation OSCMessage

+ (OSCMessage *)to:(NSString *)address with:(NSArray *)arguments {
  return [[OSCMessage alloc] initWithAddress:address arguments:arguments];
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
