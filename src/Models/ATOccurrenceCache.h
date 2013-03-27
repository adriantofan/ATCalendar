#import "_ATOccurrenceCache.h"
@class ATEvent;
@interface ATOccurrenceCache : _ATOccurrenceCache {}

+(void)updateCachesAndAlertsAfterEventChange:(ATEvent*)event;
// Array of one ATOccurrenceCache
+(NSArray*)firstOccurenceCacheOfEventWithAlarmAfter:(NSDate*)date inContext:(NSManagedObjectContext*)moc limit:(NSInteger)limit;
-(NSTimeInterval) dayTimeStamp;
-(NSString*)durationDescription;

//
// Array of one ATOccurrenceCache
+(NSArray*)firstOccurenceCacheOfEventIDs:(NSArray*)eventIDs after:(NSDate*)date inContext:(NSManagedObjectContext*)moc limit:(NSInteger)limit;
// Array of NSManagedObjectID
+(NSArray*)eventIDsWithAlertAfter:(NSDate*)date inContext:(NSManagedObjectContext*)moc limit:(NSInteger)limit;
@end
