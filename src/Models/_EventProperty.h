// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EventProperty.h instead.

#import <CoreData/CoreData.h>


extern const struct EventPropertyAttributes {
	__unsafe_unretained NSString *key;
	__unsafe_unretained NSString *value;
} EventPropertyAttributes;

extern const struct EventPropertyRelationships {
	__unsafe_unretained NSString *event;
} EventPropertyRelationships;

extern const struct EventPropertyFetchedProperties {
} EventPropertyFetchedProperties;

@class ATEvent;


@class NSObject;

@interface EventPropertyID : NSManagedObjectID {}
@end

@interface _EventProperty : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (EventPropertyID*)objectID;





@property (nonatomic, strong) NSString* key;



//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) id value;



//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) ATEvent *event;

//- (BOOL)validateEvent:(id*)value_ error:(NSError**)error_;





@end

@interface _EventProperty (CoreDataGeneratedAccessors)

@end

@interface _EventProperty (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;




- (id)primitiveValue;
- (void)setPrimitiveValue:(id)value;





- (ATEvent*)primitiveEvent;
- (void)setPrimitiveEvent:(ATEvent*)value;


@end
