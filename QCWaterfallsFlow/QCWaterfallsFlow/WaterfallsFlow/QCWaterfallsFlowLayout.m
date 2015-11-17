//
//  QCWaterfallsFlowLayout.m
//  QCWaterfallsFlow
//
//  Created by QC.L on 15/9/9.
//  Copyright (c) 2015年 QC.L. All rights reserved.
//

#import "QCWaterfallsFlowLayout.h"

// 自定义的Attributes, 增加一个photoHeight的属性
@interface QCWaterfallsFlowLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, assign) NSInteger photoHeight;

@end
// 实现Attributes
@implementation QCWaterfallsFlowLayoutAttributes

// 重写拷贝协议
- (id)copyWithZone:(NSZone *)zone
{
    QCWaterfallsFlowLayoutAttributes *pint = (QCWaterfallsFlowLayoutAttributes *)[super copyWithZone:zone];
    pint.photoHeight = self.photoHeight;
    return pint;
}
// 重写比较对象的方法
- (BOOL)isEqual:(id)object
{
    QCWaterfallsFlowLayoutAttributes *pinter;
    if ((pinter = object)) {
        // 如果高度相等
        if (pinter.photoHeight == self.photoHeight) {
            // 返回判断两对象的值
            return [super isEqual:object];
        }
    }
    return false;
}

@end


@interface QCWaterfallsFlowLayout ()
// 存放Attributes的数组
@property (nonatomic, strong) NSMutableArray *attributesArr;
// 详情高
@property (nonatomic, assign) CGFloat contentHeight;
// 详情宽
@property (nonatomic, assign) CGFloat contentWidth;

@end
// 实现自定义的flowLayout
@implementation QCWaterfallsFlowLayout

//重写初始化方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化数组
        self.attributesArr = [NSMutableArray array];
        // 初始化行数(如果外部赋值, 以外部为准)
        self.numberOfColumns = 2;
        // 初始化cell的间距
        self.cellPadding = 2.0;
        // 初始化详情高
        self.contentHeight = 0.0;
    }
    return self;
}

// contentWidth的get方法
- (CGFloat)contentWidth
{
    UIEdgeInsets insets = self.collectionView.contentInset;
    return CGRectGetWidth(self.collectionView.bounds) - (insets.left + insets.right);
}

// 重新layoutAttributesClass, 返回自定义的瀑布流的Attributes
+ (Class)layoutAttributesClass
{
    return [QCWaterfallsFlowLayoutAttributes class];
}

// 子类必须重写的方法, 内容的宽度和高度(详情见API注释)
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.contentWidth, self.contentHeight);
}
// 瀑布流必须重写的方法(布局Cell)
- (void)prepareLayout
{
    // 给详情高度赋值
    self.contentHeight = 0;
    // 清空attributesArr的数组
    if (self.attributesArr.count != 0) {
        [self.attributesArr removeAllObjects];
    }
    // 判断数组是否存在
    if (self.attributesArr) {
        // 计算每一列宽度
        CGFloat columnWidth = self.contentWidth / (self.numberOfColumns * 1.0);
        // x轴的偏移数组
        NSMutableArray *xOffset = [NSMutableArray array];
        // 遍历向x轴数组中添加NSNumber类型数组
        for (int i = 0; i < self.numberOfColumns; i++) {
            [xOffset addObject:@(i * columnWidth)];
        }
        // 定义一个默认行
        NSInteger column = 0;
        // y轴的偏移数组
        NSMutableArray *yOffset = [NSMutableArray arrayWithCapacity:self.numberOfColumns];
        // 默认填入对行数的y的偏移
        for (int i = 0; i < self.numberOfColumns; i++) {
            
            [yOffset addObject:@(0.0)];
        }

        // 遍历collectionView的第0区
        for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
            // 创建下标i的indexPath
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            // 用列宽 - cell间距
            CGFloat width = columnWidth - self.cellPadding;
            // 根据代理获取照片高度
            CGFloat photoHeight = [self.delegate collectionView:self.collectionView heightForPhotoAtIndexPath:indexPath withWidth:width];
            // 根据代理获取文字高度
            CGFloat annotationHeight = [self.delegate collectionView:self.collectionView heightForAnnotationAtIndexPath:indexPath withWidth:width];
            // 获得单个Item总高度
            CGFloat height = self.cellPadding + photoHeight + annotationHeight + self.cellPadding;
            // 取出对应下标的x轴偏移和y轴偏移的数值, 与列宽和单个item总高度生成新的frame
            CGRect frame = CGRectMake([xOffset[column] floatValue], [yOffset[column] floatValue], columnWidth, height);
            // 根据生成的frame扩大其边距(加上item的间距), 中心点相同
            CGRect insetFrame = CGRectInset(frame, self.cellPadding, self.cellPadding);
            
            
            // 根据indexPath生成新的attributes
            QCWaterfallsFlowLayoutAttributes *attributes = [QCWaterfallsFlowLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            // 将图片高度赋给attributes
            attributes.photoHeight = photoHeight;
            // 将图片位置和大小赋给attributes
            attributes.frame = insetFrame;
            // 向attributesArr中添加attributes
            [self.attributesArr addObject:attributes];
            
            // 取contentHeight与frame的y值中较大的, 存储
            NSLog(@"赋值前contentHeight = %f CGRectGetMaxY(frame) = %f", self.contentHeight, CGRectGetMaxY(frame));
            self.contentHeight = MAX(self.contentHeight, CGRectGetMaxY(frame));
            NSLog(@"赋值前contentHeight = %f CGRectGetMaxY(frame) = %f", self.contentHeight, CGRectGetMaxY(frame));
            // 将对应列数的y的偏移的最大值存储
            NSLog(@"赋值前yOffset[%ld] = %@", column, yOffset[column]);
            yOffset[column] = @([yOffset[column] floatValue] + height);
            NSLog(@"赋值后yOffset[%ld] = %@", column, yOffset[column]);
            // 三目运算符计算, 比较当前行数与总列数 - 1
            column = column >= (self.numberOfColumns - 1) ? 0 : ++column;
            NSLog(@"column = %ld", column);
        }
        
        
    }
}
// 遍历attributes的数组获取
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 创建数组
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    // 遍历attributes的数组
    for (UICollectionViewLayoutAttributes *attributes  in self.attributesArr) {
        // 如果Rect的frame和rect的相等
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            // 将attributes填进数组中, 并返回
            [layoutAttributes addObject:attributes];
        }
    }
    return layoutAttributes;
}

@end

