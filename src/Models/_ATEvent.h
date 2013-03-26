// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATEvent.h instead.

#import <CoreData/CoreData.h>


extern const struct ATEventAttributes {
	__unsafe_unretained NSString *allDay;
	__unsafe_unretained NSString *endDate;
	__unsafe_unretained NSString *firstAlertType;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *notes;
	__unsafe_unretained NSString *seccondAlertType;
	__unsafe_unretained NSString *startDate;
	__unsafe_unretained NSString *summary;
	__unsafe_unretained NSString *url;
} ATEventAttributes;

extern const struct ATEventRelationships {
	__unsafe_unretained NSString *recurence;
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





@property (nonatomic, strong) NSNumber* allDay;



@property BOOL allDayValue;
- (BOOL)allDayValue;
- (void)setAllDayValue:(BOOL)value_;

//- (BOOL)validateAllDay:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* endDate;



//- (BOOL)validateEndDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* firstAlertType;



@property int32_t firstAlertTypeValue;
- (int32_t)firstAlertTypeValue;
- (void)setFirstAlertTypeValue:(int32_t)value_;

//- (BOOL)validateFirstAlertType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* location;



//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* notes;



//- (BOOL)validateNotes:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* seccondAlertType;



@property int32_t seccondAlertTypeValue;
- (int32_t)seccondAlertTypeValue;
- (void)setSeccondAlertTypeValue:(int32_t)value_;

//- (BOOL)validateSeccondAlertType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startDate;



//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* summary;



//- (BOOL)validateSummary:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) ATRecurrence *recurence;

//- (BOOL)validateRecurence:(id*)value_ error:(NSError**)error_;





@end

@interface _ATEvent (CoreDataGeneratedAccessors)

@end

@interface _ATEvent (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAllDay;
- (void)setPrimitiveAllDay:(NSNumber*)value;

- (BOOL)primitiveAllDayValue;
- (void)setPrimitiveAllDayValue:(BOOL)value_;




- (NSDate*)primitiveEndDate;
- (void)setPrimitiveEndDate:(NSDate*)value;




- (NSNumber*)primitiveFirstAlertType;
- (void)setPrimitiveFirstAlertType:(NSNumber*)value;

- (int32_t)primitiveFirstAlertTypeValue;
- (void)setPrimitiveFirstAlertTypeValue:(int32_t)value_;




- (NSString*)primitiveLocation;
- (void)setPrimitiveLocation:(NSString*)value;




- (NSString*)primitiveNotes;
- (void)setPrimitiveNotes:(NSString*)value;




- (NSNumber*)primitiveSeccondAlertType;
- (void)setPrimitiveSeccondAlertType:(NSNumber*)value;

- (int32_t)primitiveSeccondAlertTypeValue;
- (void)setPrimitiveSeccondAlertTypeValue:(int32_t)value_;




- (NSDate*)primitiveStartDate;
- (void)setPrimitiveStartDate:(NSDate*)value;




- (NSString*)primitiveSummary;
- (void)setPrimitiveSummary:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (ATRecurrence*)primitiveRecurence;
- (void)setPrimitiveRecurence:(ATRecurrence*)value;


@end
