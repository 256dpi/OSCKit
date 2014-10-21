#include "oscpack/OscOutboundPacketStream.h"
#include "oscpack/OscReceivedElements.h"

#import "OSCBridge.h"
#import "OSCProtocol.h"

const static int BUFFER_SIZE = 1024 * 1024;

@implementation OSCProtocol

+ (NSData *)packMessage:(OSCMessage *)message {
  char buffer[BUFFER_SIZE];

  osc::OutboundPacketStream packet(buffer, BUFFER_SIZE);
  packet << osc::BeginMessage([message.address UTF8String]);

  for (NSValue *arg in message.arguments) {
    if ([OSCBridge value:arg isOSCPackType:"f"]) {
      packet << [OSCBridge floatFromValue:arg];
    } else if ([OSCBridge value:arg isOSCPackType:"i"]) {
      packet << [OSCBridge integerFromValue:arg];
    } else if([OSCBridge value:arg isOSCPackType:"q"]) {
      packet << [OSCBridge integerFromValue:arg];
    } else if ([OSCBridge value:arg isOSCPackType:"r*"]) {
      packet << [OSCBridge stringFromValue:arg];
    } else {
      [[NSException exceptionWithName:@"OSCArgumentException"
        reason:[NSString stringWithFormat:@"argument with encoding %s is not an int, float, or string", arg.objCType]
        userInfo:nil] raise];
    }
  }

  packet << osc::EndMessage;

  return [NSData dataWithBytes:packet.Data() length:packet.Size()];
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
        [[NSException exceptionWithName:@"OSCMessageReceiveException"
                                 reason:@"message is not an int, float, or string"
                               userInfo:nil] raise];
      }
    }

    return [[OSCMessage alloc] initWithAddress:address arguments:arguments];
  }

  return nil;
}

@end
