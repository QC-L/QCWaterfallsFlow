//
//  QCPhoto.h
//  QCWaterfallsFlow
//
//  Created by QC.L on 15/9/9.
//  Copyright (c) 2015年 QC.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QCPhoto : NSObject

@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *detail;


@property (nonatomic, copy) NSString *detailHeight;
@property (nonatomic, copy) NSString *imageHeight;

- (instancetype)initWithDic:(NSDictionary *)dic;

- (CGFloat)heightForDetail:(UIFont *)font width:(CGFloat)width;

@end
