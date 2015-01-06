#import "OSCProtocol.h"
#import "OSCServer.h"

@interface OSCServer ()
@property (strong) GCDAsyncUdpSocket *socket;
@end

@implementation OSCServer

- (id)init {
  self = [super init];
  if(self) {
    self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
  }
  return self;
}

- (void)listen:(NSInteger)port {

  NSError *error = nil;
  [self.socket bindToPort:port error:&error];
  
  if (error) {
    [[NSException exceptionWithName:@"OSCProtocolException"
                             reason:[NSString stringWithFormat:@"OSCServer could not bind: %@", error]
                           userInfo:@{@"error":error}] raise];
  } else {
    NSLog(@"[OSCServer] listening on port %li", (long)port);
  }

  error = nil;
  [self.socket beginReceiving:&error];
  
  if (error) {
    [[NSException exceptionWithName:@"OSCProtocolException"
                             reason:[NSString stringWithFormat:@"OSCServer could not start receiving: %@", error]
                           userInfo:@{@"error":error}] raise];
  }
}

- (void)stop {
  [self.socket close];
}

- (void)dealloc {
  if(self.socket) {
    [self.socket close];
  }
}

#pragma mark GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
  [OSCProtocol unpackMessages:data withCallback:^(OSCMessage* message){
    [self.delegate handleMessage:message];
  }];
;
}

@end
