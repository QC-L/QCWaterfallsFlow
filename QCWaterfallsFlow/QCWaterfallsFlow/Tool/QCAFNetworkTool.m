//
//  QCAFNetworkTool.m
//  Test
//
//  Created by QC.L on 15/9/1.
//  Copyright (c) 2015年 QC.L. All rights reserved.
//

#import "QCAFNetworkTool.h"
#import "AFNetworking.h"

@implementation QCAFNetworkTool
+ (void)getUrl:(NSString *)url
          body:(id)body
        result:(QCResult)result
    headerFile:(NSDictionary *)headerFile
       success:(void (^)(id result))success
       failure:(void (^)(NSError *error))failure
{
    // 1.获取网络请求管理类
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    
    // 2.为网络请求加请求头
    if (headerFile) {
        for (NSString *key in headerFile.allKeys) {
            [manager.requestSerializer setValue:headerFile[key] forHTTPHeaderField:key];
        }
    }
    // 3.设置返回值类型
    switch (result) {
        case QCData:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case QCJSON:
            break;
        case QCXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        default:
            break;
    }
    // 4.设置网络请求返回值所支持的参数类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", nil]];
    // 让网络指示器旋转
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;

    // 5.发送网络请求
    [manager GET:url parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSLog(@"%@", [operation.response allHeaderFields]);
            // 成功回调
            success(responseObject);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            // 失败回调
            failure(error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}


+ (void)postUrl:(NSString *)url
           body:(id)body
         result:(QCResult)result
   requestStyle:(QCRequestStyle)requestStyle
     headerFile:(NSDictionary *)headerFile
        success:(void (^)(id result))success
        failure:(void (^)(NSError *error))failure
{
    // 1.获取网络请求管理类
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 2.网络请求请求体Body的类型
    switch (requestStyle) {
        case QCRequestJSON:
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case QCRequestString:
            [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError *__autoreleasing *error) {
                return parameters;
            }];
            break;
            
        default:
            break;
    }
    
    // 3.为网络请求加请求头
    if (headerFile) {
        for (NSString *key in headerFile.allKeys) {
            [manager.requestSerializer setValue:headerFile[key] forHTTPHeaderField:key];
        }
    }
    // 4.网络请求返回值的数据类型
    switch (result) {
        case QCData:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case QCJSON:
            break;
        case QCXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        default:
            break;
    }
    
    
    // 5.设置网络请求返回值支持的类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", nil]];

    // 6.发送网络请求
    [manager POST:url parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            failure(error);
        }
    }];
    
}
@end
