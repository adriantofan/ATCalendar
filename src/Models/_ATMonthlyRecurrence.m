// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATMonthlyRecurrence.m instead.

#import "_ATMonthlyRecurrence.h"

const struct ATMonthlyRecurrenceAttributes ATMonthlyRecurrenceAttributes = {
	.dayOfMonth = @"dayOfMonth",
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
	
	if ([key isEqualToString:@"dayOfMonthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"dayOfMonth"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic dayOfMonth;



- (int32_t)dayOfMonthValue {
	NSNumber *result = [self dayOfMonth];
	return [result intValue];
}

- (void)setDayOfMonthValue:(int32_t)value_ {
	[self setDayOfMonth:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveDayOfMonthValue {
	NSNumber *result = [self primitiveDayOfMonth];
	return [result intValue];
}

- (void)setPrimitiveDayOfMonthValue:(int32_t)value_ {
	[self setPrimitiveDayOfMonth:[NSNumber numberWithInt:value_]];
}










@end
