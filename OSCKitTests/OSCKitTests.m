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
  OSCMessage* message1 = [OSCMessage to:@"/hello" with:@[@1, @524543432, @3.2f, @"hello"]];
  OSCMessage* message2 = [OSCProtocol unpackMessage:[OSCProtocol packMessage:message1]];
  
  XCTAssert([message1.address isEqualToString:message2.address]);
  
  NSNumber *arg1 = message2.arguments[0];
  NSNumber *arg2 = message2.arguments[1];
  NSNumber *arg3 = message2.arguments[2];
  NSString *arg4 = message2.arguments[3];

  XCTAssert([arg1 isEqualTo:@1]);
  XCTAssert([arg2 isEqualTo:@524543432]);
  XCTAssert([arg3 isEqualTo:@3.2f]);
  XCTAssert([arg4 isEqualToString:@"hello"]);
}

- (void)testAllocation {
  NSMutableArray *array = [NSMutableArray array];
  
  for(int i=0; i < 255; i++) {
    [array addObject:@"test!"];
  }
  
  OSCMessage *message = [OSCMessage to:@"/test" with:array];
  NSData *data = [OSCProtocol packMessage:message];
  XCTAssertEqual(data.length, message.estimatedSize);
}

- (void)testJSON {
  NSArray *array = [NSJSONSerialization JSONObjectWithData:[NSJSONSerialization dataWithJSONObject:@[@1, @2.5f, @"hello"] options:0 error:nil] options:0 error:nil];
  [OSCMessage to:@"/hello" with:array];
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
