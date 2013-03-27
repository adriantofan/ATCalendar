// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ATAlertNotification.h instead.

#import <CoreData/CoreData.h>


extern const struct ATAlertNotificationAttributes {
	__unsafe_unretained NSString *notification;
} ATAlertNotificationAttributes;

extern const struct ATAlertNotificationRelationships {
	__unsafe_unretained NSString *event;
} ATAlertNotificationRelationships;

extern const struct ATAlertNotificationFetchedProperties {
} ATAlertNotificationFetchedProperties;

@class ATEvent;

@class UILocalNotification;

@interface ATAlertNotificationID : NSManagedObjectID {}
@end

@interface _ATAlertNotification : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ATAlertNotificationID*)objectID;





@property (nonatomic, strong) UILocalNotification* notification;



//- (BOOL)validateNotification:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) ATEvent *event;

//- (BOOL)validateEvent:(id*)value_ error:(NSError**)error_;





@end

@interface _ATAlertNotification (CoreDataGeneratedAccessors)

@end

@interface _ATAlertNotification (CoreDataGeneratedPrimitiveAccessors)


- (UILocalNotification*)primitiveNotification;
- (void)setPrimitiveNotification:(UILocalNotification*)value;





- (ATEvent*)primitiveEvent;
- (void)setPrimitiveEvent:(ATEvent*)value;


@end
