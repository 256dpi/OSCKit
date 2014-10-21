#import "OSCBridge.h"

@implementation OSCBridge

+ (BOOL)value:(NSValue *)value isOSCPackType:(const char *)type {
  return strcmp(value.objCType, type) == 0;
}

+ (OSCInteger)integerFromValue:(NSValue *)value {
  OSCInteger i;
  [value getValue:&i];
  return i;
}

+ (OSCInteger)floatFromValue:(NSValue *)value {
  OSCFloat f;
  [value getValue:&f];
  return f;
}

+ (OSCString)stringFromValue:(NSValue *)value {
  OSCString s;
  [value getValue:&s];
  return s;
}

@end