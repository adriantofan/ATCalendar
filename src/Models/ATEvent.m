#import "ATEvent.h"


@interface ATEvent ()

// Private interface goes here.

@end


@implementation ATEvent

+ (NSArray*)allEventsFrom:(NSDate*)fromDate to:(NSDate*)endDate{
  NSDate* start = fromDate?fromDate:[NSDate dateWithTimeIntervalSince1970:0];
  NSDate* end = endDate?endDate:[NSDate dateWithTimeIntervalSince1970:MAXFLOAT];
  NSPredicate *predicate =
   [NSPredicate predicateWithFormat:@"((endDate >= %@) AND (endDate <= %@))\
                                  OR  ((startDate >= %@) AND (startDate <= %@))"
                      argumentArray:@[start,end,start,end]];
  
  NSArray * events = [ATEvent MR_findAllSortedBy:@"startDate"
                                       ascending:YES
                                   withPredicate:predicate];
  return events;
}

@end