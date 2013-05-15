//
//  ATEventTextViewCell.m
//  ATCalendar
//
//  Created by Adrian Tofan on 22/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATEventTextViewCell.h"

@implementation ATEventTextViewCell
@synthesize textView = textView_;

-(void)setFrame:(CGRect)frame{
  [super setFrame:frame];
  CGRect contentFrame = self.contentView.frame;
  CGRect fieldFrame = CGRectMake(5.0, 5.0, contentFrame.size.width - 10.0, contentFrame.size.height - 10.0);
  [textView_ setFrame:fieldFrame];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    textView_ = [[ATPlaceHolderTextView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:textView_];
  }
  return self;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
  [super setEditing:editing animated:(BOOL)animated];
  if (editing) {
    textView_.userInteractionEnabled = YES;
  }else{
    textView_.userInteractionEnabled = NO;
  }
}
@end