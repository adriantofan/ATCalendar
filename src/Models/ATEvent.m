#import "ATEvent.h"
#import "ATOccurrenceCache.h"


@interface ATEvent ()
@end


@implementation ATEvent

+ (NSArray*)nonRecurringEventsFrom:(NSDate*)fromDate to:(NSDate*)endDate{
  NSDate* start = fromDate?fromDate:[NSDate dateWithTimeIntervalSince1970:0];
  NSDate* end = endDate?endDate:[NSDate dateWithTimeIntervalSince1970:MAXFLOAT];
  //TODO: optimize this ?
  NSPredicate *predicate =
   [NSPredicate predicateWithFormat:@"(((%@ <= endDate) AND (endDate <= %@))\
                                      OR((%@ <= startDate) AND (startDate <= %@))\
                                      OR  ((startDate <= %@  ) AND ( %@ <= endDate)))\
                                     AND (recurence == nil)"
                      argumentArray:@[start,end,start,end,start,end]];
  
  NSArray * events = [ATEvent MR_findAllSortedBy:@"startDate"
                                       ascending:YES
                                   withPredicate:predicate];
  return events;
}


- (NSDate*)eventStartAtDate:(NSDate*)occurence offset:(NSInteger)days{
  NSDate *offsetedStartDate = [self.startDate dateDaysAfter:days];
  NSDate *offsetedEndDate = [self.endDate dateDaysAfter:days];
  if (occurence == nil)
    return nil;
  if ([occurence isWithinSameDay:offsetedStartDate]) {
    return offsetedStartDate;
  }
  if ([occurence isBetweenDate:[offsetedStartDate startOfCurrentDay] andDate:[offsetedEndDate endOfCurrentDay]]) {
    return [occurence startOfCurrentDay];
  }
  return nil;
}

- (NSDate*)eventEndAtDate:(NSDate*)occurence offset:(NSInteger)days{
  NSDate *offsetedStartDate = [self.startDate dateDaysAfter:days];
  NSDate *offsetedEndDate = [self.endDate dateDaysAfter:days];
  if (occurence == nil)
    return nil;
  else
    if ([occurence isWithinSameDay:offsetedEndDate])
      return offsetedEndDate;
    else
      if ([occurence isBetweenDate:[offsetedStartDate startOfCurrentDay] andDate:[offsetedEndDate endOfCurrentDay]])
        return [occurence endOfCurrentDay];
  return nil;
}


- (NSDate*)eventStartAtDate:(NSDate*)occurence{
  return [self eventStartAtDate:occurence offset:0];
}

- (NSDate*)eventEndAtDate:(NSDate*)occurence{
  return [self eventEndAtDate:occurence offset:0];
}
@end

@implementation ATEvent (ATOccurenceCache)

- (void)updateSimpleOccurencesFrom:(NSDate *)fromDate to:(NSDate *)toDate inContext:(NSManagedObjectContext*)moc{
  if (self.recurence) {return; };
  NSArray* eventMatchingDates = [self matchingDates:fromDate to:toDate];
  for (NSDate *occurenceDate in eventMatchingDates) {
    ATOccurrenceCache *occurence = [ATOccurrenceCache MR_createInContext:moc];
    occurence.day = [occurenceDate startOfCurrentDay];
    occurence.startDate = [self eventStartAtDate:occurenceDate];
    occurence.occurrenceDate = self.startDate;
    occurence.endDate = [self eventEndAtDate:occurenceDate];
    occurence.event = self;
  }
}

- (NSArray*)matchingDates:(NSDate*)fromDate to:(NSDate*)endDate offset:(NSUInteger)days{
  if (!fromDate || !endDate) { return [NSArray array]; }
  
  if ([fromDate isAfter:endDate]) {
    NSDate *tmp = endDate;
    endDate = fromDate;
    fromDate = tmp;
  }
  NSDate* crtStartDate = [self.startDate dateDaysAfter:days];
  NSDate* crtEndDate = [self.endDate dateDaysAfter:days];
  if ([crtStartDate isBefore:fromDate] && [crtEndDate isBefore:fromDate])
    return [NSArray array];
  if ([crtStartDate isAfter:endDate] && [crtEndDate isAfter:endDate])
    return [NSArray array];
  NSDate* start,*end;
  if ([fromDate isBefore:crtStartDate]) {
    start = [crtStartDate startOfCurrentDay];
  }else{
    start = [fromDate startOfCurrentDay];
  }
  if ([endDate isAfter:crtEndDate]) {
    end = [crtEndDate startOfCurrentDay];
  }else{
    end = [endDate startOfCurrentDay];
  }
  return [NSDate datesCollectionFromDate:start untilDate:[end oneDayNext]];
}

- (NSArray*)matchingDates:(NSDate*)fromDate to:(NSDate*)endDate{
  return [self matchingDates:fromDate to:endDate offset:0];
}


@end