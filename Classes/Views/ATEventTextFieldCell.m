//
//  ATTextFieldCell.m
//  
//
//  Created by Adrian Tofan on 11/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATEventTextFieldCell.h"

@implementation ATEventTextFieldCell
@synthesize  textField = textField_;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
    textField_ = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:textField_];
  }
  return self;
}
-(void)updateLayout{
  CGRect frame = self.contentView.bounds;
  frame.origin.x = 15.0;
  frame.origin.y = 11.0;
  frame.size.width -= 30.0;
  frame.size.height = 21.0;
  textField_.frame = frame;
//  textField_.center = self.contentView.center;
}

-(void)setFrame:(CGRect)frame{
  [super setFrame:frame];
  [self updateLayout];
}
-(void)layoutSubviews{
  [super layoutSubviews];
  [self updateLayout];
}

@end
