//
//  ViewController.m
//  QCWaterfallsFlow
//
//  Created by QC.L on 15/9/9.
//  Copyright (c) 2015年 QC.L. All rights reserved.
//

#import "ViewController.h"
#import "QCWaterfallsFlowLayout.h"
#import "QCAFNetworkTool.h"
#import "QCPhoto.h"
#import "QCCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import "MJRefresh.h"
#define kReuse @"reuse"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, QCWaterfallsFlowLayoutDelegate>
// 数据源数组
@property (nonatomic, strong) NSMutableArray *imageArr;
// 系统CollectionView
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger number;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
#warning 我的工程在ARC下编写, 计算使用-fobjc-arc
    self.number = 1;
    // 初始化数组
    self.imageArr = [NSMutableArray array];
    // 网络请求
    [self handleData];
    // 创建CollectionView
    [self createCollectionView];
    
    

}

- (void)createCollectionView
{
    // 创建自定义瀑布流
    QCWaterfallsFlowLayout *layout = [[QCWaterfallsFlowLayout alloc] init];
    // 分为几列, 宽度高度自适应
    layout.numberOfColumns = 3;
    // 签订代理
    layout.delegate = self;

    
    // 创建Collection
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[QCCollectionViewCell class] forCellWithReuseIdentifier:kReuse];
    self.collectionView.contentInset = UIEdgeInsetsMake(23, 5, 10, 5);
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self handleData];
    }];
    self.collectionView.footer.hidden = YES;
}

- (void)handleData
{
    NSString *string = [NSString stringWithFormat:@"http://editors.zuiqushi.com/album_json.php?version=6.11&package=com.aslibra.wt.chuangyi&ipad=0&cat=(null)&page=%ld", self.number];
    // 网络请求
    [QCAFNetworkTool getUrl:string body:nil result:QCJSON headerFile:nil success:^(id result) {
        NSLog(@"%@", result);
        NSArray *dicArr = result[@"data"][@"data"];
        // 数据解析
        for (NSDictionary *dic in dicArr) {
            QCPhoto *photo = [[QCPhoto alloc] initWithDic:dic];
            [self.imageArr addObject:photo];
        }
        // 刷新Collection
        self.collectionView.footer.hidden = NO;
        [self.collectionView reloadData];
        [self.collectionView.footer endRefreshing];
    } failure:^(NSError *error) {
        
    }];
    self.number++;
}

#pragma 数据源必须实现方法 ---- 返回Cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArr.count;
}
#pragma 数据源必须实现方法 ---- 返回Cell样式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuse forIndexPath:indexPath];
    cell.photo = self.imageArr[indexPath.row];
    return cell;
}

#pragma 自定义flowLayout协议方法 ------- 计算文字高度
- (CGFloat)collectionView:(UICollectionView *)collectionView heightForAnnotationAtIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width
{
    // 文字边距预留
    CGFloat annotationPadding = 4.0;
    // 文字头高度
    CGFloat annotationHeaderHeight = 17.0;
    QCPhoto *photo = self.imageArr[indexPath.item];
    UIFont *font = [UIFont systemFontOfSize:10];
    // 根据文字大小和宽度, 计算文字高度
    CGFloat commentHeight = [photo heightForDetail:font width:width];
    // 总高度
    CGFloat height = annotationPadding + annotationHeaderHeight +  commentHeight + annotationPadding;
    return height;
}
#pragma 自定义flowLayout协议方法 ------- 计算图片高度
- (CGFloat)collectionView:(UICollectionView *)collectionView heightForPhotoAtIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width
{
    // 数据源包含高度和
    QCPhoto *photo = self.imageArr[indexPath.item];
    // 根据数据源图片, 计算应展示imageView高度
    CGFloat height = width * [photo.height floatValue] / [photo.width floatValue];
    
    return height;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



