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
#import "ATRecurrence.h"
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
  NSDate* e = [today dateDaysAfter:1];
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

  [insideSync updateSimpleOccurencesFrom:syncStart to:syncEnds inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
  [containsSync updateSimpleOccurencesFrom:syncStart to:syncEnds inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
  [outsideSync updateSimpleOccurencesFrom:syncStart to:syncEnds inContext:[NSManagedObjectContext MR_contextForCurrentThread]];

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
  assertThat(occurence.occurrenceDate,is(occurence.event.startDate));
  assertThat(occurence.day,is([insideSync.startDate startOfCurrentDay]));
  assertThat(occurence.startDate,is(insideSync.startDate));
  assertThat(occurence.endDate,is([insideSync.startDate endOfCurrentDay]));
  occurence = [occurencesOFinsideSync objectAtIndex:1];
  assertThat(occurence.event,is(insideSync));
  assertThat(occurence.occurrenceDate,is(occurence.event.startDate));
  assertThat(occurence.day,is([insideSync.endDate startOfCurrentDay]));
  assertThat(occurence.startDate,is([insideSync.endDate startOfCurrentDay]));
  assertThat(occurence.endDate,is(insideSync.endDate));
  NSArray * occurencesOFcontainsSync = [occurences reject:^BOOL(ATOccurrenceCache* obj) {
    return obj.event != containsSync;
  }];
  assertThat(occurencesOFcontainsSync,hasCountOf(3));
  occurence = [occurencesOFcontainsSync objectAtIndex:0];
  assertThat(occurence.event,is(containsSync));
  assertThat(occurence.occurrenceDate,is(occurence.event.startDate));
  assertThat(occurence.day,is([b startOfCurrentDay]));
  assertThat(occurence.startDate,is([b startOfCurrentDay]));
  assertThat(occurence.endDate,is([b  endOfCurrentDay]));
  occurence = [occurencesOFcontainsSync objectAtIndex:1];
  assertThat(occurence.event,is(containsSync));
  assertThat(occurence.occurrenceDate,is(occurence.event.startDate));
  assertThat(occurence.day,is([c startOfCurrentDay]));
  assertThat(occurence.startDate,is([c startOfCurrentDay]));
  assertThat(occurence.endDate,is([c  endOfCurrentDay]));
  occurence = [occurencesOFcontainsSync objectAtIndex:2];
  assertThat(occurence.event,is(containsSync));
  assertThat(occurence.occurrenceDate,is(occurence.event.startDate));
  assertThat(occurence.day,is([d startOfCurrentDay]));
  assertThat(occurence.startDate,is([d startOfCurrentDay]));
  assertThat(occurence.endDate,is([d endOfCurrentDay]));

}

-(void)testStartDateForDate{
  ATEvent *event = [ATEvent MR_createEntity];
  event.startDate = b_; // first
  event.endDate = [c_ dateMinutesAfter:30];
  assertThat([event eventStartAtDate:nil],nilValue());
  assertThat([event eventStartAtDate:a_],nilValue());
  assertThat([event eventStartAtDate:[d_ startOfCurrentDay]],nilValue());
  assertThat([event eventStartAtDate:[b_ startOfCurrentDay]],is(event.startDate));
  assertThat([event eventStartAtDate:[c_ endOfCurrentDay]],is([c_ startOfCurrentDay]));
  event.startDate = a_; // first
  assertThat([event eventStartAtDate:nil offset:1],nilValue());
  assertThat([event eventStartAtDate:a_ offset:1],nilValue());
  assertThat([event eventStartAtDate:[[d_ dateDaysAfter:1] startOfCurrentDay] offset:1],nilValue());
  assertThat([event eventStartAtDate:[b_ startOfCurrentDay] offset:1],is([event.startDate dateDaysAfter:1]));
  assertThat([event eventStartAtDate:[d_ endOfCurrentDay] offset:1],is([d_ startOfCurrentDay]));
}

-(void)testOffsettingMatchingDatesFromDateToDate{
  ATEvent *event = [ATEvent MR_createEntity];
  event.startDate = a_;
  event.endDate = b_;
  assertThat([event matchingDates:c_ to:d_ offset:0],hasCountOf(0));
  assertThat([event matchingDates:c_ to:d_ offset:2],hasCountOf(2));
}

-(void)testMatchingDatesFromDateToDateOffset{
  NSDate* today = [NSDate date];
  NSDate* a = [today dateDaysBefore:3];
  NSDate* b = [today dateDaysBefore:2];
  NSDate* c = [today dateDaysBefore:1];
  NSDate* d = today;
  NSDate* e = [today dateDaysAfter:1];
  NSDate* f = [today dateDaysAfter:2];
  //           ee    ee    ee+2   ee+2
  //    xxxxx xxxxx xxxxx xxxxx  xxxxx   xxxxx
  //     -3    -2    -1     0      +1     +2
  //      A     B     C     D       E      F

  ATEvent *event = [ATEvent MR_createEntity];
  event.startDate = b;
  event.endDate = c;
  assertThat([event matchingDates:a to:a offset:2],hasCountOf(0));
  assertThat([event matchingDates:f to:f offset:2],hasCountOf(0));
  assertThat([event matchingDates:a to:f offset:2]
             ,contains([d startOfCurrentDay],[e startOfCurrentDay],nil));
  assertThat([event matchingDates:a to:d offset:2]
             ,contains([d startOfCurrentDay],nil));
  assertThat([event matchingDates:d to:e offset:2]
             ,contains([d startOfCurrentDay],[e startOfCurrentDay],nil));
  assertThat([event matchingDates:e to:f offset:2]
             ,contains([e startOfCurrentDay],nil));
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
  assertThat([event eventEndAtDate:nil],nilValue());
  assertThat([event eventEndAtDate:a_],nilValue());
  assertThat([event eventEndAtDate:b_],is([b_ endOfCurrentDay]));
  assertThat([event eventEndAtDate:[c_ endOfCurrentDay]],is(event.endDate));
  assertThat([event eventEndAtDate:d_],nilValue());
  event.startDate = a_;
  assertThat([event eventEndAtDate:nil offset:1],nilValue());
  assertThat([event eventEndAtDate:[a_ oneDayPrevious] offset:1],nilValue());
  assertThat([event eventEndAtDate:b_ offset:1],is([b_ endOfCurrentDay]));
  assertThat([event eventEndAtDate:[d_ endOfCurrentDay] offset:1],is([event.endDate dateDaysAfter:1]));
  assertThat([event eventEndAtDate:[d_ oneDayNext] offset:1],nilValue());


}

-(void)testAllNonRecurringEventsFromDateToEndDateDoesNotReturnRecurring{
  ATEvent *eventInInterval = [ATEvent MR_createEntity];
  eventInInterval.startDate = b_; // seccond
  eventInInterval.endDate = [b_ dateMinutesAfter:30];
  ATRecurrence* reccurence = [ATRecurrence MR_createEntity];
  reccurence.startDate = eventInInterval.startDate;
  reccurence.endDate = eventInInterval.endDate;
  reccurence.event = eventInInterval;
  [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
  NSArray *events = [ATEvent nonRecurringEventsFrom:[a_ startOfCurrentDay] to:[c_ endOfCurrentDay]];
  assertThat(events,hasCountOf(0));
}

-(void)testAllNonRecurringEventsFromDateToEndDate{
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
  NSArray *events = [ATEvent nonRecurringEventsFrom:[b_ startOfCurrentDay] to:[b_ endOfCurrentDay]];
  assertThat(events,hasCountOf(4));
}

@end
