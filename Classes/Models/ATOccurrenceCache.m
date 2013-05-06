#import "ATOccurrenceCache.h"
#import "ATEvent.h"
#import "ATCalendar.h"
#import "ATTimeSpan.h"
#import "ATEvent+LocalNotifications.h"
#import "NSBundle+ATCalendar.h"
#define MR_SHORTHAND
#import "CoreData+MagicalRecord.h"

@interface ATOccurrenceCache ()

// Private interface goes here.

@end


@implementation ATOccurrenceCache

+(void)updateCachesAfterEventChange:(ATEvent*)event{
  
  NSPredicate* eventPredicate = [NSPredicate predicateWithFormat:@"event == %@"
                                                   argumentArray:@[event]];
  [ATOccurrenceCache MR_deleteAllMatchingPredicate:eventPredicate inContext:event.managedObjectContext];
  ATTimeSpan* syncSpan = [[ATCalendar sharedInstance] currentSyncSpan];
  [event updateSimpleOccurencesFrom:syncSpan.start to:syncSpan.end inContext:event.managedObjectContext];
  if (event.recurence) {
    [event.recurence updateOccurencesFrom:syncSpan.start to:syncSpan.end inContext:event.managedObjectContext];
  }
}

+(NSArray*)firstOccurenceCacheOfEventWithAlarmAfter:(NSDate*)date inContext:(NSManagedObjectContext*)moc limit:(NSInteger)limit{
  NSArray* ids =[ATOccurrenceCache eventIDsWithAlertAfter:date inContext:moc limit:limit];
  return [ATOccurrenceCache firstOccurenceCacheOfEventIDs:ids after:date inContext:moc limit:limit];
}

+(NSArray*)firstOccurenceCacheOfEventIDs:(NSArray*)eventIDs after:(NSDate*)date inContext:(NSManagedObjectContext*)moc limit:(NSInteger)limit{
//  NSArray* eventIDs = [ATOccurrenceCache eventsObjectIdsScheduledAfter:date inContext:moc limit:limit];
  NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:[eventIDs count]];
  for (NSManagedObjectID *eventID in eventIDs) {
    NSPredicate *dateAndEventFilter = [NSPredicate predicateWithFormat:@"day >= %@ AND event = %@", [date mt_startOfCurrentDay],eventID];
    ATOccurrenceCache* occurence =
      [ATOccurrenceCache MR_findFirstWithPredicate:dateAndEventFilter
                                          sortedBy:@"day"
                                         ascending:YES
                                         inContext:moc];
    if (occurence) {[results addObject:occurence];}
  }
  return results;
}


+(NSArray*)eventIDsWithAlertAfter:(NSDate*)date inContext:(NSManagedObjectContext*)moc limit:(NSInteger)limit{
  NSPredicate *dateFilter = [NSPredicate predicateWithFormat:@"day >= %@ AND (event.firstAlertType != 0 OR event.seccondAlertType != 0)", [date mt_startOfCurrentDay]];
  NSFetchRequest *eventsRequest =
    [ATOccurrenceCache MR_requestAllSortedBy:@"day"
                                   ascending:YES
                               withPredicate:dateFilter
                                   inContext:moc];
  [eventsRequest setReturnsDistinctResults:YES];
  eventsRequest.propertiesToFetch = [NSArray arrayWithObject:[[eventsRequest.entity propertiesByName] objectForKey:@"event"]];
  eventsRequest.resultType = NSDictionaryResultType;
  eventsRequest.fetchLimit = limit;
  NSArray* results =  [ATOccurrenceCache MR_executeFetchRequest:eventsRequest inContext:moc];
  results = [results map:^id(id obj) {
    return [obj objectForKey:@"event"];
  }];
  return results;
}

-(NSTimeInterval) dayTimeStamp{
  return [self.day timeIntervalSinceReferenceDate];
}

-(NSTimeInterval) weekTimeStamp{
  return [[self.day mt_startOfCurrentWeek] timeIntervalSinceReferenceDate];
}
-(NSTimeInterval) monthTimeStamp{
  return [[self.day mt_startOfCurrentMonth] timeIntervalSinceReferenceDate];
}

-(BOOL)allDay{
  if ([self.startDate isEqualToDate:[self.startDate mt_startOfCurrentDay]] &&
      [self.endDate isEqualToDate:[self.endDate mt_endOfCurrentDay]]) {
    return YES;
  }
  return NO;
}
-(NSString*)timeSpanDescription{
  if ([self.startDate isEqualToDate:self.day] && [self.endDate isEqualToDate:[self.day mt_endOfCurrentDay]]) {
    return ATLocalizedString(@"all-day",@"marks event end");
  }if (![self.occurrenceDate mt_isWithinSameDay:self.day] &&
       [self.endDate mt_isWithinSameDay:self.day]) {
    return [NSString stringWithFormat:ATLocalizedString(@"ends\n%@", @"event occurence end time"),
            [self.endDate mt_stringFromDateWithHourAndMinuteFormat:MTDateHourFormat24Hour]];
  }else
  return  [self.occurrenceDate mt_stringFromDateWithHourAndMinuteFormat:MTDateHourFormat24Hour];
  return @"*";
}


-(NSString*)durationDescription{
  NSString* description = @"";
  NSDateFormatter* dateTimeFormater = [[NSDateFormatter alloc] init];
  [dateTimeFormater setTimeStyle:NSDateFormatterShortStyle];
  [dateTimeFormater setDateStyle:NSDateFormatterLongStyle];
  NSDateFormatter* timeFormater = [[NSDateFormatter alloc] init];
  [timeFormater setTimeStyle:NSDateFormatterShortStyle];
  [timeFormater setDateStyle:NSDateFormatterNoStyle];\
  NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
  [dateFormater setTimeStyle:NSDateFormatterNoStyle];
  [dateFormater setDateStyle:NSDateFormatterFullStyle];
  NSDateFormatter* formater = dateTimeFormater;
  NSDate *start = self.occurrenceDate;
  NSDate *end = [start dateByAddingTimeInterval:[self.event.endDate timeIntervalSinceDate:self.event.startDate]];
  // :-(
  if ([start mt_isWithinSameDay:end] && !self.event.allDayValue) {
    description =
      [description stringByAppendingFormat:ATLocalizedString(@"%@ \nfrom %@ to %@",@""),
        [dateFormater stringFromDate:start],
        [timeFormater stringFromDate:start],
        [timeFormater stringFromDate:end]];
  }else{
    if (self.event.allDayValue) {
      description = ATLocalizedString(@"All Day ",@"All day event type");
      formater = dateFormater;
    }
    if ([start mt_isWithinSameDay:end] && self.event.allDayValue) {
      description =
        [description stringByAppendingFormat:@"%@",
         [dateFormater stringFromDate:start]];
    }else{
      description =
      [description stringByAppendingFormat:ATLocalizedString(@"from %@ to %@",@"event span"),
       [formater stringFromDate:start],
       [formater stringFromDate:end]];
    }
  }
  if (self.event.recurence) {
    description = [description stringByAppendingString:@"\n"];
    description = [description stringByAppendingFormat:ATLocalizedString(@"repeats %@",@"EG: repeats (every day) , where every day is the event reccurence  "),
                   [self.event.recurence reccurenceTypeDescription]];
  }
  return description;
}

// Custom logic goes here.

@end
