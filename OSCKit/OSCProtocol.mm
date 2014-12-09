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

+ (OSCMessage*)unpackMessage:(NSData*)data {
  osc::osc_bundle_element_size_t length = (int)[data length];
  const char *c_data = (char *)[data bytes];
  osc::ReceivedPacket p(c_data, length);

  if (p.IsBundle()) {
    // do nothing :(
  } else {
    NSString *address = nil;
    NSMutableArray *arguments = [NSMutableArray array];
    osc::ReceivedMessage m_in(p);

    address = [NSString stringWithUTF8String:m_in.AddressPattern()];
      
    for (osc::ReceivedMessage::const_iterator arg = m_in.ArgumentsBegin(); arg != m_in.ArgumentsEnd(); ++arg) {
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

  return nil;
}

@end
