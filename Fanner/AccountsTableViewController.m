//
//  AccountsTableViewController.m
//  Fanner
//
//  Created by 赵麦 on 7/26/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "AccountsTableViewController.h"
#import "CoreDataStack+User.h"
#import "UserTableViewCell.h"
#import "User.h"

@implementation AccountsTableViewController

-(void)configureFetch {
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSArray *descriptors = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    fr.sortDescriptors = descriptors;
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fr managedObjectContext:[CoreDataStack sharedCoreDataStack].context sectionNameKeyPath:nil cacheName:nil];
    
    self.frc.delegate = self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
}

#pragma mark - table view data source
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    
    User *user = [self.frc objectAtIndexPath:indexPath];
    [cell configureWithUser:user];
    
    return cell;
}

#pragma mark - table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = [self.frc objectAtIndexPath:indexPath];
    user.isActive = @YES;
}

@end
