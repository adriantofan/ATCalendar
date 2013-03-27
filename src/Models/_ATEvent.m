// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATEvent.m instead.

#import "_ATEvent.h"

const struct ATEventAttributes ATEventAttributes = {
	.allDay = @"allDay",
	.busy = @"busy",
	.endDate = @"endDate",
	.firstAlertType = @"firstAlertType",
	.location = @"location",
	.notes = @"notes",
	.seccondAlertType = @"seccondAlertType",
	.startDate = @"startDate",
	.summary = @"summary",
	.url = @"url",
};

const struct ATEventRelationships ATEventRelationships = {
	.recurence = @"recurence",
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
	
	if ([key isEqualToString:@"allDayValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"allDay"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"busyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"busy"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"firstAlertTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"firstAlertType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"seccondAlertTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"seccondAlertType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic allDay;



- (BOOL)allDayValue {
	NSNumber *result = [self allDay];
	return [result boolValue];
}

- (void)setAllDayValue:(BOOL)value_ {
	[self setAllDay:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveAllDayValue {
	NSNumber *result = [self primitiveAllDay];
	return [result boolValue];
}

- (void)setPrimitiveAllDayValue:(BOOL)value_ {
	[self setPrimitiveAllDay:[NSNumber numberWithBool:value_]];
}





@dynamic busy;



- (BOOL)busyValue {
	NSNumber *result = [self busy];
	return [result boolValue];
}

- (void)setBusyValue:(BOOL)value_ {
	[self setBusy:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveBusyValue {
	NSNumber *result = [self primitiveBusy];
	return [result boolValue];
}

- (void)setPrimitiveBusyValue:(BOOL)value_ {
	[self setPrimitiveBusy:[NSNumber numberWithBool:value_]];
}





@dynamic endDate;






@dynamic firstAlertType;



- (int32_t)firstAlertTypeValue {
	NSNumber *result = [self firstAlertType];
	return [result intValue];
}

- (void)setFirstAlertTypeValue:(int32_t)value_ {
	[self setFirstAlertType:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveFirstAlertTypeValue {
	NSNumber *result = [self primitiveFirstAlertType];
	return [result intValue];
}

- (void)setPrimitiveFirstAlertTypeValue:(int32_t)value_ {
	[self setPrimitiveFirstAlertType:[NSNumber numberWithInt:value_]];
}





@dynamic location;






@dynamic notes;






@dynamic seccondAlertType;



- (int32_t)seccondAlertTypeValue {
	NSNumber *result = [self seccondAlertType];
	return [result intValue];
}

- (void)setSeccondAlertTypeValue:(int32_t)value_ {
	[self setSeccondAlertType:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveSeccondAlertTypeValue {
	NSNumber *result = [self primitiveSeccondAlertType];
	return [result intValue];
}

- (void)setPrimitiveSeccondAlertTypeValue:(int32_t)value_ {
	[self setPrimitiveSeccondAlertType:[NSNumber numberWithInt:value_]];
}





@dynamic startDate;






@dynamic summary;






@dynamic url;






@dynamic recurence;

	






@end
