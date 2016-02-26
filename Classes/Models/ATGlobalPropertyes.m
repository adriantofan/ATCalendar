#import "ATGlobalPropertyes.h"
#import <MagicalRecord/MagicalRecord.h>


@interface ATGlobalPropertyes ()

// Private interface goes here.

@end

NSString* ATLastCachedDayTimestamp = @"ATLastCachedDayTimestamp";

@implementation ATGlobalPropertyes

+(NSDate*)lastCachedDay{
  
  ATGlobalPropertyes* prop  = [ATGlobalPropertyes MR_findFirstByAttribute:@"key" withValue:ATLastCachedDayTimestamp];
  if (nil == prop) {
    return nil;
  }else{
    NSDate* date = [NSDate dateWithTimeIntervalSinceReferenceDate:[prop.value doubleValue]];
    return date;
  }
}
+(void)setLastCachedDay:(NSDate*)date{
  ATGlobalPropertyes* prop  = [ATGlobalPropertyes MR_findFirstByAttribute:@"key" withValue:ATLastCachedDayTimestamp];
  if (nil == prop) {
    prop = [ATGlobalPropertyes MR_createEntity];
    prop.key = ATLastCachedDayTimestamp;
  }
  [date timeIntervalSinceReferenceDate];
  prop.value = [NSString stringWithFormat:@"%f",[date timeIntervalSinceReferenceDate]];
}
@end
