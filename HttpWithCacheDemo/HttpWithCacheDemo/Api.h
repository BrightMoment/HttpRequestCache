//
//  Api.h
//  HttpWithCacheDemo
//
//  Created by 大有 on 16/5/17.
//  Copyright © 2016年 大有. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HttpRequestWithCache.h"

@interface Api : NSObject

@property (nonatomic,strong)  HttpRequestWithCache *httpRequest;

#pragma mark - init方法
//无需token
-(instancetype)init:(id)delegate tag:(NSString *)tag;
//携带token
-(instancetype)init:(id)delegate tag:(NSString *)tag needToken:(NSInteger)needToken;

#pragma mark - 具体的接口方法
//主页商铺主类型查询
-(void)listShopMainTypes;

-(void)getViewSpotTypeListWithShopType:(NSInteger)shopType;
@end
