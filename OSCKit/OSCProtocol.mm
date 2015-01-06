#include "oscpack/OscOutboundPacketStream.h"
#include "oscpack/OscReceivedElements.h"

#import "OSCProtocol.h"

@implementation OSCProtocol

+ (NSData *)packMessage:(OSCMessage *)message {
  NSInteger bufferSize = 512 + message.estimatedSize;

  char * buffer = (char*)malloc(bufferSize * sizeof(char));

  osc::OutboundPacketStream packet(buffer, bufferSize);
  packet << osc::BeginMessage([message.address UTF8String]);

  for (NSObject *arg in message.arguments) {
    if([arg isKindOfClass:[NSString class]]) {
      NSString *string = (NSString*)arg;
      const char * stringValue = [string cStringUsingEncoding:NSUTF8StringEncoding];
      packet << stringValue;
    } else if([arg isKindOfClass:[NSNumber class]]) {
      NSNumber *number = (NSNumber*)arg;
      if(CFNumberIsFloatType((CFNumberRef)number)) {
        Float32 floatValue = [number floatValue];
        packet << floatValue;
      } else {
        SInt32 integerValue = [number intValue];
        packet << integerValue;
      }
    } else {
      [[NSException exceptionWithName:@"OSCProtocolException"
        reason:[NSString stringWithFormat:@"argument is not an int, float, or string"]
        userInfo:nil] raise];
    }
  }

  packet << osc::EndMessage;
  
  NSData *data = [NSData dataWithBytes:packet.Data() length:packet.Size()];
  
  free(buffer);

  return data;
}

+ (OSCMessage*)convertMessage:(const osc::ReceivedMessage&)message {
  NSString *address = nil;
  NSMutableArray *arguments = [NSMutableArray array];

  address = [NSString stringWithUTF8String:message.AddressPattern()];

  for (osc::ReceivedMessage::const_iterator arg = message.ArgumentsBegin(); arg != message.ArgumentsEnd(); ++arg) {
    if (arg->IsInt32()) {
      [arguments addObject:@(arg->AsInt32Unchecked())];
    } else if (arg->IsFloat()) {
      [arguments addObject:@(arg->AsFloatUnchecked())];
    } else if (arg->IsString()) {
      [arguments addObject:[NSString stringWithUTF8String:arg->AsStringUnchecked()]];
    } else {
      [[NSException exceptionWithName:@"OSCProtocolException"
                               reason:@"argument is not an int, float, or string"
                             userInfo:nil] raise];
    }
  }

  return [[OSCMessage alloc] initWithAddress:address arguments:arguments];
}

+ (void)unpackBundle:(const osc::ReceivedBundle&)bundle withCallback:(OSCMessageCallback)callback {
  for (osc::ReceivedBundle::const_iterator i = bundle.ElementsBegin();
       i != bundle.ElementsEnd(); ++i) {
    if (i->IsBundle()) {
      osc::ReceivedBundle bundledBundle(*i);
      [self unpackBundle:bundledBundle withCallback:callback];
    } else {
      osc::ReceivedMessage bundledMessage(*i);
      callback([self convertMessage:bundledMessage]);
    }
  }
}

+ (void)unpackMessages:(NSData*)data withCallback:(OSCMessageCallback)callback {
  osc::osc_bundle_element_size_t length = (int)[data length];
  const char *c_data = (char *)[data bytes];
  osc::ReceivedPacket p(c_data, length);

  if (p.IsBundle()) {
    osc::ReceivedBundle bundle(p);
    [self unpackBundle:bundle withCallback:callback];
  } else {
    osc::ReceivedMessage message(p);
    callback([self convertMessage:message]);
  }
}

@end
