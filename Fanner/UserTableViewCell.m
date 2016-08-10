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
#import "Conversation.h"
#import "Message.h"

@implementation UserTableViewCell

-(void)configureWithUser:(User *)user {
    self.nameLabel.text = user.name;
    self.idLabel.text = user.uid;
    
    NSURL *url = [NSURL URLWithString:user.iconURL];
    [self.iconImageView sd_setImageWithURL:url
                          placeholderImage:[UIImage imageNamed:@"BackgroundAvatar"]
                                    options:SDWebImageRefreshCached];
}
-(void)configureWithConversation:(Conversation *)conversation {
    
    if ([conversation.otherid isEqualToString:conversation.message.sender.uid]) {
        self.nameLabel.text = conversation.message.sender_screen_name;
        NSURL *url = [NSURL URLWithString:conversation.message.sender.iconURL];
        [self.iconImageView sd_setImageWithURL:url
                              placeholderImage:[UIImage imageNamed:@"BackgroundAvatar"]
                                       options:SDWebImageRefreshCached];

    } else {
        self.nameLabel.text = conversation.message.recipient_screen_name;
        NSURL *url = [NSURL URLWithString:conversation.message.recipient.iconURL];
        [self.iconImageView sd_setImageWithURL:url
                              placeholderImage:[UIImage imageNamed:@"BackgroundAvatar"]
                                       options:SDWebImageRefreshCached];

    }
    
    self.idLabel.text = conversation.otherid;
    
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
