#import "ATRecurrence.h"
#import "ATEvent.h"
#import "ATOccurrenceCache.h"

@interface ATRecurrence ()

// Private interface goes here.

@end



@implementation ATRecurrence

//-(void)setStartDate:(NSDate *)startDate{
//  [self willChangeValueForKey:@"startDate"];
//  [self setPrimitiveStartDate:[startDate startOfCurrentDay]];
//  [self didChangeValueForKey:@"startDate"];
//}
//
//-(void)setEndDate:(NSDate *)endDate{
//  [self willChangeValueForKey:@"endDate"];
//  [self setPrimitiveStartDate:[endDate endOfCurrentDay]];
//  [self didChangeValueForKey:@"endDate"];
//}

+ (NSArray*)recurrencesFrom:(NSDate*)fromDate to:(NSDate*)endDate{
  NSDate* start = fromDate?fromDate:[NSDate dateWithTimeIntervalSince1970:0];
  NSDate* end = endDate?endDate:[NSDate dateWithTimeIntervalSince1970:MAXFLOAT];
  //TODO: optimize this ?
  NSPredicate *predicate =
  [NSPredicate predicateWithFormat:@"((%@ <= endDate) AND (endDate <= %@))\
                                    OR((%@ <= startDate) AND (startDate <= %@))\
                                    OR((startDate <= %@  ) AND ( %@ <= endDate))"
                     argumentArray:@[start,end,start,end,start,end]];
  NSArray * reccurences = [ATRecurrence MR_findAllSortedBy:@"startDate"
                                                 ascending:YES
                                             withPredicate:predicate];
  return reccurences;
}

-(NSDate*)nextOccurenceAfter:(NSDate*)date{
  assert(false);
}

@end

@implementation ATRecurrence (ATOccurenceCache)
- (void)updateOccurencesFrom:(NSDate *)fromDate to:(NSDate *)toDate inContext:(NSManagedObjectContext*)moc{
  NSDictionary* matches = [self matchingDateSets:fromDate to:toDate];
  [matches enumerateKeysAndObjectsWithOptions:0
                                   usingBlock:^(NSNumber* offset, NSArray* dates, BOOL *stop) {
                                     for (NSDate* occurenceDate in dates) {
                                       ATOccurrenceCache *occurence = [ATOccurrenceCache MR_createInContext:moc];
                                       occurence.startDate = [self.event eventStartAtDate:occurenceDate offset:[offset integerValue]];
                                       occurence.endDate = [self.event eventEndAtDate:occurenceDate offset:[offset integerValue]];
                                       occurence.occurrenceDate = [self.event.startDate dateDaysAfter:[offset integerValue]];
                                       occurence.event = self.event;
                                       occurence.day = [occurenceDate startOfCurrentDay];
                                     }
                                   }];
}

- (NSDictionary*)matchingDateSets:(NSDate*)fromDate to:(NSDate*)endDate{
  NSArray* startingDates = [self matchingStartDates:fromDate to:endDate];
  NSMutableDictionary *occurences = [NSMutableDictionary dictionaryWithCapacity:[startingDates count]];
  for (NSDate* match in startingDates) {
    NSUInteger offset = [match daysSinceDate:self.startDate];
    NSArray* subMatches = [self.event matchingDates:[match startOfCurrentDay]
                                                 to:endDate
                                             offset:offset];
    [occurences setObject:subMatches
                   forKey:@(offset)];
  }
  return [NSDictionary dictionaryWithDictionary:occurences];
}

- (NSArray*)matchingStartDates:(NSDate*)fromDate to:(NSDate*)endDate{
  if ([self.endDate isBefore:fromDate]) {return @[];};
  NSTimeInterval eventSpan = [self.event.startDate timeIntervalSinceDate:self.event.endDate];
  NSMutableArray *dates = [[NSMutableArray alloc]initWithCapacity:10];
  for (NSDate *begin = self.startDate;begin && [begin isBefore:endDate];) {
    NSDate* end = [begin dateByAddingTimeInterval:eventSpan];
    if ([begin isBetweenDate:fromDate andDate:endDate] ||
        [end isBetweenDate:fromDate andDate:endDate]) {
      [dates addObject:begin];
    }
    begin = [self nextOccurenceAfter:begin];
  }
  return [NSArray arrayWithArray:dates];
}
@end