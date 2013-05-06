// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATOccurrenceCache.h instead.

#import <CoreData/CoreData.h>


extern const struct ATOccurrenceCacheAttributes {
	__unsafe_unretained NSString *day;
	__unsafe_unretained NSString *endDate;
	__unsafe_unretained NSString *occurrenceDate;
	__unsafe_unretained NSString *startDate;
} ATOccurrenceCacheAttributes;

extern const struct ATOccurrenceCacheRelationships {
	__unsafe_unretained NSString *event;
} ATOccurrenceCacheRelationships;

extern const struct ATOccurrenceCacheFetchedProperties {
} ATOccurrenceCacheFetchedProperties;

@class ATEvent;






@interface ATOccurrenceCacheID : NSManagedObjectID {}
@end

@interface _ATOccurrenceCache : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ATOccurrenceCacheID*)objectID;





@property (nonatomic, strong) NSDate* day;



//- (BOOL)validateDay:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* endDate;



//- (BOOL)validateEndDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* occurrenceDate;



//- (BOOL)validateOccurrenceDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startDate;



//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) ATEvent *event;

//- (BOOL)validateEvent:(id*)value_ error:(NSError**)error_;





@end

@interface _ATOccurrenceCache (CoreDataGeneratedAccessors)

@end

@interface _ATOccurrenceCache (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveDay;
- (void)setPrimitiveDay:(NSDate*)value;




- (NSDate*)primitiveEndDate;
- (void)setPrimitiveEndDate:(NSDate*)value;




- (NSDate*)primitiveOccurrenceDate;
- (void)setPrimitiveOccurrenceDate:(NSDate*)value;




- (NSDate*)primitiveStartDate;
- (void)setPrimitiveStartDate:(NSDate*)value;





- (ATEvent*)primitiveEvent;
- (void)setPrimitiveEvent:(ATEvent*)value;


@end
