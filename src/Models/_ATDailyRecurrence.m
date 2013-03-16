// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATDailyRecurrence.m instead.

#import "_ATDailyRecurrence.h"

const struct ATDailyRecurrenceAttributes ATDailyRecurrenceAttributes = {
};

const struct ATDailyRecurrenceRelationships ATDailyRecurrenceRelationships = {
};

const struct ATDailyRecurrenceFetchedProperties ATDailyRecurrenceFetchedProperties = {
};

@implementation ATDailyRecurrenceID
@end

@implementation _ATDailyRecurrence

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DailyRecurrence" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DailyRecurrence";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DailyRecurrence" inManagedObjectContext:moc_];
}

- (ATDailyRecurrenceID*)objectID {
	return (ATDailyRecurrenceID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
