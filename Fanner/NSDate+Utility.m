//
//  NSDate+Utility.m
//  Fanner
//
//  Created by 赵麦 on 8/9/16.
//  Copyright © 2016 歹徒. All rights reserved.
//

#import "NSDate+Utility.h"

@implementation NSDate (Utility)

-(NSString *)defaultDateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.dateStyle = NSDateFormatterShortStyle;
    
    return [formatter stringFromDate:self];
}


@end
