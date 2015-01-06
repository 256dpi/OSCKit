#import "OSCProtocol.h"
#import "OSCClient.h"

@interface OSCClient ()
@property (strong) GCDAsyncUdpSocket *socket;
@end

@implementation OSCClient

- (id)init {
  self = [super init];
  if(self) {
    self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
  }
  return self;
}

- (void)sendMessage:(OSCMessage *)message to:(NSString *)uri {
  NSURL* url = [NSURL URLWithString:uri];

  [self.socket sendData:[OSCProtocol packMessage:message]
                 toHost:url.host
                   port:[url.port intValue]
            withTimeout:-1
                    tag:0];
}

- (void)dealloc {
  [self.socket close];
}

- (void)sendMessages:(NSArray *)messages to:(NSString *)uri {
  NSURL* url = [NSURL URLWithString:uri];
  
  [self.socket sendData:[OSCProtocol packMessages:messages]
                 toHost:url.host
                   port:[url.port intValue]
            withTimeout:-1
                    tag:0];
}

#pragma mark GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
  NSLog(@"[OSCClient] %@", error);
}

@end
