//
//  ATEventTest.m
//  ATCalendar
//
//  Created by Adrian Tofan on 15/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "ATCoreDataTest.h"
#define HC_SHORTHAND
#import "OCHamcrest.h"
#import "ATEvent.h"
#import "ATOccurrenceCache.h"

@interface ATEventTest: ATCoreDataTest {
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
  // -1    now  +1   +2
  a_ = [now oneDayPrevious];
  b_ = now;
  c_ = [now oneDayNext];
  d_ = [c_ oneDayNext];
}
-(void)testUpdateOccurencesFromDateToDate{
  NSDate* today = [NSDate date];
  NSDate* a = [today dateDaysBefore:3];
  NSDate* b = [today dateDaysBefore:2];
  NSDate* c = [today dateDaysBefore:1];
  NSDate* d = today;
//  NSDate* e = [today dateDaysAfter:1];
  NSDate* f = [today dateDaysAfter:2];
  //        syncStart x1 syncEnds
  //    xxxxx xxxxx xxxxx xxxxx  xxxxx   xxxxx
  //     -3    -2    -1     0      +1     +2
  //      A     B     C     D       E      F
  NSDate* syncStart = [b startOfCurrentDay];
  NSDate* syncEnds  = [d startOfCurrentDay];
  ATOccurrenceCache* occurence;
  ATEvent *insideSync = [ATEvent MR_createEntity]; // AC
  ATEvent *containsSync = [ATEvent MR_createEntity]; // AA
  ATEvent *outsideSync = [ATEvent MR_createEntity]; // EE
  insideSync.startDate = c;
  insideSync.endDate = d;
  containsSync.startDate = a;
  containsSync.endDate = f;
  outsideSync.startDate = f;
  outsideSync.endDate = f;
  [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];

  [insideSync updateOccurencesFrom:syncStart to:syncEnds];
  [containsSync updateOccurencesFrom:syncStart to:syncEnds];
  [outsideSync updateOccurencesFrom:syncStart to:syncEnds];

  NSArray* occurences = [ATOccurrenceCache MR_findAllSortedBy:@"day" ascending:YES];
  NSArray * occurencesOfoutsideSync = [occurences reject:^BOOL(ATOccurrenceCache* obj) {
    return obj.event != outsideSync;
  }];
  assertThat(occurencesOfoutsideSync,hasCountOf(0));
  NSArray * occurencesOFinsideSync = [occurences reject:^BOOL(ATOccurrenceCache* obj) {
    return obj.event != insideSync;
  }];
  assertThat(occurencesOFinsideSync,hasCountOf(2));
  occurence = [occurencesOFinsideSync objectAtIndex:0];
  assertThat(occurence.event,is(insideSync));
  assertThat(occurence.day,is([insideSync.startDate startOfCurrentDay]));
  assertThat(occurence.occurrenceDate,is(insideSync.startDate));
  assertThat(occurence.occurrenceEnd,is([insideSync.startDate endOfCurrentDay]));
  occurence = [occurencesOFinsideSync objectAtIndex:1];
  assertThat(occurence.event,is(insideSync));
  assertThat(occurence.day,is([insideSync.endDate startOfCurrentDay]));
  assertThat(occurence.occurrenceDate,is([insideSync.endDate startOfCurrentDay]));
  assertThat(occurence.occurrenceEnd,is(insideSync.endDate));
  NSArray * occurencesOFcontainsSync = [occurences reject:^BOOL(ATOccurrenceCache* obj) {
    return obj.event != containsSync;
  }];
  assertThat(occurencesOFcontainsSync,hasCountOf(3));
  occurence = [occurencesOFcontainsSync objectAtIndex:0];
  assertThat(occurence.event,is(containsSync));
  assertThat(occurence.day,is([b startOfCurrentDay]));
  assertThat(occurence.occurrenceDate,is([b startOfCurrentDay]));
  assertThat(occurence.occurrenceEnd,is([b  endOfCurrentDay]));
  occurence = [occurencesOFcontainsSync objectAtIndex:1];
  assertThat(occurence.event,is(containsSync));
  assertThat(occurence.day,is([c startOfCurrentDay]));
  assertThat(occurence.occurrenceDate,is([c startOfCurrentDay]));
  assertThat(occurence.occurrenceEnd,is([c  endOfCurrentDay]));
  occurence = [occurencesOFcontainsSync objectAtIndex:2];
  assertThat(occurence.event,is(containsSync));
  assertThat(occurence.day,is([d startOfCurrentDay]));
  assertThat(occurence.occurrenceDate,is([d startOfCurrentDay]));
  assertThat(occurence.occurrenceEnd,is([d endOfCurrentDay]));

}

-(void)testStartDateForDate{
  ATEvent *event = [ATEvent MR_createEntity];
  event.startDate = b_; // first
  event.endDate = [c_ dateMinutesAfter:30];
  assertThat([event startDateForDate:nil],nilValue());
  assertThat([event startDateForDate:a_],nilValue());
  assertThat([event startDateForDate:[d_ startOfCurrentDay]],nilValue());
  assertThat([event startDateForDate:[b_ startOfCurrentDay]],is(event.startDate));
  assertThat([event startDateForDate:[c_ endOfCurrentDay]],is([c_ startOfCurrentDay]));
}

-(void)testMatchingDatesFromDateToDate{
  ATEvent *event = [ATEvent MR_createEntity];
  event.startDate = b_;
  event.endDate = c_;
  assertThat([event matchingDates:a_ to:a_],hasCountOf(0));
  assertThat([event matchingDates:d_ to:d_],hasCountOf(0));
  assertThat([event matchingDates:a_ to:d_]
             ,contains([b_ startOfCurrentDay],[c_ startOfCurrentDay],nil));
  assertThat([event matchingDates:a_ to:c_]
             ,contains([b_ startOfCurrentDay],[c_ startOfCurrentDay],nil));
  assertThat([event matchingDates:a_ to:b_]
             ,contains([b_ startOfCurrentDay],nil));
  assertThat([event matchingDates:b_ to:d_]
             ,contains([b_ startOfCurrentDay],[c_ startOfCurrentDay],nil));
  assertThat([event matchingDates:c_ to:d_]
             ,contains([c_ startOfCurrentDay],nil));
  assertThat([event matchingDates:c_ to:c_]
             ,contains([c_ startOfCurrentDay],nil));
}

-(void)testEndDateForDate{
  ATEvent *event = [ATEvent MR_createEntity];
  event.startDate = b_; // first
  event.endDate = [c_ dateMinutesAfter:30];
  assertThat([event endDateForDate:nil],nilValue());
  assertThat([event endDateForDate:a_],nilValue());
  assertThat([event endDateForDate:b_],is([b_ endOfCurrentDay]));
  assertThat([event endDateForDate:[c_ endOfCurrentDay]],is(event.endDate));
  assertThat([event endDateForDate:d_],nilValue());

}

-(void)testAllEventsFromDateToEndDate{
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
  ATEvent *eventContainingInteval = [ATEvent MR_createEntity];
  eventContainingInteval.startDate = a_; // third
  eventContainingInteval.endDate = d_;
  [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
  NSArray *events = [ATEvent allEventsFrom:[b_ startOfCurrentDay] to:[b_ endOfCurrentDay]];
  assertThat(events,hasCountOf(4));
  STFail(@"Test that reccurent elements are exluded");
}

@end
