#import "OSCBridge.h"
#import "OSCMessage.h"

#import "OSCMessageBuilder.h"

@implementation OSCMessageBuilder

+ (OSCMessageBuilder *)buildMessageTo:(NSString *)address {
  OSCMessageBuilder *builder = [[OSCMessageBuilder alloc] init];
  builder.address = address;
  builder.arguments = [NSMutableArray array];
  return builder;
}

- (OSCMessageBuilder *)add:(NSObject *)obj {
  if ([obj isKindOfClass:[NSString class]]) {
    [self addString:[(NSString *)obj UTF8String]];
  } else if ([obj isKindOfClass:[NSValue class]]) {
    NSValue *val = (NSValue *)obj;
    if ([OSCBridge value:val isOSCPackType:"f"]) {
      [self addFloat:[OSCBridge floatFromValue:val]];
    } else if ([OSCBridge value:val isOSCPackType:"i"]) {
      [self addInteger:[OSCBridge integerFromValue:val]];
    } else if ([OSCBridge value:val isOSCPackType:"q"]) {
      [self addInteger:[OSCBridge integerFromValue:val]];
    } else {
      [[NSException
          exceptionWithName:@"OSCArgumentException"
                     reason:[NSString stringWithFormat:
                                          @"argument with encoding %s is not "
                                          @"an int, float, or string",
                                          val.objCType]
                   userInfo:nil] raise];
    }
  } else {
    [[NSException exceptionWithName:@"OSCArgumentException"
                             reason:@"argument is not an int, float, or string"
                           userInfo:nil] raise];
  }

  return self;
}

- (OSCMessageBuilder *)addInteger:(OSCInteger)integerValue {
  [self addArgument:&integerValue objCType:@encode(typeof(integerValue))];
  return self;
}

- (OSCMessageBuilder *)addFloat:(OSCFloat)floatValue {
  [self addArgument:&floatValue objCType:@encode(typeof(floatValue))];
  return self;
}

- (OSCMessageBuilder *)addString:(OSCString)stringValue {
  [self addArgument:&stringValue objCType:@encode(typeof(stringValue))];
  return self;
}

- (void)addArgument:(const void *)arg_p objCType:(const char *)type {
  [self.arguments addObject:[NSValue valueWithBytes:arg_p objCType:type]];
}

- (OSCMessage *)build {
  return [[OSCMessage alloc] initWithAddress:self.address arguments:self.arguments];
}

@end
