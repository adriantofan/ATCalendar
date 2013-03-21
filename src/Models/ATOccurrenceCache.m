#import "ATOccurrenceCache.h"
#import "ATEvent.h"

@interface ATOccurrenceCache ()

// Private interface goes here.

@end


@implementation ATOccurrenceCache
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
