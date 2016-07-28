//
//  UserTableViewCell.m
//  Fanner
//
//  Created by 赵麦 on 7/26/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "UserTableViewCell.h"
#import "User.h"
#import <UIImageView+WebCache.h>

@implementation UserTableViewCell

-(void)configureWithUser:(User *)user {
    self.nameLabel.text = user.name;
    self.idLabel.text = user.uid;
    
    NSURL *url = [NSURL URLWithString:user.iconURL];
    [self.iconImageView sd_setImageWithURL:url
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
