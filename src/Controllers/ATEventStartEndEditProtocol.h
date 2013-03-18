//
//  ATEventStartEndEditProtocol.h
//  ATCalendar
//
//  Created by Adrian Tofan on 13/11/12.
//  Copyright (c) 2012 Adrian Tofan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ATEventStartEndEditProtocol <NSObject>
-(IBAction)eventStartEndEditSaved:(UIStoryboardSegue *)segue;
-(IBAction)eventStartEndEditCanceled:(UIStoryboardSegue *)segue;
@end
