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
  [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
  [MagicalRecord setDefaultModelFromClass:[self class]];
  [MagicalRecord setupCoreDataStackWithStoreNamed:@"unitttest.sqlite"];
}

- (void)tearDown;
{
  NSPersistentStore* pc = [[[NSPersistentStoreCoordinator MR_defaultStoreCoordinator] persistentStores] objectAtIndex:0];
  NSURL* storeURL = pc.URL;
	[MagicalRecord cleanUp];
  [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
  [super tearDown];
}
@end
