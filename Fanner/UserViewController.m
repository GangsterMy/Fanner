//
//  UserViewController.m
//  Fanner
//
//  Created by 赵麦 on 8/10/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "UserViewController.h"
#import "TimeLineTVC.h"
#import "PhotoBrowseViewController.h"
#import "CoreDataStack+User.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (NSString *)userID {
    if (_userID) {
        return _userID;
    }
    return [CoreDataStack sharedCoreDataStack].currentUser.uid;
    
}

-(UIView<ARSegmentPageControllerHeaderProtocol> *)customHeaderView {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:nil options:nil];
    return [views lastObject];
}

- (void)viewDidLoad {
    //取到已经生成的TimelineTableViewController对象
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TimeLine" bundle:nil];
    TimeLineTVC *timelineTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"TimeLineTVC"];
    //取到已经生成的PhotoBrowseViewController对象
    UIStoryboard *photoBrowse = [UIStoryboard storyboardWithName:@"PhotoBrowse" bundle:nil];
    PhotoBrowseViewController *photoBrowseViewController = [photoBrowse instantiateViewControllerWithIdentifier:@"PhotoBrowseViewController"];
    photoBrowseViewController.userID = self.userID;
    
    
    [self setViewControllers:@[timelineTableViewController,photoBrowseViewController]];
    self.segmentMiniTopInset = 64;//
    self.headerHeight = 250;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
