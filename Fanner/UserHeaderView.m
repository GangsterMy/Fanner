//
//  UserHeaderView.m
//  Fanner
//
//  Created by 赵麦 on 8/9/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "UserHeaderView.h"
#import "CoreDataStack+User.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "User+CoreDataProperties.h"

@interface UserHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *idLbl;
@property (weak, nonatomic) IBOutlet UIButton *followingBtn;
@property (weak, nonatomic) IBOutlet UIButton *followerBtn;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;


@end

@implementation UserHeaderView
- (IBAction)followingBtn:(id)sender {
}
- (IBAction)followersBtn:(id)sender {
}
- (IBAction)statusBtn:(id)sender {
}
- (IBAction)modifyBtn:(id)sender {
}

- (void)awakeFromNib {
    [self configureView];
}

-(void)configureView {
    User *user = [CoreDataStack sharedCoreDataStack].currentUser;
    NSURL *url = [NSURL URLWithString:user.iconURL];
    [_iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"BackgroundAvatar"] options:SDWebImageProgressiveDownload];
    
    _nameLbl.text = user.name;
    _idLbl.text = user.uid;
    
   
    NSString *_followers = [NSString stringWithFormat:@"%@关注我的人", user.followers_count];
    [_followerBtn setTitle:_followers forState:UIControlStateNormal];
    
    NSString *_following = [NSString stringWithFormat:@"%@关注的人", user.friends_count];
    [_followingBtn setTitle:_following forState:UIControlStateNormal];
    
    NSString *status_count = [NSString stringWithFormat:@"%@消息", user.statuses_count];
    [_statusBtn setTitle:status_count forState:UIControlStateNormal];
    
    [_modifyBtn setTitle:@"修改个人信息" forState:UIControlStateNormal];
    
}


@end
