//
//  RSDispatchSpecificTests.m
//  RSFoundationUtils
//
//  Created by rishat on 24.07.15.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "RSGCDUtils.h"

@interface RSDispatchSpecificTests : XCTestCase

@end

@implementation RSDispatchSpecificTests

- (void)testDispatchSpecific {
    BOOL __block ok = NO;
    dispatch_queue_t queue = rs_dispatch_specific_queue_create(NULL, DISPATCH_QUEUE_SERIAL);

    dispatch_sync(queue, ^{
        rs_dispatch_specific_sync(queue, ^{
            ok = YES;
        });
    });

    XCTAssertTrue(ok);
}

@end
