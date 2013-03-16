// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATMonthlyRecurrence.h instead.

#import <CoreData/CoreData.h>
#import "ATRecurrence.h"

extern const struct ATMonthlyRecurrenceAttributes {
	__unsafe_unretained NSString *dayOfMonth;
} ATMonthlyRecurrenceAttributes;

extern const struct ATMonthlyRecurrenceRelationships {
} ATMonthlyRecurrenceRelationships;

extern const struct ATMonthlyRecurrenceFetchedProperties {
} ATMonthlyRecurrenceFetchedProperties;




@interface ATMonthlyRecurrenceID : NSManagedObjectID {}
@end

@interface _ATMonthlyRecurrence : ATRecurrence {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ATMonthlyRecurrenceID*)objectID;





@property (nonatomic, strong) NSNumber* dayOfMonth;



@property int32_t dayOfMonthValue;
- (int32_t)dayOfMonthValue;
- (void)setDayOfMonthValue:(int32_t)value_;

//- (BOOL)validateDayOfMonth:(id*)value_ error:(NSError**)error_;






@end

@interface _ATMonthlyRecurrence (CoreDataGeneratedAccessors)

@end

@interface _ATMonthlyRecurrence (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveDayOfMonth;
- (void)setPrimitiveDayOfMonth:(NSNumber*)value;

- (int32_t)primitiveDayOfMonthValue;
- (void)setPrimitiveDayOfMonthValue:(int32_t)value_;




@end
