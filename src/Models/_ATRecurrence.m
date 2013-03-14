// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATRecurrence.m instead.

#import "_ATRecurrence.h"

const struct ATRecurrenceAttributes ATRecurrenceAttributes = {
	.endDate = @"endDate",
	.interval = @"interval",
	.startDate = @"startDate",
	.type = @"type",
};

const struct ATRecurrenceRelationships ATRecurrenceRelationships = {
	.event = @"event",
};

const struct ATRecurrenceFetchedProperties ATRecurrenceFetchedProperties = {
};

@implementation ATRecurrenceID
@end

@implementation _ATRecurrence

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Recurrence" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Recurrence";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Recurrence" inManagedObjectContext:moc_];
}

- (ATRecurrenceID*)objectID {
	return (ATRecurrenceID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"intervalValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"interval"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"typeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"type"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic endDate;






@dynamic interval;



- (int16_t)intervalValue {
	NSNumber *result = [self interval];
	return [result shortValue];
}

- (void)setIntervalValue:(int16_t)value_ {
	[self setInterval:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveIntervalValue {
	NSNumber *result = [self primitiveInterval];
	return [result shortValue];
}

- (void)setPrimitiveIntervalValue:(int16_t)value_ {
	[self setPrimitiveInterval:[NSNumber numberWithShort:value_]];
}





@dynamic startDate;






@dynamic type;



- (int16_t)typeValue {
	NSNumber *result = [self type];
	return [result shortValue];
}

- (void)setTypeValue:(int16_t)value_ {
	[self setType:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveTypeValue {
	NSNumber *result = [self primitiveType];
	return [result shortValue];
}

- (void)setPrimitiveTypeValue:(int16_t)value_ {
	[self setPrimitiveType:[NSNumber numberWithShort:value_]];
}





@dynamic event;

	






@end
