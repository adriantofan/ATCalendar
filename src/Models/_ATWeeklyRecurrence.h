// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATWeeklyRecurrence.h instead.

#import <CoreData/CoreData.h>
#import "ATRecurrence.h"

extern const struct ATWeeklyRecurrenceAttributes {
	__unsafe_unretained NSString *dayOfWeek;
} ATWeeklyRecurrenceAttributes;

extern const struct ATWeeklyRecurrenceRelationships {
} ATWeeklyRecurrenceRelationships;

extern const struct ATWeeklyRecurrenceFetchedProperties {
} ATWeeklyRecurrenceFetchedProperties;




@interface ATWeeklyRecurrenceID : NSManagedObjectID {}
@end

@interface _ATWeeklyRecurrence : ATRecurrence {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ATWeeklyRecurrenceID*)objectID;





@property (nonatomic, strong) NSNumber* dayOfWeek;



@property int32_t dayOfWeekValue;
- (int32_t)dayOfWeekValue;
- (void)setDayOfWeekValue:(int32_t)value_;

//- (BOOL)validateDayOfWeek:(id*)value_ error:(NSError**)error_;






@end

@interface _ATWeeklyRecurrence (CoreDataGeneratedAccessors)

@end

@interface _ATWeeklyRecurrence (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveDayOfWeek;
- (void)setPrimitiveDayOfWeek:(NSNumber*)value;

- (int32_t)primitiveDayOfWeekValue;
- (void)setPrimitiveDayOfWeekValue:(int32_t)value_;




@end
