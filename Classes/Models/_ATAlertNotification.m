// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATAlertNotification.m instead.

#import "_ATAlertNotification.h"

const struct ATAlertNotificationAttributes ATAlertNotificationAttributes = {
	.notification = @"notification",
};

const struct ATAlertNotificationRelationships ATAlertNotificationRelationships = {
	.event = @"event",
};

const struct ATAlertNotificationFetchedProperties ATAlertNotificationFetchedProperties = {
};

@implementation ATAlertNotificationID
@end

@implementation _ATAlertNotification

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"AlertNotification" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"AlertNotification";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"AlertNotification" inManagedObjectContext:moc_];
}

- (ATAlertNotificationID*)objectID {
	return (ATAlertNotificationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic notification;






@dynamic event;

	






@end
