//
//  PhotoCollectionViewCell.m
//  Fanner
//
//  Created by 赵麦 on 8/10/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "Status.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PhotoCollectionViewCell

- (void)configureCellWithStatus:(Status *)status {
    NSURL *photoURL = [NSURL URLWithString:status.photo.thumburl];
    [_photoImageview sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"BackgroundAvatar"] options:SDWebImageProgressiveDownload];
}

@end
