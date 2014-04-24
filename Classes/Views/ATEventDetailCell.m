//
//  ATEventDetailCell.m
//  ATCalendar
//
//  Created by Adrian Tofan on 20/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATEventDetailCell.h"
#import <Quartzcore/QuartzCore.h>
#import "ATCalendarUIConfig.h"


#define DESCRIPTION_FONT_SIZE 14.0f
#define SUBTITLE_FONT_SIZE 14.0f
#define TITLE_FONT_SIZE 14.0
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 15.0f
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




+(CGFloat)heightWithTitle:(NSString*)title subtitle:(NSString*)subtitle description:(NSString*)description{
  CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
  NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  [style setLineBreakMode:NSLineBreakByWordWrapping];
  
  CGRect titleRect = [title boundingRectWithSize:constraint
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:titleFont(),NSParagraphStyleAttributeName: style}
                                           context:nil];
  CGRect subtitleRect = [subtitle boundingRectWithSize:constraint
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:subtitleFont(),NSParagraphStyleAttributeName: style}
                                            context:nil];
  CGRect descriptionRect = [description boundingRectWithSize:constraint
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:descriptionFont(),NSParagraphStyleAttributeName: style}
                                                      context:nil];

  CGFloat lineCount = 0.0f;
  if (ceil(titleRect.size.height) != 0.0f) lineCount += 1.0f;
  if (ceil(subtitleRect.size.height) != 0.0f) lineCount += 1.0f;
  if (ceil(descriptionRect.size.height) != 0.0f) lineCount += 1.0f;
  CGFloat lineSpacing = 0.0f;
  if (lineCount != 0.0f) {
    lineSpacing = (lineCount-1.0)*VERTICAL_SPACING;
  }
  
  CGFloat height = MAX(ceil(titleRect.size.height)+ ceil(subtitleRect.size.height) + ceil(descriptionRect.size.height) + lineSpacing, 44.0f);
  return height + (CELL_CONTENT_MARGIN * 2);

}
-(void)setTitle:(NSString*)title subtitle:(NSString*)subtitle description:(NSString*)description{
  CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
  NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  [style setLineBreakMode:NSLineBreakByWordWrapping];

  CGRect titleRect = [title boundingRectWithSize:constraint
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:titleFont(),NSParagraphStyleAttributeName: style}
                                         context:nil];

  float y = CELL_CONTENT_MARGIN;
  [titleLabel_ setText:title];
  CGRect titleFrame = CGRectMake(CELL_CONTENT_MARGIN, y, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), ceill(titleRect.size.height));
  [titleLabel_ setFrame:titleFrame];
  CGRect subtitleRect = [subtitle boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:subtitleFont(),NSParagraphStyleAttributeName: style}
                                               context:nil];

  
  if ((titleFrame.size.height != 0.0f) && (ceill(subtitleRect.size.height) != 0.0f) )
    y = VERTICAL_SPACING + CGRectGetMaxY(titleFrame);
  
  CGRect subtitleFrame =
      CGRectMake(CELL_CONTENT_MARGIN,
                 y,
                 CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2.0f),
                 ceill(subtitleRect.size.height));
  subtitleLabel_.text = subtitle;
  [subtitleLabel_ setFrame:subtitleFrame];
  
  
  CGRect descriptionRect = [description boundingRectWithSize:constraint
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:descriptionFont(),NSParagraphStyleAttributeName: style}
                                                     context:nil];

  
  if (subtitleFrame.size.height != 0.0f)
    y = VERTICAL_SPACING + CGRectGetMaxY(subtitleFrame);
  else if (titleFrame.size.height != 0.0f) y = VERTICAL_SPACING + CGRectGetMaxY(titleFrame);

  CGRect descriptionFrame =
  CGRectMake(CELL_CONTENT_MARGIN,
             y,
             CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2.0f),
             ceill(descriptionRect.size.height));
  descriptionLabel_.text = description;
  [descriptionLabel_ setFrame:descriptionFrame];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
      UIColor* c = [[ATCalendarUIConfig sharedConfig] tableViewCellDetailLabelCollor];
      titleLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
      subtitleLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
      descriptionLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
      [self.contentView addSubview:titleLabel_];
      [self.contentView addSubview:subtitleLabel_];
      [self.contentView addSubview:descriptionLabel_];
      [titleLabel_ setLineBreakMode:NSLineBreakByWordWrapping];
      [titleLabel_ setFont:titleFont()];
      [titleLabel_ setNumberOfLines:20];
      titleLabel_.backgroundColor = [UIColor clearColor];
      [subtitleLabel_ setLineBreakMode:NSLineBreakByWordWrapping];
      [subtitleLabel_ setFont:subtitleFont()];
      subtitleLabel_.textColor = c;
      subtitleLabel_.backgroundColor = [UIColor clearColor];
      [subtitleLabel_ setNumberOfLines:20];
      [descriptionLabel_ setLineBreakMode:NSLineBreakByWordWrapping];
      [descriptionLabel_ setFont:descriptionFont()];
      [descriptionLabel_ setNumberOfLines:20];
      descriptionLabel_.textColor = c;
      descriptionLabel_.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
