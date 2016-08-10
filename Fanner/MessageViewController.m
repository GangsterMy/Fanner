//
//  MessageViewController.m
//  Fanner
//
//  Created by 赵麦 on 8/8/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "MessageViewController.h"
#import "Service+Conversation.h"
#import "CoreDataStack+Message.h"
#import <JSQMessagesBubbleImageFactory.h>
#import <JSQMessagesViewController/UIColor+JSQMessages.h>
#import <JSQMessagesViewController/JSQMessagesBubbleImage.h>
#import "Message.h"
#import "User.h"
#import "CoreDataStack+User.h"
#import <JSQMessage.h>
#import <JSQMessagesViewController/JSQMessagesCollectionViewCell.h>
#import "NSDate+Utility.h"

@interface MessageViewController ()
@property (nonatomic, strong) NSArray *messageList;
@property (nonatomic, strong) JSQMessagesBubbleImage *incomingBubble;
@property (nonatomic, strong) JSQMessagesBubbleImage *outgoingBubble;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation MessageViewController

-(void)refreshData {
    [[Service sharedInstance] conversationWithUserID:_otherID succes:^(NSArray *result) {
        //insert all messages to 数据库(内存)
        [[CoreDataStack sharedCoreDataStack] addMessageWithArray:result];
        //查到所有当前会话的messages并复制给_messageList
        _messageList = [[CoreDataStack sharedCoreDataStack] fetchMessageWithUserID:_otherID];
        //重载继承自父类的collectionView
        [self.collectionView reloadData];
        //把scrollView移动到底部
        [self scrollToBottomAnimated:YES];
        
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self addTimer];
    
    _currentUser = [[CoreDataStack sharedCoreDataStack] currentUser];
    JSQMessagesBubbleImageFactory *factory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.incomingBubble = [factory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.outgoingBubble = [factory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    
    [self refreshData];
}

-(void)addTimer {
    //NSRunLoop
    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}



#pragma mark = JSQMessagesCollectionViewDataSource
//@require
- (NSString *)senderDisplayName {
    return _currentUser.name;
}

- (NSString *)senderId {
    return  _currentUser.uid;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Message *mg = [_messageList objectAtIndex:indexPath.item];
    
    JSQMessage *jsm = [[JSQMessage alloc] initWithSenderId:mg.sender.uid senderDisplayName:self.senderDisplayName date:mg.created_at text:mg.text];
    return jsm;
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
};

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Message *mg = [_messageList objectAtIndex:indexPath.item];
    
    if ([mg.sender.uid isEqualToString:_currentUser.uid]) {
        
        return self.outgoingBubble;
        
    } else {
        
        return self.incomingBubble;
        
    }
}
//@protional
-(NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
   
    Message *mg = [_messageList objectAtIndex:indexPath.item];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *string = [formatter stringFromDate:mg.created_at];
    
//    NSAttributedString *dateStr = [[NSAttributedString alloc] initWithString:string];
    NSAttributedString *dateStr = [[NSAttributedString alloc] initWithString:mg.sender_screen_name ];


  //  return ;
    return dateStr;
    

}

-(CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}

#pragma mark - Collection View Datasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _messageList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *) [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    Message *mg = [_messageList objectAtIndex:indexPath.item];
    if ([mg.sender.uid isEqualToString:_currentUser.uid]) {
        cell.textView.textColor = [UIColor whiteColor];
    } else {
        cell.textView.textColor = [UIColor blackColor];
    }
    
    return cell;
}

#pragma mark - PostMessage
-(void)didPressAccessoryButton:(UIButton *)sender {
    
}


@end
