//
//  QCAFNetworkTool.h
//  Test
//
//  Created by QC.L on 15/9/1.
//  Copyright (c) 2015年 QC.L. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QCResult) {
    QCData,
    QCJSON,
    QCXML,
};

typedef NS_ENUM(NSUInteger, QCRequestStyle) {
    QCRequestJSON,
    QCRequestString
};

@interface QCAFNetworkTool : NSObject


/**
 *  Get请求
 *
 *  @param url        网络请求地址
 *  @param body       请求体
 *  @param result     返回的数据类型
 *  @param headerFile 请求头
 *  @param success    网络请求成功回调
 *  @param failure    网络请求失败回调
 */
+ (void)getUrl:(NSString *)url
          body:(id)body
        result:(QCResult)result
    headerFile:(NSDictionary *)headerFile
       success:(void (^)(id result))success
       failure:(void (^)(NSError *error))failure;


/**
 *  Post请求
 *
 *  @param url          网络请求地址
 *  @param body         请求体
 *  @param result       返回值的数据类型
 *  @param requestStyle 网络请求Body的类型
 *  @param headerFile   网络请求头
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)postUrl:(NSString *)url
          body:(id)body
        result:(QCResult)result
  requestStyle:(QCRequestStyle)requestStyle
    headerFile:(NSDictionary *)headerFile
       success:(void (^)(id result))success
       failure:(void (^)(NSError *error))failure;





@end
