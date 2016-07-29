//
//  TimeLineTableViewCell.m
//  Fanner
//
//  Created by 赵麦 on 7/28/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "TimeLineTableViewCell.h"
#import "User.h"
#import <UIImageView+WebCache.h>
#import "Status+CoreDataProperties.h"

@implementation TimeLineTableViewCell

-(void)configureWithStatus:(Status *)status {
    self.nameLabel.text = status.user.name;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSFormattingUnitStyleShort;
    formatter.timeStyle = NSFormattingUnitStyleShort;
    
    self.publishLabel.text = [formatter stringFromDate:status.created_at ];
    self.contentLabel.text = status.text;
    
    NSURL *url = [NSURL URLWithString:status.user.iconURL];
    [self.iconImage sd_setImageWithURL:url
                      placeholderImage:nil
                               options:SDWebImageRefreshCached];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
