#import "ATOccurrenceCache.h"


@interface ATOccurrenceCache ()

// Private interface goes here.

@end


@implementation ATOccurrenceCache
-(NSTimeInterval) dayTimeStamp{
  return [self.day timeIntervalSinceReferenceDate];
}

-(BOOL)allDay{
  if ([self.startDate isEqualToDate:[self.startDate startOfCurrentDay]] &&
      [self.endDate isEqualToDate:[self.endDate startOfCurrentDay]]) {
    return YES;
  }
  return NO;
}

-(NSString*)durationDescription{
  NSString* description = @"";
  NSDateFormatter* dayFormater = [[NSDateFormatter alloc] init];
  [dayFormater setTimeStyle:NSDateFormatterNoStyle];
  [dayFormater setDateStyle:NSDateFormatterLongStyle];
  NSDateFormatter* timeFormater = [[NSDateFormatter alloc] init];
  [timeFormater setTimeStyle:NSDateFormatterShortStyle];
  [timeFormater setDateStyle:NSDateFormatterNoStyle];
  
  if (self.allDay) {
    description = [NSString stringWithFormat:@"%@\n",[dayFormater stringFromDate:self.day]];
    description = [description stringByAppendingFormat:@"%@\n",NSLocalizedString(@"All Day", @"")];
  }else{
    description = [NSString stringWithFormat:@"%@\n",[dayFormater stringFromDate:self.day]];
    description = [description stringByAppendingFormat:NSLocalizedString(@"From %@ to %@\n",@"time span for an event occurence"),[timeFormater stringFromDate:self.startDate],[timeFormater stringFromDate:self.endDate]];
  }
  return description;
}
// Custom logic goes here.

@end
