// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATYearleyRecurrence.m instead.

#import "_ATYearleyRecurrence.h"

const struct ATYearleyRecurrenceAttributes ATYearleyRecurrenceAttributes = {
};

const struct ATYearleyRecurrenceRelationships ATYearleyRecurrenceRelationships = {
};

const struct ATYearleyRecurrenceFetchedProperties ATYearleyRecurrenceFetchedProperties = {
};

@implementation ATYearleyRecurrenceID
@end

@implementation _ATYearleyRecurrence

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

- (ATYearleyRecurrenceID*)objectID {
	return (ATYearleyRecurrenceID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
