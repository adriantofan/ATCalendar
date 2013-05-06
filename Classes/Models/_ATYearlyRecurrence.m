// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATYearlyRecurrence.m instead.

#import "_ATYearlyRecurrence.h"

const struct ATYearlyRecurrenceAttributes ATYearlyRecurrenceAttributes = {
};

const struct ATYearlyRecurrenceRelationships ATYearlyRecurrenceRelationships = {
};

const struct ATYearlyRecurrenceFetchedProperties ATYearlyRecurrenceFetchedProperties = {
};

@implementation ATYearlyRecurrenceID
@end

@implementation _ATYearlyRecurrence

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"YearlyRecurrence" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"YearlyRecurrence";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"YearlyRecurrence" inManagedObjectContext:moc_];
}

- (ATYearlyRecurrenceID*)objectID {
	return (ATYearlyRecurrenceID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
