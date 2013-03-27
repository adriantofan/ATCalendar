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
#import "ATAlertNotification.h"



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

-(void)testUpdateOccurencesFromWhenEndOfIntervalIsAfterRecurenceEnd{
  NSDate *d0 = [NSDate date];
  NSDate *d1 = [d0 dateMonthsAfter:1];
  NSDate *d2 = [d0 dateMonthsAfter:2];
  NSManagedObjectContext *moc = [NSManagedObjectContext MR_contextForCurrentThread];
  ATEvent* reOustide = [ATEvent MR_createEntity];
  reOustide.startDate = d0;
  reOustide.endDate = d1;
  ATRecurrence* rOutside = [ATDailyRecurrence MR_createEntity];
  rOutside.startDate = d0;
  rOutside.endDate = d2;
  rOutside.event = reOustide;
  [rOutside updateOccurencesFrom:d0 to:[d0 dateYearsAfter:2] inContext:moc];
  [moc MR_saveToPersistentStoreAndWait];
  NSArray* ocs = [ATOccurrenceCache MR_findAllSortedBy:@"day" ascending:YES];
  NSArray* ocDays = [ocs filter:^BOOL(ATOccurrenceCache* obj) {
    return [[obj day] isAfter:d2];
  }];
  assertThat(ocDays,hasCountOf(0));

}

-(void)testEventsScheduledAfterCornerCasesNonRecurring{
  NSDate *d0 = [NSDate date];
  NSDate *d1 = [d0 dateMonthsAfter:1];
  NSDate *d2 = [d0 dateMonthsAfter:2];
  NSDate *d3 = [d0 dateMonthsAfter:3];
  NSDate *d4 = [d0 dateMonthsAfter:4];
  NSDate *d5 = [d0 dateMonthsAfter:5];
  NSManagedObjectContext *moc = [NSManagedObjectContext MR_contextForCurrentThread];
  
  ATEvent* nreOustide = [ATEvent MR_createEntity];
  nreOustide.firstAlertTypeValue = 1;
  nreOustide.startDate = d0;
  nreOustide.endDate = d1;
  [nreOustide updateSimpleOccurencesFrom:d0 to:[d0 dateYearsAfter:2] inContext:moc];
  ATEvent* nreOverlap = [ATEvent MR_createEntity];
  nreOverlap.firstAlertTypeValue = 1;
  nreOverlap.startDate = d2;
  nreOverlap.endDate = d4;
  [nreOverlap updateSimpleOccurencesFrom:d0 to:[d0 dateYearsAfter:2] inContext:moc];
  ATEvent* nreInside = [ATEvent MR_createEntity];
  nreInside.firstAlertTypeValue = 1;
  nreInside.startDate = d4;
  nreInside.endDate = d5;
  [nreInside updateSimpleOccurencesFrom:d0 to:[d0 dateYearsAfter:2] inContext:moc];
  
  
  ATEvent* reOustide = [ATEvent MR_createEntity];
  reOustide.firstAlertTypeValue = 1;
  reOustide.startDate = d0;
  reOustide.endDate = d1;
  ATRecurrence* rOutside = [ATDailyRecurrence MR_createEntity];
  rOutside.startDate = d0;
  rOutside.endDate = d2;
  rOutside.event = reOustide;
  [rOutside updateOccurencesFrom:d0 to:[d0 dateYearsAfter:2] inContext:moc];
  
  ATEvent* reOverlap = [ATEvent MR_createEntity];
  reOverlap.firstAlertTypeValue = 1;
  reOverlap.startDate = d1;
  reOverlap.endDate = d1;
  ATRecurrence* rOverlap = [ATDailyRecurrence MR_createEntity];
  rOverlap.startDate = d1;
  rOverlap.endDate = d4;
  rOverlap.event = reOverlap;
  [rOverlap updateOccurencesFrom:d0 to:[d0 dateYearsAfter:2] inContext:moc];
  
  ATEvent* reInside = [ATEvent MR_createEntity];
  reInside.firstAlertTypeValue = 1;
  reInside.startDate = d4;
  reInside.endDate = d4;
  ATRecurrence* rInside = [ATDailyRecurrence MR_createEntity];
  rInside.startDate = d4;
  rInside.endDate = d5;
  rInside.event = reInside;
  [rInside updateOccurencesFrom:d0 to:[d0 dateYearsAfter:2] inContext:moc];
  
  [moc MR_saveToPersistentStoreAndWait];
  NSLog(@"time :%f",[d3 timeIntervalSinceReferenceDate]);
  NSArray* ids =[ATOccurrenceCache eventIDsWithAlertAfter:d3 inContext:moc limit:65];
  NSArray* occurences =[ATOccurrenceCache firstOccurenceCacheOfEventIDs:ids after:d3 inContext:moc limit:65];
  NSArray* events = [occurences map:^id(id obj) {
    return [obj event];
  }];
  assertThat(events,hasItems(nreOverlap,nreInside,nil));
  assertThat(events,isNot(hasItems(nreOustide,nil)));
  assertThat(events,hasItems(reOverlap,reInside,nil));
  assertThat(events,isNot(hasItems(reOustide,nil)));
}




-(void)testEventsScheduledAfter{
  NSDate *d2 = [NSDate date];
  NSDate *d1 = [d2 dateMonthsBefore:3];
  NSDate *d0 = [d1 dateMonthsBefore:4];
  
  NSManagedObjectContext *moc = [NSManagedObjectContext MR_contextForCurrentThread];
  ATEvent* event1 = [ATEvent MR_createEntity];
  event1.firstAlertTypeValue = 1;
  event1.startDate = d1;
  event1.endDate = d1;
  ATRecurrence *rec = [ATDailyRecurrence MR_createEntity];
  rec.startDate = d1;
  rec.endDate = nil;
  event1.recurence = rec;
  [rec updateOccurencesFrom:d0 to:[d0 dateYearsAfter:2] inContext:moc];
  [moc MR_saveToPersistentStoreAndWait];
  NSArray* results =[ATOccurrenceCache eventIDsWithAlertAfter:d2 inContext:moc limit:65];
  ATEvent *e = (ATEvent *)[moc objectWithID:[results objectAtIndex:0]];
  assertThat(e, is(event1));
  NSArray* os = [ATOccurrenceCache firstOccurenceCacheOfEventIDs:results after:d2 inContext:moc limit:65];
  ATOccurrenceCache* o = [os objectAtIndex:0];
  assertThat(o.event,is(event1));
  assertThat(o.day,is([d2 startOfCurrentDay]));
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
  [rec updateOccurencesFrom:[d0 startOfCurrentDay] to:[d3 endOfCurrentDay] inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
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
  NSDate*eventEnd = [[eventStart dateDaysAfter:1] dateHoursAfter:1]; // two day event
  NSDate*syncStart = [[eventEnd dateHoursAfter:1] endOfCurrentDay];
  NSDate*syncEnd = [[syncStart dateDaysAfter:1] endOfCurrentDay];
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
  NSArray* result = [rec matchingStartDates:[b_ endOfCurrentDay] to:[d_ endOfCurrentDay]];
  assertThat(result,hasCountOf(1));
  assertThat(result,contains(c_,nil));
  event.startDate = a_;
  event.endDate = b_;
  result = [rec matchingStartDates:[b_ endOfCurrentDay] to:[d_ endOfCurrentDay]];
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
