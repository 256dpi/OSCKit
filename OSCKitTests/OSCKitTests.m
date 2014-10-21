#import <XCTAsyncTestCase/XCTAsyncTestCase.h>

#import "OSCKit.h"
#import "OSCProtocol.h"

@interface OSCKitTests : XCTAsyncTestCase <OSCServerDelegate>
@property (strong, nonatomic, readwrite) OSCServer *server;
@property (strong, nonatomic, readwrite) OSCClient *client;
@property (strong) NSMutableArray *receivedMessages;
@end

@implementation OSCKitTests

- (void)setUp {
  [super setUp];
  
  self.receivedMessages = [NSMutableArray array];
  
  self.server = [[OSCServer alloc] init];
  self.server.delegate = self;
  [self.server listen:5555];
  
  self.client = [[OSCClient alloc] init];
}

- (void)tearDown {
  [self.server stop];
  
  [super tearDown];
}

- (void)handleMessage:(OSCMessage *)message {
  [self.receivedMessages addObject:message];
}

- (void)testPacket {
  OSCMessage* message1 = [OSCMessage to:@"/hello" with:@[@1, @3.2f, @"hello"]];
  OSCMessage* message2 = [OSCProtocol unpackMessage:[OSCProtocol packMessage:message1]];
  
  XCTAssert([message1.address isEqualToString:message2.address]);
  
  NSNumber *arg1 = message2.arguments[0];
  NSNumber *arg2 = message2.arguments[1];
  NSString *arg3 = message2.arguments[2];

  XCTAssert(arg1.intValue == 1);
  XCTAssert(arg2.floatValue == 3);
  XCTAssert([arg3 isEqualToString:@"hello"]);
}

- (void)testRoundtrip {
  [self prepare];

  [self.client sendMessage:[OSCMessage to:@"/hello" with:@[@1]] to:@"udp://0.0.0.0:5555"];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
    sleep(1.0);
    XCTAssert(self.receivedMessages.count == 1);
    [self notify:kXCTUnitWaitStatusSuccess];
  });

  [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:2.0];
}

@end
