// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATEvent.h instead.

#import <CoreData/CoreData.h>


extern const struct ATEventAttributes {
	__unsafe_unretained NSString *endDate;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *notes;
	__unsafe_unretained NSString *startDate;
	__unsafe_unretained NSString *summary;
	__unsafe_unretained NSString *url;
} ATEventAttributes;

extern const struct ATEventRelationships {
	__unsafe_unretained NSString *recurences;
} ATEventRelationships;

extern const struct ATEventFetchedProperties {
} ATEventFetchedProperties;

@class ATRecurrence;








@interface ATEventID : NSManagedObjectID {}
@end

@interface _ATEvent : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ATEventID*)objectID;





@property (nonatomic, strong) NSDate* endDate;



//- (BOOL)validateEndDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* location;



//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* notes;



//- (BOOL)validateNotes:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startDate;



//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* summary;



//- (BOOL)validateSummary:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *recurences;

- (NSMutableSet*)recurencesSet;





@end

@interface _ATEvent (CoreDataGeneratedAccessors)

- (void)addRecurences:(NSSet*)value_;
- (void)removeRecurences:(NSSet*)value_;
- (void)addRecurencesObject:(ATRecurrence*)value_;
- (void)removeRecurencesObject:(ATRecurrence*)value_;

@end

@interface _ATEvent (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveEndDate;
- (void)setPrimitiveEndDate:(NSDate*)value;




- (NSString*)primitiveLocation;
- (void)setPrimitiveLocation:(NSString*)value;




- (NSString*)primitiveNotes;
- (void)setPrimitiveNotes:(NSString*)value;




- (NSDate*)primitiveStartDate;
- (void)setPrimitiveStartDate:(NSDate*)value;




- (NSString*)primitiveSummary;
- (void)setPrimitiveSummary:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (NSMutableSet*)primitiveRecurences;
- (void)setPrimitiveRecurences:(NSMutableSet*)value;


@end
