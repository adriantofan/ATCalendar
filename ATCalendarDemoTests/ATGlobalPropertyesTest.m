//
//  ATGlobalPropertyesTest.m
//  ATCalendar
//
//  Created by Adrian Tofan on 14/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATGlobalPropertyesTest.h"
#import "ATGlobalPropertyes.h"


@implementation ATGlobalPropertyesTest

-(void)testThatEmptyDatabaseHasEmptyLastCacheDay{
  STAssertNil([ATGlobalPropertyes lastCachedDay], @"Empty store should start with empty db");
}
-(void)testThatLastCacheDaysCanBeSavedAndLoaded{
  NSDate* now = [NSDate date];
  [ATGlobalPropertyes setLastCachedDay:now];
  NSDate* lastCache = [ATGlobalPropertyes lastCachedDay];
  STAssertEqualObjects(now, lastCache, @"the saved and loaded date should be identical");
}
@end
