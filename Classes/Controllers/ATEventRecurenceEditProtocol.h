//
//  ATEventRecurenceEditProtocol.h
//  ATCalendar
//
//  Created by Adrian Tofan on 13/11/12.
//  Copyright (c) 2012 Adrian Tofan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ATEventRecurenceEditProtocol <NSObject>
-(IBAction)eventRecurenceEditSaved:(UIStoryboardSegue *)segue;
-(IBAction)eventRecurenceEditCanceled:(UIStoryboardSegue *)segue;
@end
