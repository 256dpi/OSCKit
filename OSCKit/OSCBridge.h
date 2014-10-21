#import <Foundation/Foundation.h>

typedef Float32 OSCFloat;
typedef SInt32 OSCInteger;
typedef const char * OSCString;

@interface OSCBridge : NSObject

+ (BOOL)value:(NSValue*)value isOSCPackType:(const char *)type;
+ (OSCInteger)integerFromValue:(NSValue *)value;
+ (OSCInteger)floatFromValue:(NSValue *)value;
+ (OSCString)stringFromValue:(NSValue *)value;

@end
