// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATGlobalPropertyes.h instead.

#import <CoreData/CoreData.h>


extern const struct ATGlobalPropertyesAttributes {
	__unsafe_unretained NSString *key;
	__unsafe_unretained NSString *value;
} ATGlobalPropertyesAttributes;

extern const struct ATGlobalPropertyesRelationships {
} ATGlobalPropertyesRelationships;

extern const struct ATGlobalPropertyesFetchedProperties {
} ATGlobalPropertyesFetchedProperties;





@interface ATGlobalPropertyesID : NSManagedObjectID {}
@end

@interface _ATGlobalPropertyes : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ATGlobalPropertyesID*)objectID;





@property (nonatomic, strong) NSString* key;



//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* value;



//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;






@end

@interface _ATGlobalPropertyes (CoreDataGeneratedAccessors)

@end

@interface _ATGlobalPropertyes (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;




- (NSString*)primitiveValue;
- (void)setPrimitiveValue:(NSString*)value;




@end
