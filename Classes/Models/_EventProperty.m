// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EventProperty.m instead.

#import "_EventProperty.h"

const struct EventPropertyAttributes EventPropertyAttributes = {
	.key = @"key",
	.value = @"value",
};

const struct EventPropertyRelationships EventPropertyRelationships = {
	.event = @"event",
};

const struct EventPropertyFetchedProperties EventPropertyFetchedProperties = {
};

@implementation EventPropertyID
@end

@implementation _EventProperty

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"EventProperty" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"EventProperty";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"EventProperty" inManagedObjectContext:moc_];
}

- (EventPropertyID*)objectID {
	return (EventPropertyID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic key;






@dynamic value;






@dynamic event;

	






@end
