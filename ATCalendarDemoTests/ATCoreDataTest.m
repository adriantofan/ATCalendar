//
//  ATCoreDataTest.m
//  ATCalendarDemo
//
//  Created by Adrian Tofan on 14/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATCoreDataTest.h"
#import <CoreData/CoreData.h>
@implementation ATCoreDataTest
- (void)setUp;
{
  [super setUp];
	[MagicalRecord setDefaultModelFromClass:[self class]];
	[MagicalRecord setupCoreDataStackWithInMemoryStore];
}

- (void)tearDown;
{
	[MagicalRecord cleanUp];
  [super tearDown];
}
@end
