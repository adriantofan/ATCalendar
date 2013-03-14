// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATEvent.m instead.

#import "_ATEvent.h"

const struct ATEventAttributes ATEventAttributes = {
	.endDate = @"endDate",
	.location = @"location",
	.notes = @"notes",
	.startDate = @"startDate",
	.summary = @"summary",
	.url = @"url",
};

const struct ATEventRelationships ATEventRelationships = {
	.recurences = @"recurences",
};

const struct ATEventFetchedProperties ATEventFetchedProperties = {
};

@implementation ATEventID
@end

@implementation _ATEvent

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Event";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Event" inManagedObjectContext:moc_];
}

- (ATEventID*)objectID {
	return (ATEventID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic endDate;






@dynamic location;






@dynamic notes;






@dynamic startDate;






@dynamic summary;






@dynamic url;






@dynamic recurences;

	
- (NSMutableSet*)recurencesSet {
	[self willAccessValueForKey:@"recurences"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"recurences"];
  
	[self didAccessValueForKey:@"recurences"];
	return result;
}
	






@end
