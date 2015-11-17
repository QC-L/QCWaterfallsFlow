//
//  QCWaterfallsFlowLayout.h
//  QCWaterfallsFlow
//
//  Created by QC.L on 15/9/9.
//  Copyright (c) 2015年 QC.L. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QCWaterfallsFlowLayoutDelegate <NSObject>

/**
 *  Collection返回cell中图片的高度
 *
 *  @param collectionView 当前collection
 *  @param indexPath      下标
 *  @param width          对应宽度
 *
 *  @return cell中图片高度
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView heightForPhotoAtIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width;

/**
 *  Collection返回cell中文字高度
 *
 *  @param collectionView 当前collection
 *  @param indexPath      下标
 *  @param width          对应宽度
 *
 *  @return cell中文字高度
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView heightForAnnotationAtIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width;

@end

@interface QCWaterfallsFlowLayout : UICollectionViewLayout
/**
 *  签订代理实现代理方法
 */
@property (nonatomic, assign) id <QCWaterfallsFlowLayoutDelegate> delegate;
/**
 *  列数 默认为3列, 可以根据需求修改
 */
@property (nonatomic, assign) NSInteger numberOfColumns;
/**
 *  Cell之间的间隔, 默认为2.0f
 */
@property (nonatomic, assign) CGFloat cellPadding;

@end
