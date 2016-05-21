//
//  Api.m
//  HttpWithCacheDemo
//
//  Created by 大有 on 16/5/17.
//  Copyright © 2016年 大有. All rights reserved.
//

#import "Api.h"

@implementation Api
@synthesize httpRequest;

#pragma mark - init方法
//无需token
-(instancetype)init:(id)delegate tag:(NSString *)tag
{
    return [self init:delegate tag:tag needToken:0];
}

//携带token
-(instancetype)init:(id)delegate tag:(NSString *)tag needToken:(NSInteger)needToken
{
    if (self=[super init]) {
//        self.delegate=delegate;
//        self.bindTag=tag;
        httpRequest=[[HttpRequestWithCache alloc]initWithDelegate:delegate bindTag:tag needToken:needToken];
    }
    return self;
}

#pragma mark - 具体的接口方法
//主页商铺主类型查询
-(void)listShopMainTypes
{
    [httpRequest httpGetCacheRequest:@"core/listShopMainTypes.do" params:nil];
    
}
/*
 景点所有分类查询
 
 /viewspot/shopCategoryList.do */
-(void)getViewSpotTypeListWithShopType:(NSInteger)shopType
{
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:shopType] forKey:@"shopType"];
    [httpRequest httpGetRequest:@"viewspot/shopCategoryList.do" params:params];
    
}


@end
