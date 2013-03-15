#import "ATEvent.h"
#import "ATOccurrenceCache.h"


@interface ATEvent ()

// Private interface goes here.

@end


@implementation ATEvent

+ (NSArray*)allEventsFrom:(NSDate*)fromDate to:(NSDate*)endDate{
  NSDate* start = fromDate?fromDate:[NSDate dateWithTimeIntervalSince1970:0];
  NSDate* end = endDate?endDate:[NSDate dateWithTimeIntervalSince1970:MAXFLOAT];
  //TODO: optimize this ?
  NSPredicate *predicate =
   [NSPredicate predicateWithFormat:@"((%@ <= endDate) AND (endDate <= %@))\
                                  OR  ((%@ <= startDate) AND (startDate <= %@))\
                                  OR  ((startDate <= %@  ) AND ( %@ <= endDate)) "
                      argumentArray:@[start,end,start,end,start,end]];
  
  NSArray * events = [ATEvent MR_findAllSortedBy:@"startDate"
                                       ascending:YES
                                   withPredicate:predicate];
  return events;
}

- (void)updateOccurencesFrom:(NSDate *)fromDate to:(NSDate *)toDate {
  NSArray* eventMatchingDates = [self matchingDates:fromDate to:toDate];
  for (NSDate *occurenceDate in eventMatchingDates) {
    ATOccurrenceCache *occurence = [ATOccurrenceCache MR_createEntity];
    occurence.day = [occurenceDate startOfCurrentDay];
    occurence.occurrenceDate = [self startDateForDate:occurenceDate];
    occurence.occurrenceEnd = [self endDateForDate:occurenceDate];
    occurence.event = self;
  }
}


- (NSDate*)startDateForDate:(NSDate*)occurence{
  if (occurence == nil)
    return nil;
  if ([occurence isWithinSameDay:self.startDate]) {
    return self.startDate;
  }
  if ([occurence isBetweenDate:[self.startDate startOfCurrentDay] andDate:[self.endDate endOfCurrentDay]]) {
    return [occurence startOfCurrentDay];
  }
  return nil;
}

- (NSDate*)endDateForDate:(NSDate*)occurence{
  if (occurence == nil)
    return nil;
  else
    if ([occurence isWithinSameDay:self.endDate])
      return self.endDate;
    else
      if ([occurence isBetweenDate:[self.startDate startOfCurrentDay] andDate:[self.endDate endOfCurrentDay]]) 
      return [occurence endOfCurrentDay];
  return nil;
}

- (NSArray*)matchingDates:(NSDate*)fromDate to:(NSDate*)endDate{
  if (!fromDate || !endDate) { return [NSArray array]; }
  
  
  
  
  if ([fromDate isAfter:endDate]) {
    NSDate *tmp = endDate;
    endDate = fromDate;
    fromDate = tmp;
  }
  if ([self.startDate isBefore:fromDate] && [self.endDate isBefore:fromDate])
    return [NSArray array];
  if ([self.startDate isAfter:endDate] && [self.endDate isAfter:endDate])
    return [NSArray array];
  NSDate* start,*end;
  if ([fromDate isBefore:self.startDate]) {
    start = [self.startDate startOfCurrentDay];
  }else{
    start = [fromDate startOfCurrentDay];
  }
  if ([endDate isAfter:self.endDate]) {
    end = [self.endDate startOfCurrentDay];
  }else{
    end = [endDate startOfCurrentDay];
  }
  return [NSDate datesCollectionFromDate:start untilDate:[end oneDayNext]];
}

@end