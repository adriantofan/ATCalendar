// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATWeeklyRecurrence.m instead.

#import "_ATWeeklyRecurrence.h"

const struct ATWeeklyRecurrenceAttributes ATWeeklyRecurrenceAttributes = {
};

const struct ATWeeklyRecurrenceRelationships ATWeeklyRecurrenceRelationships = {
};

const struct ATWeeklyRecurrenceFetchedProperties ATWeeklyRecurrenceFetchedProperties = {
};

@implementation ATWeeklyRecurrenceID
@end

@implementation _ATWeeklyRecurrence

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WeeklyRecurrence" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WeeklyRecurrence";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WeeklyRecurrence" inManagedObjectContext:moc_];
}

- (ATWeeklyRecurrenceID*)objectID {
	return (ATWeeklyRecurrenceID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
