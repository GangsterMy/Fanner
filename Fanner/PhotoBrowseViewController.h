//
//  PhotoBrowseViewController.h
//  Fanner
//
//  Created by 赵麦 on 8/10/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <ARSegmentPager/ARSegmentPageController.h>

@interface PhotoBrowseViewController : UICollectionViewController <ARSegmentControllerDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSFetchedResultsController *frc;

@end
