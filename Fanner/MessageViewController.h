//
//  MessageViewController.h
//  Fanner
//
//  Created by 赵麦 on 8/8/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSQMessagesViewController/JSQMessagesViewController.h>

@interface MessageViewController : JSQMessagesViewController
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *otherID;
@end
