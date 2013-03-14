// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATRecurrence.h instead.

#import <CoreData/CoreData.h>


extern const struct ATRecurrenceAttributes {
	__unsafe_unretained NSString *endDate;
	__unsafe_unretained NSString *interval;
	__unsafe_unretained NSString *startDate;
	__unsafe_unretained NSString *type;
} ATRecurrenceAttributes;

extern const struct ATRecurrenceRelationships {
	__unsafe_unretained NSString *event;
} ATRecurrenceRelationships;

extern const struct ATRecurrenceFetchedProperties {
} ATRecurrenceFetchedProperties;

@class ATEvent;






@interface ATRecurrenceID : NSManagedObjectID {}
@end

@interface _ATRecurrence : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ATRecurrenceID*)objectID;





@property (nonatomic, strong) NSDate* endDate;



//- (BOOL)validateEndDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* interval;



@property int16_t intervalValue;
- (int16_t)intervalValue;
- (void)setIntervalValue:(int16_t)value_;

//- (BOOL)validateInterval:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startDate;



//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* type;



@property int16_t typeValue;
- (int16_t)typeValue;
- (void)setTypeValue:(int16_t)value_;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) ATEvent *event;

//- (BOOL)validateEvent:(id*)value_ error:(NSError**)error_;





@end

@interface _ATRecurrence (CoreDataGeneratedAccessors)

@end

@interface _ATRecurrence (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveEndDate;
- (void)setPrimitiveEndDate:(NSDate*)value;




- (NSNumber*)primitiveInterval;
- (void)setPrimitiveInterval:(NSNumber*)value;

- (int16_t)primitiveIntervalValue;
- (void)setPrimitiveIntervalValue:(int16_t)value_;




- (NSDate*)primitiveStartDate;
- (void)setPrimitiveStartDate:(NSDate*)value;




- (NSNumber*)primitiveType;
- (void)setPrimitiveType:(NSNumber*)value;

- (int16_t)primitiveTypeValue;
- (void)setPrimitiveTypeValue:(int16_t)value_;





- (ATEvent*)primitiveEvent;
- (void)setPrimitiveEvent:(ATEvent*)value;


@end
