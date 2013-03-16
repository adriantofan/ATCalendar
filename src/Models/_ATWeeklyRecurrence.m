// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATWeeklyRecurrence.m instead.

#import "_ATWeeklyRecurrence.h"

const struct ATWeeklyRecurrenceAttributes ATWeeklyRecurrenceAttributes = {
	.dayOfWeek = @"dayOfWeek",
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
	
	if ([key isEqualToString:@"dayOfWeekValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"dayOfWeek"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic dayOfWeek;



- (int32_t)dayOfWeekValue {
	NSNumber *result = [self dayOfWeek];
	return [result intValue];
}

- (void)setDayOfWeekValue:(int32_t)value_ {
	[self setDayOfWeek:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveDayOfWeekValue {
	NSNumber *result = [self primitiveDayOfWeek];
	return [result intValue];
}

- (void)setPrimitiveDayOfWeekValue:(int32_t)value_ {
	[self setPrimitiveDayOfWeek:[NSNumber numberWithInt:value_]];
}










@end
