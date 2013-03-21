#import "ATWeeklyRecurrence.h"


@interface ATWeeklyRecurrence ()

// Private interface goes here.

@end


@implementation ATWeeklyRecurrence
-(NSDate*)nextOccurenceAfter:(NSDate*)date{
  NSDate* next = [date dateWeeksAfter:1];
  if ([next isBetweenDate:self.startDate andDate:self.endDate]) {
    return next;
  }
  return nil;
}

// Custom logic goes here.
-(NSString*)reccurenceTypeDescription{
  return NSLocalizedString(@"weekley", @"Weekley reccurence type description");
}
@end
