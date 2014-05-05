//
//  ATEvent+LocalNotifications.h
//  ATCalendar
//
//  Created by Adrian Tofan on 27/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATEvent.h"
extern NSString* const ATEventURIKey;
@interface ATEvent (LocalNotifications)

-(void)scheduleLocalNotificationForOccurenceStart:(NSDate*)eventStart;
-(void)removeExistingLocalNotifications;
-(void)updateLocalNotificationsAfterChange;
-(void)removeLocalNotificationsBeforeDelete;
// Returns the body of a reminder notification (default self.summary)
-(NSString*)notificationBody;
// A selector to invoke on self when the notificationBody is requested
+(void)setNotificationBodyFormaterSelector:(SEL)selector;
+(SEL)notificationBodyFormaterSelector;
-(UILocalNotification*)notificationWithDate:(NSDate*)eventStart alertType:(ATEventAlertType)type;
@end