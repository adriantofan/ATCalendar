//
//  ATEventDetailCell.m
//  ATCalendar
//
//  Created by Adrian Tofan on 20/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATEventDetailCell.h"
#import <Quartzcore/QuartzCore.h>

#define DESCRIPTION_FONT_SIZE 14.0f
#define SUBTITLE_FONT_SIZE 14.0f
#define TITLE_FONT_SIZE 14.0
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 10.0f
#define VERTICAL_SPACING  4.0f

UIFont* descriptionFont(){
  return [UIFont boldSystemFontOfSize:DESCRIPTION_FONT_SIZE];
}

UIFont* titleFont(){
  return [UIFont boldSystemFontOfSize:TITLE_FONT_SIZE];
}

UIFont* subtitleFont(){
  return [UIFont systemFontOfSize:SUBTITLE_FONT_SIZE];
}

@implementation ATEventDetailCell
@synthesize titleLabel = titleLabel_;
@synthesize subtitleLabel = subtitleLabel_;
@synthesize descriptionLabel = descriptionLabel_;




+(float)heightWithTitle:(NSString*)title subtitle:(NSString*)subtitle description:(NSString*)description{
  CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
  CGSize sizeTitle =
    [title sizeWithFont:titleFont()
      constrainedToSize:constraint
          lineBreakMode:NSLineBreakByWordWrapping];
  CGSize sizeSubTitle =
    [subtitle sizeWithFont:subtitleFont()
         constrainedToSize:constraint
             lineBreakMode:NSLineBreakByWordWrapping];
  CGSize sizeDescription =
  [description sizeWithFont:descriptionFont()
       constrainedToSize:constraint
           lineBreakMode:NSLineBreakByWordWrapping];
  float lineCount = 0.0f;
  if (sizeTitle.height != 0.0f) lineCount += 1.0f;
  if (sizeSubTitle.height != 0.0f) lineCount += 1.0f;
  if (sizeDescription.height != 0.0f) lineCount += 1.0f;
  float lineSpacing = 0.0f;
  if (lineCount != 0.0f) {
    lineSpacing = (lineCount-1.0)*VERTICAL_SPACING;
  }
  
  CGFloat height = MAX(sizeTitle.height+ sizeSubTitle.height + sizeDescription.height + lineSpacing, 44.0f);
  return height + (CELL_CONTENT_MARGIN * 2);

}
-(void)setTitle:(NSString*)title subtitle:(NSString*)subtitle description:(NSString*)description{
  CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
  CGSize size = [title sizeWithFont:titleFont()
                  constrainedToSize:constraint
                      lineBreakMode:NSLineBreakByWordWrapping];
  float y = CELL_CONTENT_MARGIN;
  [titleLabel_ setText:title];
  CGRect titleFrame = CGRectMake(CELL_CONTENT_MARGIN, y, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), size.height);
  [titleLabel_ setFrame:titleFrame];
  size = [subtitle sizeWithFont:subtitleFont()
              constrainedToSize:constraint
                  lineBreakMode:NSLineBreakByWordWrapping];
  
  if ((titleFrame.size.height != 0.0f) && (size.height != 0.0f) )
    y = VERTICAL_SPACING + CGRectGetMaxY(titleFrame);
  
  CGRect subtitleFrame =
      CGRectMake(CELL_CONTENT_MARGIN,
                 y,
                 CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2.0f),
                 size.height);
  subtitleLabel_.text = subtitle;
  [subtitleLabel_ setFrame:subtitleFrame];
  
  
  size = [description sizeWithFont:descriptionFont()
              constrainedToSize:constraint
                  lineBreakMode:NSLineBreakByWordWrapping];
  
  if (subtitleFrame.size.height != 0.0f)
    y = VERTICAL_SPACING + CGRectGetMaxY(subtitleFrame);
  else if (titleFrame.size.height != 0.0f) y = VERTICAL_SPACING + CGRectGetMaxY(titleFrame);

  CGRect descriptionFrame =
  CGRectMake(CELL_CONTENT_MARGIN,
             y,
             CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2.0f),
             size.height);
  descriptionLabel_.text = description;
  [descriptionLabel_ setFrame:descriptionFrame];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
      titleLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
      subtitleLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
      descriptionLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
      [self.contentView addSubview:titleLabel_];
      [self.contentView addSubview:subtitleLabel_];
      [self.contentView addSubview:descriptionLabel_];
      [titleLabel_ setLineBreakMode:NSLineBreakByWordWrapping];
      [titleLabel_ setFont:titleFont()];
      [titleLabel_ setNumberOfLines:20];
      [subtitleLabel_ setLineBreakMode:NSLineBreakByWordWrapping];
      [subtitleLabel_ setFont:subtitleFont()];
      [subtitleLabel_ setNumberOfLines:20];
      [descriptionLabel_ setLineBreakMode:NSLineBreakByWordWrapping];
      [descriptionLabel_ setFont:descriptionFont()];
      [descriptionLabel_ setNumberOfLines:20];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
