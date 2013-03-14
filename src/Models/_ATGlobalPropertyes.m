// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATGlobalPropertyes.m instead.

#import "_ATGlobalPropertyes.h"

const struct ATGlobalPropertyesAttributes ATGlobalPropertyesAttributes = {
	.key = @"key",
	.value = @"value",
};

const struct ATGlobalPropertyesRelationships ATGlobalPropertyesRelationships = {
};

const struct ATGlobalPropertyesFetchedProperties ATGlobalPropertyesFetchedProperties = {
};

@implementation ATGlobalPropertyesID
@end

@implementation _ATGlobalPropertyes

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"GlobalPropertyes" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"GlobalPropertyes";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"GlobalPropertyes" inManagedObjectContext:moc_];
}

- (ATGlobalPropertyesID*)objectID {
	return (ATGlobalPropertyesID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic key;






@dynamic value;











@end
