//
//  ATCalendarTest.m
//  ATCalendar
//
//  Created by Adrian Tofan on 14/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATCalendarTest.h"
#import "ATCalendar.h"
#import "NSDate+MTDates.h"
#import "ATTimeSpan.h"
#import "ATEvent.h"
#import "ATOccurrenceCache.h"


@implementation ATCalendarTest

-(void)testSyncNonRecurringEventsFrom{
  ATCalendar* cal = [ATCalendar sharedInstance];
  NSDate* today = [NSDate date];
  NSDate* a = [today dateDaysBefore:3];
  NSDate* b = [today dateDaysBefore:2];
  NSDate* c = [today dateDaysBefore:1];
  NSDate* d = today;
  NSDate* e = [today dateDaysAfter:1];
  
  //        syncStart x syncEnds 
  //    xxxxx xxxxx xxxxx xxxxx  xxxxx
  //     -3    -2    -1     0      +1
  //      A     B     C     D       E

  NSDate* syncStart = [[today oneDayPrevious] startOfCurrentDay];
  NSDate* syncEnds = [today endOfCurrentDay];

  ATEvent *endingInSyncIntervalEvent = [ATEvent MR_createEntity]; // AC
//  ATEvent *startingInSyncIntervalEvent = [ATEvent MR_createEntity]; // CE
//  ATEvent *onDayInSyncIntervalEvent = [ATEvent MR_createEntity]; // CC
//  ATEvent *twoDayInSyncIntervalEvent = [ATEvent MR_createEntity]; // CD
//  ATEvent *beforeSyncIntervalEvent = [ATEvent MR_createEntity]; // AA
//  ATEvent *afterSyncIntervalEvent = [ATEvent MR_createEntity]; // EE

  endingInSyncIntervalEvent.startDate = a;
  endingInSyncIntervalEvent.endDate = c;
  STFail(@"Not implemented");return;
  [cal syncNonRecurringEventsFrom:syncStart to:syncEnds];
  NSArray* occurences = [ATOccurrenceCache MR_findAllSortedBy:@"day" ascending:YES];
  STAssertEquals([occurences count], (NSUInteger)2, @"expecting B & C");
  
}

-(void)testThatTimeSpanToSyncFromWorksForEdgeCases{
  ATCalendar* cal = [ATCalendar sharedInstance];
  NSDate* now = [NSDate date];
  ATTimeSpan* result = [cal timeSpanToSyncFrom:nil to:nil];
  STAssertNil(result, @"empty interval expected if from and to date is empty");
  result = [cal timeSpanToSyncFrom:nil to:now];
  STAssertTrue([result.start isEqualToDate:[[now oneYearPrevious] startOfCurrentDay]],@"+1 year should be moring");
  STAssertTrue([result.end isEqualToDate:[[[now oneYearNext] oneYearNext] endOfCurrentDay]],@"+2 year night expected");
  result = [cal timeSpanToSyncFrom:now to:now];
  STAssertNil(result, @"empty interval expected if from and to date is equal");
  NSDate* today = [NSDate date];
  NSDate* yesterday = [today dateDaysBefore:1];
  result = [cal timeSpanToSyncFrom:yesterday to:today];
  STAssertTrue([result.start isEqualToDate:[today startOfCurrentDay]],@"start of today");
  STAssertTrue([result.end isEqualToDate:[today endOfCurrentDay]],@"end of today");

}

-(void)testThatDateArrayToSyncFromReturnsArrayOfDates{
  ATCalendar* cal = [ATCalendar sharedInstance];
  NSDate* today = [NSDate date];
  NSDate* yesterday = [today oneDayPrevious];
  NSDate* beforeYesterday = [yesterday oneDayPrevious];

  NSArray* result = [cal dateArrayToSyncFrom:yesterday
                                          to:today];
  STAssertEquals([result count], (NSUInteger)1 , @"today needs sync");
  STAssertTrue([[result objectAtIndex:0] isWithinSameDay:[today startOfCurrentDay]], @"today should be in the array to sync");
  
  result = [cal dateArrayToSyncFrom:beforeYesterday
                                 to:today];
  STAssertEquals([result count], (NSUInteger)2 , @"today and yesterday needs sync");
}
@end
