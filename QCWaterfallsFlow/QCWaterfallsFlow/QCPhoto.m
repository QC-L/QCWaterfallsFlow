//
//  QCPhoto.m
//  QCWaterfallsFlow
//
//  Created by QC.L on 15/9/9.
//  Copyright (c) 2015年 QC.L. All rights reserved.
//

#import "QCPhoto.h"

@implementation QCPhoto

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (CGFloat)heightForDetail:(UIFont *)font width:(CGFloat)width
{
    CGRect rect = [self.detail boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
    return ceil(rect.size.height);
    
}

@end
