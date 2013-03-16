//
//  ATCalendar - ATRecurrenceTest.m
//  Copyright 2013 Adrian Tofan. All rights reserved.
//
//  Created by: Adrian Tofan
//

#import "ATRecurrence.h"
#import "ATCoreDataTest.h"
#define HC_SHORTHAND
#import "OCHamcrest.h"

#import "ATDailyRecurrence.h"
#import "ATOccurrenceCache.h"
#import "ATEvent.h"



@interface ATRecurrenceTest : ATCoreDataTest
@end

@implementation ATRecurrenceTest{
  NSDate* a_;
  NSDate* b_;
  NSDate* c_;
  NSDate* d_;
}

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

-(void)testUpdateOccurencesFromTo{
  NSDate* d0 = [NSDate date];
  NSDate* d1 = [d0 dateDaysAfter:1];
  NSDate* d2 = [d0 dateDaysAfter:2];
  NSDate* d3 = [d0 dateDaysAfter:3];
  //   d0 d1 d2 d3
  //   s1 o1 e1            <- first occurence
  //      s2 o2 e2         <- seccond occurence
  //         s3 o3         <- third occurence
  //            s4         <- forth occurence
  ATEvent* event = [ATEvent MR_createEntity];
  event.startDate = d0;
  event.endDate = d2;
  ATRecurrence *rec = [ATDailyRecurrence MR_createEntity];
  rec.startDate = d0;
  rec.endDate = d3;
  rec.event = event;
  NSInteger offset = 1;
  [rec updateOccurencesFrom:[d0 startOfCurrentDay] to:[d3 endOfCurrentDay]];
  [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
  NSArray* ocs = [ATOccurrenceCache MR_findAllSortedBy:@"day" ascending:YES];
  assertThat(ocs,hasCountOf(9));
  ocs = [ATOccurrenceCache MR_findByAttribute:@"occurrenceDate" withValue:d0 andOrderBy:@"day" ascending:YES];
  assertThat(ocs,hasCountOf(3));
  ocs = [ATOccurrenceCache MR_findByAttribute:@"occurrenceDate" withValue:d1 andOrderBy:@"day" ascending:YES];
  ATOccurrenceCache* o = [ocs objectAtIndex:0];
  assertThat(o.day,is([d1 startOfCurrentDay]));
  assertThat(o.occurrenceDate,is([event.startDate dateDaysAfter:offset]));
  assertThat(o.startDate,is(d1));
  assertThat(o.endDate,is([d1 endOfCurrentDay]));
  o = [ocs objectAtIndex:1];
  assertThat(o.day,is([d2 startOfCurrentDay]));
  assertThat(o.occurrenceDate,is([event.startDate dateDaysAfter:offset]));
  assertThat(o.startDate,is([d2 startOfCurrentDay]));
  assertThat(o.endDate,is([d2 endOfCurrentDay]));
  o = [ocs objectAtIndex:2];
  assertThat(o.day,is([d3 startOfCurrentDay]));
  assertThat(o.occurrenceDate,is([event.startDate dateDaysAfter:offset]));
  assertThat(o.startDate,is([d3 startOfCurrentDay]));
  assertThat(o.endDate,is([event.endDate dateDaysAfter:offset]));
  assertThat(ocs,hasCountOf(3));
  ocs = [ATOccurrenceCache MR_findByAttribute:@"occurrenceDate" withValue:d2 andOrderBy:@"day" ascending:YES];
  assertThat(ocs,hasCountOf(2));
  ocs = [ATOccurrenceCache MR_findByAttribute:@"occurrenceDate" withValue:d3 andOrderBy:@"day" ascending:YES];
  assertThat(ocs,hasCountOf(1));
}

// does not take in to consideration edge tests
// it relies on ATEvent matchingDates:to:offest: and ATReccurence matchingDates:to:
-(void)testmatchingDatesFromDateToEndDate{
  ATEvent* event = [ATEvent MR_createEntity];
  event.startDate = a_;
  event.endDate = b_;
  ATRecurrence *rec = [ATDailyRecurrence MR_createEntity];
  rec.startDate = a_;
  rec.endDate = c_;
  rec.event = event;
  NSDictionary* matchSets = [rec matchingDateSets:[a_ startOfCurrentDay] to:[c_ endOfCurrentDay]];
  assertThat([matchSets allKeys], hasCountOf(3));
  NSArray* matches = [matchSets objectForKey:@0];
  assertThat(matches,contains([a_ startOfCurrentDay],[b_ startOfCurrentDay],nil));
  matches = [matchSets objectForKey:@1];
  assertThat(matches,contains([b_ startOfCurrentDay],[c_ startOfCurrentDay],nil));
  matches = [matchSets objectForKey:@2];
  assertThat(matches,contains([c_ startOfCurrentDay],nil));
}

-(void)testMatchingStartDatesFromDateToDate_SyncOutsideReccurenceOnTheLeft_EndsSameDaySyncStart{
  NSDate*eventStart = [[a_ startOfCurrentDay] dateHoursAfter:10];
  NSDate*eventEnd = [[eventStart dateHoursAfter:1] dateHoursAfter:1]; // two day event
  NSDate*syncStart = [eventEnd dateHoursAfter:1];
  NSDate*syncEnd = [syncStart dateDaysAfter:1]; 
  ATEvent* event = [ATEvent MR_createEntity];
  event.startDate = eventStart;
  event.endDate = eventEnd;
  ATRecurrence *rec = [ATDailyRecurrence MR_createEntity];
  rec.startDate = [eventStart startOfCurrentDay];
  rec.endDate = [eventEnd endOfCurrentDay];
  rec.event = event;
  NSArray* result = [rec matchingStartDates:syncStart to:syncEnd];
  assertThat(result,hasCountOf(0));
}


-(void)testMatchingStartDatesFromDateToDate_SyncOverlapingReccurenceRight{
  ATEvent* event = [ATEvent MR_createEntity];
  event.startDate = a_;
  event.endDate = a_;
  ATRecurrence *rec = [ATDailyRecurrence MR_createEntity];
  rec.startDate = a_;
  rec.endDate = c_;
  rec.event = event;
  NSArray* result = [rec matchingStartDates:[b_ startOfCurrentDay] to:[d_ endOfCurrentDay]];
  assertThat(result,hasCountOf(2));
  assertThat(result,contains(b_,[b_ dateDaysAfter:1],nil));
  event.startDate = a_;
  event.endDate = b_;
  result = [rec matchingStartDates:[b_ startOfCurrentDay] to:[d_ endOfCurrentDay]];
  assertThat(result,hasCountOf(2));
  assertThat(result,contains(b_,[b_ dateDaysAfter:1],nil));
}


-(void)testMatchingStartDatesFromDateToDate_SyncOverlapingReccurenceLeft{
  ATEvent* event = [ATEvent MR_createEntity];
  event.startDate = b_;
  event.endDate = b_;
  ATRecurrence *rec = [ATDailyRecurrence MR_createEntity];
  rec.startDate = b_;
  rec.endDate = d_;
  rec.event = event;
  NSArray* result = [rec matchingStartDates:[a_ startOfCurrentDay] to:[c_ endOfCurrentDay]];
  assertThat(result,hasCountOf(2));
  assertThat(result,contains(b_,[b_ dateDaysAfter:1],nil));  
  event.startDate = b_;
  event.endDate = c_;
  result = [rec matchingStartDates:[a_ startOfCurrentDay] to:[c_ endOfCurrentDay]];
  assertThat(result,hasCountOf(2));
  assertThat(result,contains(b_,[b_ dateDaysAfter:1],nil));
}

-(void)testMatchingStartDatesFromDateToDate_SyncOutsideReccurenceOnTheLeft{
  ATEvent* event = [ATEvent MR_createEntity];
  event.startDate = a_;
  event.endDate = a_;
  ATRecurrence *rec = [ATDailyRecurrence MR_createEntity];
  rec.startDate = a_;
  rec.endDate = b_;
  rec.event = event;
  NSArray* result = [rec matchingStartDates:[c_ startOfCurrentDay] to:[d_ endOfCurrentDay]];
  assertThat(result,hasCountOf(0));
}

-(void)testMatchingStartDatesFromDateToDate_SyncOutsideReccurenceOnTheRight{
  ATEvent* event = [ATEvent MR_createEntity];
  event.startDate = c_;
  event.endDate = c_;
  ATRecurrence *rec = [ATDailyRecurrence MR_createEntity];
  rec.startDate = c_;
  rec.endDate = d_;
  rec.event = event;
  NSArray* result = [rec matchingStartDates:[a_ startOfCurrentDay] to:[b_ endOfCurrentDay]];
  assertThat(result,hasCountOf(0));
}


-(void)testMatchingStartDatesFromDateToDate_SyncOverlappsReccurence{
  ATEvent* event = [ATEvent MR_createEntity];
  event.startDate = a_;
  event.endDate = b_;
  ATRecurrence *rec = [ATDailyRecurrence MR_createEntity];
  rec.startDate = a_;
  rec.endDate = d_;
  rec.event = event;
  NSArray* result = [rec matchingStartDates:[a_ startOfCurrentDay] to:[d_ endOfCurrentDay]];
  assertThat(result,hasCountOf(4));
  assertThat(result,contains(a_,[a_ dateDaysAfter:1],[a_ dateDaysAfter:2],[a_ dateDaysAfter:3],nil));
}

-(void)testMatchingStartDatesFromDateToDate_SyncContainedInReccurence{
  ATEvent* event = [ATEvent MR_createEntity];
  event.startDate = a_;
  event.endDate = a_;
  ATRecurrence *rec = [ATDailyRecurrence MR_createEntity];
  rec.startDate = a_;
  rec.endDate = d_;
  rec.event = event;
  NSArray* result = [rec matchingStartDates:[a_ startOfCurrentDay] to:[d_ endOfCurrentDay]];
  assertThat(result,hasCountOf(4));
  assertThat(result,contains(a_,[a_ dateDaysAfter:1],[a_ dateDaysAfter:2],[a_ dateDaysAfter:3],nil));
  rec.endDate = nil; // infinite recurrence
  assertThat(result,hasCountOf(4));
  assertThat(result,contains(a_,[a_ dateDaysAfter:1],[a_ dateDaysAfter:2],[a_ dateDaysAfter:3],nil));
  rec.endDate = d_;
  event.startDate = a_;
  event.endDate = b_;
  result = [rec matchingStartDates:[a_ startOfCurrentDay] to:[c_ endOfCurrentDay]];
  assertThat(result,hasCountOf(3));
  assertThat(result,contains(a_,[a_ dateDaysAfter:1],[a_ dateDaysAfter:2],nil));
}

-(void)testRecurrencesFromTo{
  ATRecurrence *outsideScope = [ATRecurrence MR_createEntity];
  outsideScope.startDate = d_;
  outsideScope.startDate = [d_ dateMinutesAfter:30];
  ATRecurrence *inInterval = [ATRecurrence MR_createEntity];
  inInterval.startDate = b_; // seccond
  inInterval.endDate = [b_ dateMinutesAfter:30];
  ATRecurrence *endingInInterval = [ATRecurrence MR_createEntity];
  endingInInterval.startDate = a_; // first
  endingInInterval.endDate = [b_ dateMinutesAfter:30];
  ATRecurrence *startingInInteval = [ATRecurrence MR_createEntity];
  startingInInteval.startDate = [b_ dateMinutesAfter:10]; // third
  startingInInteval.endDate = [c_ dateMinutesAfter:30];
  ATRecurrence *containingInteval = [ATRecurrence MR_createEntity];
  containingInteval.startDate = a_; // third
  containingInteval.endDate = d_;
  [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
  NSArray *reccs = [ATRecurrence recurrencesFrom:[b_ startOfCurrentDay] to:[b_ endOfCurrentDay]];
  assertThat(reccs,hasCountOf(4));
}
@end
