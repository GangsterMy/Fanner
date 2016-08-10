//
//  ConversationListVC.m
//  Fanner
//
//  Created by 赵麦 on 8/5/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "ConversationListVC.h"
#import "Service+Conversation.h"
#import "CoreDataStack+Conversation.h"
#import "EntityNameConstant.h"
#import "UserTableViewCell.h"
#import "Conversation.h"
#import "MessageViewController.h"

@implementation ConversationListVC

-(void)configureFetch {
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:CONVERSATION_ENTITY];
    NSArray *descriptors = @[[[NSSortDescriptor alloc] initWithKey:@"message.created_at" ascending:NO]];
    fr.sortDescriptors = descriptors;
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fr managedObjectContext:[CoreDataStack sharedCoreDataStack].context sectionNameKeyPath:nil cacheName:nil];
    
    self.frc.delegate = self;
}


-(void)viewDidLoad {
    [super viewDidLoad];
    //向服务请求用户列表(聊过天的)
    //    //coversation list api
    
    [[Service sharedInstance] conversationListWithSuccess:^(NSArray *result) {
        [[CoreDataStack sharedCoreDataStack] addConversationsWithArrayProfile:result];
        //当数据请求成功并插入数据了
        [self configureFetch];
        [self performFetch];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConversationrCell"];
    
    Conversation *conversation = [self.frc objectAtIndexPath:indexPath];
    [cell configureWithConversation:conversation];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    MessageViewController *messageViewController = segue.destinationViewController;
    messageViewController.hidesBottomBarWhenPushed = YES;
    Conversation *conversation = [self.frc objectAtIndexPath:indexPath];
    messageViewController.otherID = conversation.otherid;
}


@end
