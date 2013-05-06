//
//  ATTimeSpan.h
//  ATCalendar
//
//  Created by Adrian Tofan on 15/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATTimeSpan : NSObject
@property (nonatomic,readonly) NSDate * start;
@property (nonatomic,readonly) NSDate * end;

-(id)initFrom:(NSDate*)start to:(NSDate*)end;
+(ATTimeSpan*)timeSpanFrom:(NSDate*)start to:(NSDate*)end;

@end