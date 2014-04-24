//
//  ATEventDetailCell.h
//  ATCalendar
//
//  Created by Adrian Tofan on 20/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ATEventDetailCell : UITableViewCell
+(CGFloat)heightWithTitle:(NSString*)title subtitle:(NSString*)subtitle description:(NSString*)description;
-(void)setTitle:(NSString*)title subtitle:(NSString*)subtitle description:(NSString*)description;
@property (nonatomic) UILabel* titleLabel;
@property (nonatomic) UILabel* subtitleLabel;
@property (nonatomic) UILabel* descriptionLabel;

@end
