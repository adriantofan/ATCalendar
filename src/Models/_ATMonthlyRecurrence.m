// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATMonthlyRecurrence.m instead.

#import "_ATMonthlyRecurrence.h"

const struct ATMonthlyRecurrenceAttributes ATMonthlyRecurrenceAttributes = {
};

const struct ATMonthlyRecurrenceRelationships ATMonthlyRecurrenceRelationships = {
};

const struct ATMonthlyRecurrenceFetchedProperties ATMonthlyRecurrenceFetchedProperties = {
};

@implementation ATMonthlyRecurrenceID
@end

@implementation _ATMonthlyRecurrence

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MonthlyRecurrence" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MonthlyRecurrence";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MonthlyRecurrence" inManagedObjectContext:moc_];
}

- (ATMonthlyRecurrenceID*)objectID {
	return (ATMonthlyRecurrenceID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
