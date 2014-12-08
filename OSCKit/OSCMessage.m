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

- (NSInteger)estimatedSize {
  NSInteger size = [self.address lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
  
  for (NSObject *arg in self.arguments) {
    if([arg isKindOfClass:[NSString class]]) {
      NSString *string = (NSString*)arg;
      size += [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    } else if([arg isKindOfClass:[NSNumber class]]) {
      size += 4;
    } else {
      [[NSException exceptionWithName:@"OSCProtocolException"
        reason:[NSString stringWithFormat:@"argument is not an int, float, or string"]
        userInfo:nil] raise];
    }
  }
  
  return size;
}

@end
