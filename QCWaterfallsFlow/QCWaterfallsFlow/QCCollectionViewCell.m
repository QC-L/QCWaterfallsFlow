//
//  QCCollectionViewCell.m
//  QCWaterfallsFlow
//
//  Created by QC.L on 15/9/9.
//  Copyright (c) 2015年 QC.L. All rights reserved.
//

#import "QCCollectionViewCell.h"
#import "QCPhoto.h"
#import "UIImageView+WebCache.h"

@interface QCCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *detail;
@end

@implementation QCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.detail = [[UILabel alloc] init];
        
        // 注意, 协议方法中按多大字体计算这里就按多少计算
        self.detail.font = [UIFont systemFontOfSize:10];
        
        self.detail.numberOfLines = 0;
        self.detail.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.detail];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)setPhoto:(QCPhoto *)photo
{
    // 重写set方法
    if (_photo != photo) {
        _photo = photo;
    }
    
    // 根据图片宽高, 计算imageView的高度
    CGFloat height = self.frame.size.width * [_photo.height floatValue] / [_photo.width floatValue];
    // 设置imageView的高度
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, height);
    
    // 赋值
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_photo.pic]];
    
    // 根据imageView计算Label高度
    self.detail.frame = CGRectMake(0, self.imageView.frame.size.height, self.frame.size.width, self.frame.size.height - self.imageView.frame.size.height);
    // 赋值
    self.detail.text = _photo.detail;
    
    
}
@end
