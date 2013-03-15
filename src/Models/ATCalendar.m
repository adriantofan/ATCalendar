//
//  ATCalendar.m
//  ATCalendar
//
//  Created by Adrian Tofan on 14/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATCalendar.h"
#import "ATGlobalPropertyes.h"
#import "NSDate+MTDates.h"
#import "ATOccurrenceCache.h"
#import "ATEvent.h"
#import "ATTimeSpan.h"


@implementation ATCalendar
static ATCalendar* ___sharedInstance;

+(ATCalendar*)sharedInstance{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    ___sharedInstance = [[ATCalendar alloc] init];
  });
  return ___sharedInstance;
}

- (void)syncNonRecurringEventsFrom:(NSDate *)fromDate to:(NSDate *)toDate {
    NSArray* nonRecuringEvents = [ATEvent allEventsFrom:fromDate
                                                     to:toDate];
    for (ATEvent *event in nonRecuringEvents) {
        NSArray* eventMatchingDates = [event matchingDates:fromDate to:toDate];
        for (NSDate *occurenceDate in eventMatchingDates) {
            ATOccurrenceCache *occurence = [ATOccurrenceCache MR_createEntity];
            occurence.day = [occurenceDate startOfCurrentDay];
            occurence.occurrenceDate = occurenceDate;
            occurence.occurrenceEnd = [event endDateForDate:occurenceDate];
            occurence.event = event;
        }
    }
}

-(void)syncRecurringEventsFrom:(NSDate *)fromDate to:(NSDate *)toDate{
  
}


-(void)syncCachesForDate:(NSDate*)toDate{
  NSDate *lastCachedDay = [ATGlobalPropertyes lastCachedDay];
  NSDate * from,* to;
  if ([lastCachedDay isAfter:toDate]) {
    [self clearOccurenceCache];
    from = nil;
    to = toDate;
  }
  ATTimeSpan* syncSpan = [self timeSpanToSyncFrom:from to:to];
  
  [self syncNonRecurringEventsFrom:syncSpan.start to:syncSpan.end];
  [self syncRecurringEventsFrom:syncSpan.start to:syncSpan.end];
}





-(ATTimeSpan*)timeSpanToSyncFrom:(NSDate*)fromDate to:(NSDate*)toDate{
  if ((nil == fromDate) && (toDate == nil)){
    return nil;
  }else    
    if (nil == fromDate) {
      return [ATTimeSpan timeSpanFrom:[[toDate oneYearPrevious] startOfCurrentDay]
                                   to:[[[toDate oneYearNext] oneYearNext] endOfCurrentDay]];
    }else
      if ([fromDate isWithinSameDay:toDate]) {
        return nil;
      }else{
        return [ATTimeSpan timeSpanFrom: [[fromDate dateDaysAfter:1] startOfCurrentDay]
                                     to:[toDate endOfCurrentDay]];
      }

}

-(NSArray*)dateArrayToSyncFrom:(NSDate*)fromDate to:(NSDate*)toDate{
  ATTimeSpan* timeSpan = [self timeSpanToSyncFrom:fromDate to:toDate];
  if ([timeSpan.start isWithinSameDay:timeSpan.end]) {
    return @[[timeSpan.start startOfCurrentDay]];
  }else
    return [NSDate datesCollectionFromDate:[[timeSpan.start oneDayPrevious] startOfCurrentDay]
                                  untilDate:[timeSpan.end startOfCurrentDay]];
}
@end
