//
//  UserTableViewCell.h
//  Fanner
//
//  Created by 赵麦 on 7/26/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Conversation;
@class User;
@interface UserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
-(void)configureWithUser:(User *)user;
-(void)configureWithConversation:(Conversation *)conversation;
@end
