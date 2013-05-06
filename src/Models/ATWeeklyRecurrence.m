#import "ATWeeklyRecurrence.h"
#import "NSBundle+ATCalendar.h"

@interface ATWeeklyRecurrence ()

// Private interface goes here.

@end


@implementation ATWeeklyRecurrence
-(NSDate*)nextOccurenceAfter:(NSDate*)date{
  NSDate* next = [date mt_dateWeeksAfter:1];
  if ([next mt_isBetweenDate:self.startDate andDate:self.endDate]) {
    return next;
  }
  return nil;
}

// Custom logic goes here.
-(NSString*)reccurenceTypeDescription{
  return ATLocalizedString(@"weekley", @"Weekley reccurence type description");
}
@end
