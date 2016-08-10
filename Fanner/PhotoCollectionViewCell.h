//
//  PhotoCollectionViewCell.h
//  Fanner
//
//  Created by 赵麦 on 8/10/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Status;

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageview;
- (void)configureCellWithStatus:(Status *)status;

@end
