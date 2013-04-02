//
//  ATEventOccurenceCell.m
//  DopplerBebe
//
//  Created by Adrian Tofan on 02/04/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATEventOccurenceCell.h"

@implementation ATEventOccurenceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
      self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
      self.summaryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
      self.icon = [[UIImageView alloc] initWithFrame:CGRectZero];
      self.summaryLabel.numberOfLines = 2;
      self.timeLabel.numberOfLines = 3;
      self.summaryLabel.lineBreakMode = NSLineBreakByCharWrapping;
      self.summaryLabel.font = [UIFont boldSystemFontOfSize:20.0];
      self.timeLabel.font = [UIFont boldSystemFontOfSize:10.0];
      self.timeLabel.textAlignment = NSTextAlignmentCenter;
      self.icon.contentMode = UIViewContentModeCenter;

      [self.contentView addSubview:self.timeLabel];
      [self.contentView addSubview:self.summaryLabel];
      [self.contentView addSubview:self.icon];
    }
    return self;
}

// |10|-23--|10|-36--|10|--------------------------|10|

// |-----------|-----|--|--------------------------|--|
// |--|-----|--|-----|--|--------------------------|--|
// |--|-img-|--|time-|--|-summary------------------|--|
// |--|-----|--|-----|--|--------------------------|--|
// |-----------|-----|--|--------------------------|--|
-(void)updateLayout{
  CGRect frame = self.contentView.frame;
  static const float ds = 10.0;
  static const float di = 23.0;
  static const float dt = 36.0;
  CGRect iconFrame = CGRectMake(ds,ds,di,frame.size.height-ds-ds);
  CGRect timeFrame = CGRectMake(ds+CGRectGetMaxX(iconFrame),0.0,dt,frame.size.height);
  CGRect summaryFrame = CGRectMake(ds+CGRectGetMaxX(timeFrame),0.0,frame.size.width - ds- ds-CGRectGetMaxX(timeFrame),frame.size.height);
  self.timeLabel.frame  = timeFrame;
  self.summaryLabel.frame = summaryFrame;
  self.icon.frame = iconFrame;
}



-(void)setFrame:(CGRect)frame{
  [super setFrame:frame];
  [self updateLayout];
}
-(void)layoutSubviews{
  [super layoutSubviews];
  [self updateLayout];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
