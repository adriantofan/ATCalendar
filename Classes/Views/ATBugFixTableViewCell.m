//
//  ATBugFixTableViewCell.m
//  ATCalendar
//
//  Created by Adrian Tofan on 24/05/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATBugFixTableViewCell.h"

@implementation ATBugFixTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)awakeFromNib{
  [super awakeFromNib];
  for(NSLayoutConstraint *cellConstraint in self.constraints){
    [self removeConstraint:cellConstraint];
    id firstItem = cellConstraint.firstItem == self ? self.contentView : cellConstraint.firstItem;
    id seccondItem = cellConstraint.secondItem == self ? self.contentView : cellConstraint.secondItem;
    NSLayoutConstraint* contentViewConstraint =
    [NSLayoutConstraint constraintWithItem:firstItem
                                 attribute:cellConstraint.firstAttribute
                                 relatedBy:cellConstraint.relation
                                    toItem:seccondItem
                                 attribute:cellConstraint.secondAttribute
                                multiplier:cellConstraint.multiplier
                                  constant:cellConstraint.constant];
    [self.contentView addConstraint:contentViewConstraint];
  }
}
@end
