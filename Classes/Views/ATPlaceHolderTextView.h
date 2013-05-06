//
//  ATPlaceHolderTextView.h
//  ATCalendar
//
//  Created by Adrian Tofan on 22/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//  http://stackoverflow.com/questions/1328638/placeholder-in-uitextview

#import <UIKit/UIKit.h>

@interface ATPlaceHolderTextView : UITextView{
NSString *placeholder;
UIColor *placeholderColor;

@private
UILabel *placeHolderLabel;
}

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;
@end
