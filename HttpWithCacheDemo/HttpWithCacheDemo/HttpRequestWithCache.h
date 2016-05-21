//
//  HttpRequestWithCache.h
//  HttpWithCacheDemo
//
//  Created by 大有 on 16/5/17.
//  Copyright © 2016年 大有. All rights reserved.
//

#import <Foundation/Foundation.h>

//连接可自己替换
#define urlStr @"http://192.168.0.199:8888/yuyue_m/"

@protocol HttpRequestCacheDelegate <NSObject>

@optional
-(void)httpSuccess:(id)response bindTag:(NSString *)bindTag;

-(void)httpError:(NSString *)error bindTag:(NSString *)bindTag;

@end

@interface HttpRequestWithCache : NSObject

-(instancetype)initWithDelegate:(id)requestDelegate bindTag:(NSString *)bindTag needToken:(NSInteger)needToken;

@property (nonatomic,assign)  id requestDelegate;
@property (nonatomic,copy)  NSString *bindTag;
@property (nonatomic,assign)  NSInteger needToken;

#pragma mark - Get方法(默认方法)
//不带缓存
-(void)httpGetRequest:(NSString *)api params:(NSMutableDictionary *)params;
-(void)httpGetCacheRequest:(NSString *)api params:(NSMutableDictionary *)params;
#pragma mark - Post方法
//不带缓存
-(void)httpPostRequest:(NSString *)api params:(NSMutableDictionary *)params;
-(void)httpPostCacheRequest:(NSString *)api params:(NSMutableDictionary *)params;

#pragma mark - 上传文件方法
//上传单张图片
-(void)upLoadDataWithUrlStr:(NSString *)api params:(NSMutableDictionary *)params imageKey:(NSString *)name withData:(NSData *)data;
//上传多张图片
-(void)upLoadDataWithUrlStr:(NSString *)api params:(NSMutableDictionary *)params  withDataArray:(NSArray *)dataArray;

@end
