//
//  ATAppDelegate.h
//  ATCalendarDemo
//
//  Created by Adrian Tofan on 14/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
