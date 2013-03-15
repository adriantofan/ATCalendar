//
//  ATEventTest.m
//  ATCalendar
//
//  Created by Adrian Tofan on 15/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATEventTest.h"
#import "ATEvent.h"

@interface ATEventTest() {
  NSDate* a_;
  NSDate* b_;
  NSDate* c_;
  NSDate* d_;
}
@end

@implementation ATEventTest

-(void)setUp{
  [super setUp];
  NSDate* now = [NSDate date];
  //      event     outscope
  //  A     B    C   D
  a_ = [now oneDayPrevious];
  b_ = now;
  c_ = [now oneDayNext];
  d_ = [c_ oneDayNext];
}

-(void)testAllEventsFromDateToEndDateWhenOneEventIsInInterval{
  ATEvent *outsideScopeEvent = [ATEvent MR_createEntity];
  outsideScopeEvent.startDate = d_;
  outsideScopeEvent.startDate = [d_ dateMinutesAfter:30];
  ATEvent *eventInInterval = [ATEvent MR_createEntity];
  eventInInterval.startDate = b_; // seccond
  eventInInterval.endDate = [b_ dateMinutesAfter:30];
  ATEvent *eventEndingInInterval = [ATEvent MR_createEntity];
  eventEndingInInterval.startDate = a_; // first
  eventEndingInInterval.endDate = [b_ dateMinutesAfter:30];
  ATEvent *eventStartingInInteval = [ATEvent MR_createEntity];
  eventStartingInInteval.startDate = [b_ dateMinutesAfter:10]; // third
  eventStartingInInteval.endDate = [c_ dateMinutesAfter:30];
  
  [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
  NSArray *events = [ATEvent allEventsFrom:[b_ startOfCurrentDay] to:[b_ endOfCurrentDay]];
  STAssertEquals([events count], (NSUInteger)3, @"event count should be 3");
  STAssertEquals(eventInInterval, [events objectAtIndex:1], @"expecting  eventInInterval");
  STAssertEquals(eventEndingInInterval, [events objectAtIndex:0], @"expecting only eventEndingInInterval");
  STAssertEquals(eventStartingInInteval, [events objectAtIndex:2], @"expecting only eventStartingInInteval");


  STFail(@"Test that reccurent elements are exluded");
}

@end
