//
//  ATEventTextViewCell.h
//  ATCalendar
//
//  Created by Adrian Tofan on 22/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATPlaceHolderTextView.h"

@interface ATEventTextViewCell : UITableViewCell

@property (nonatomic,readonly) ATPlaceHolderTextView* textView;
@end
