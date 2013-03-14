// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATOccurrenceCache.m instead.

#import "_ATOccurrenceCache.h"

const struct ATOccurrenceCacheAttributes ATOccurrenceCacheAttributes = {
	.day = @"day",
	.occurrenceDate = @"occurrenceDate",
	.occurrenceEnd = @"occurrenceEnd",
};

const struct ATOccurrenceCacheRelationships ATOccurrenceCacheRelationships = {
	.event = @"event",
};

const struct ATOccurrenceCacheFetchedProperties ATOccurrenceCacheFetchedProperties = {
};

@implementation ATOccurrenceCacheID
@end

@implementation _ATOccurrenceCache

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"OccurrenceCache" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"OccurrenceCache";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"OccurrenceCache" inManagedObjectContext:moc_];
}

- (ATOccurrenceCacheID*)objectID {
	return (ATOccurrenceCacheID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic day;






@dynamic occurrenceDate;






@dynamic occurrenceEnd;






@dynamic event;

	






@end
