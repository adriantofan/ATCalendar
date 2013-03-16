#import "ATDailyRecurrence.h"


@interface ATDailyRecurrence ()

// Private interface goes here.

@end


@implementation ATDailyRecurrence

-(NSDate*)nextOccurenceAfter:(NSDate*)date{
  NSDate* next = [date dateDaysAfter:1];
  if ([next isBetweenDate:self.startDate andDate:self.endDate]) {
    return next;
  }
  return nil;
}

@end
