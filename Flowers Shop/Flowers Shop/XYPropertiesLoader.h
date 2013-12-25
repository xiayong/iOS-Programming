//
//  XYPropertiesLoader.h
//  Flowers Shop
//
//  Created by Xia Yong on 13-12-15.
//  Copyright (c) 2013年 Xia Yong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYConstants.h"

@interface XYPropertiesLoader : NSObject

// 获取XYPropertiesLoader的唯一实例。此类使用了单例模式。
+ (XYPropertiesLoader *)sharedPropertiesLoader;

// 从配置文件中获取指定key的value，若无此key则返回nil。
- (id)propertyForKey:(NSString *)key;
// 从配置文件中获取指定key的value，可以指定一个default值，在无此key时则返回此default值。
- (id)propertyForKey:(NSString *)key defaultValue:(id)value;
@end
