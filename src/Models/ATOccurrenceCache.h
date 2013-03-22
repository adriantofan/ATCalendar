#import "_ATOccurrenceCache.h"

@interface ATOccurrenceCache : _ATOccurrenceCache {}
// Array of one ATOccurrenceCache
+(NSArray*)firstOccurenceCacheOfEventAfter:(NSDate*)date inContext:(NSManagedObjectContext*)moc limit:(NSInteger)limit;
-(NSTimeInterval) dayTimeStamp;
-(NSString*)durationDescription;

//
// Array of one ATOccurrenceCache
+(NSArray*)firstOccurenceCacheOfEventIDs:(NSArray*)eventIDs after:(NSDate*)date inContext:(NSManagedObjectContext*)moc limit:(NSInteger)limit;
// Array of NSManagedObjectID
+(NSArray*)eventsObjectIdsScheduledAfter:(NSDate*)date inContext:(NSManagedObjectContext*)moc limit:(NSInteger)limit;
@end
