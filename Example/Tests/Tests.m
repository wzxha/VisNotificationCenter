//
//  Tests.m
//  Tests
//
//  Created by WzxJiang on 17/1/11.
//  Copyright © 2017年 wzxjiang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSNotificationCenter+VisNotificationCenter.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAdd {
    [[NSNotificationCenter vis_defaultCenter] addObserver:self selector:@selector(test) name:@"test" object:nil];
    [[NSNotificationCenter vis_defaultCenter] addObserver:self selector:@selector(test) name:@"test" object:nil];
    [[NSNotificationCenter vis_defaultCenter] addObserver:self selector:@selector(test) name:@"test" object:nil];
    
    XCTAssert([[NSNotificationCenter vis_defaultCenter] vis_mapsWithObject:self].count == 1,
              @"Repeat add observer");
}

- (void)testRemove {
    [[NSNotificationCenter vis_defaultCenter] addObserver:self selector:@selector(test) name:@"test" object:nil];
    [[NSNotificationCenter vis_defaultCenter] removeObserver:self];
    
    XCTAssert([[NSNotificationCenter vis_defaultCenter] vis_mapsWithObject:self].count == 0,
              @"The observer has not been removed");
    
    [[NSNotificationCenter vis_defaultCenter] addObserver:self selector:@selector(test) name:@"test" object:nil];
    [[NSNotificationCenter vis_defaultCenter] removeObserver:self name:@"test" object:nil];
    
    XCTAssert([[NSNotificationCenter vis_defaultCenter] vis_mapsWithObject:self].count == 0,
              @"The observer has not been removed");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
