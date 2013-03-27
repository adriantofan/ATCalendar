#import "ATOccurrenceCache.h"
#import "ATEvent.h"
#import "ATCalendar.h"
#import "ATTimeSpan.h"
#import "ATEvent+LocalNotifications.h"


@interface ATOccurrenceCache ()

// Private interface goes here.

@end


@implementation ATOccurrenceCache

+(void)updateCachesAndAlertsAfterEventChange:(ATEvent*)event{
  
  NSPredicate* eventPredicate = [NSPredicate predicateWithFormat:@"event == %@"
                                                   argumentArray:@[event]];
  [ATOccurrenceCache MR_deleteAllMatchingPredicate:eventPredicate inContext:event.managedObjectContext];
  ATTimeSpan* syncSpan = [[ATCalendar sharedInstance] currentSyncSpan];
  [event updateSimpleOccurencesFrom:syncSpan.start to:syncSpan.end inContext:event.managedObjectContext];
  if (event.recurence) {
    [event.recurence updateOccurencesFrom:syncSpan.start to:syncSpan.end inContext:event.managedObjectContext];
  }
  [event updateLocalNotificationsAfterChange];
}

+(NSArray*)firstOccurenceCacheOfEventWithAlarmAfter:(NSDate*)date inContext:(NSManagedObjectContext*)moc limit:(NSInteger)limit{
  NSArray* ids =[ATOccurrenceCache eventIDsWithAlertAfter:date inContext:moc limit:limit];
  return [ATOccurrenceCache firstOccurenceCacheOfEventIDs:ids after:date inContext:moc limit:limit];
}

+(NSArray*)firstOccurenceCacheOfEventIDs:(NSArray*)eventIDs after:(NSDate*)date inContext:(NSManagedObjectContext*)moc limit:(NSInteger)limit{
//  NSArray* eventIDs = [ATOccurrenceCache eventsObjectIdsScheduledAfter:date inContext:moc limit:limit];
  NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:[eventIDs count]];
  for (NSManagedObjectID *eventID in eventIDs) {
    NSPredicate *dateAndEventFilter = [NSPredicate predicateWithFormat:@"day >= %@ AND event = %@", [date startOfCurrentDay],eventID];
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
  NSPredicate *dateFilter = [NSPredicate predicateWithFormat:@"day >= %@ AND (event.firstAlertType != 0 OR event.seccondAlertType != 0)", [date startOfCurrentDay]];
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

-(BOOL)allDay{
  if ([self.startDate isEqualToDate:[self.startDate startOfCurrentDay]] &&
      [self.endDate isEqualToDate:[self.endDate endOfCurrentDay]]) {
    return YES;
  }
  return NO;
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
  if ([start isWithinSameDay:end] && !self.event.allDayValue) {
    description =
      [description stringByAppendingFormat:NSLocalizedString(@"%@ \nfrom %@ to %@",@""),
        [dateFormater stringFromDate:start],
        [timeFormater stringFromDate:start],
        [timeFormater stringFromDate:end]];
  }else{
    if (self.event.allDayValue) {
      description = NSLocalizedString(@"All Day ",@"");
      formater = dateFormater;
    }
    if ([start isWithinSameDay:end] && self.event.allDayValue) {
      description =
        [description stringByAppendingFormat:NSLocalizedString(@"%@",@""),
         [dateFormater stringFromDate:start]];
    }else{
      description =
      [description stringByAppendingFormat:NSLocalizedString(@"from %@ to %@",@""),
       [formater stringFromDate:start],
       [formater stringFromDate:end]];
    }
  }
  if (self.event.recurence) {
    description = [description stringByAppendingString:@"\n"];
    description = [description stringByAppendingFormat:@"repeats %@",[self.event.recurence reccurenceTypeDescription]];
  }
  return description;
}

// Custom logic goes here.

@end
