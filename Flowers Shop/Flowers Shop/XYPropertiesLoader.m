//
//  XYPropertiesLoader.m
//  Flowers Shop
//
//  Created by Xia Yong on 13-12-15.
//  Copyright (c) 2013年 Xia Yong. All rights reserved.
//

#import "XYPropertiesLoader.h"

@interface XYPropertiesLoader ()
+ (void)initProperties;
@end

@implementation XYPropertiesLoader

static XYPropertiesLoader *instance;
static NSDictionary *appConfigDict;

+ (void)initialize {
    if (self == [XYPropertiesLoader class]) {
        [XYPropertiesLoader initProperties];
        instance = [[XYPropertiesLoader alloc] init];
    }
}

+ (void)initProperties {
    NSString *appConfigFilename = [[[NSBundle mainBundle] infoDictionary] objectForKey:@kApplicationConfigPropertyFilenameKey];
    NSString *appConfigFilepath = [[NSBundle mainBundle] pathForResource:appConfigFilename ofType:@"plist"];
    appConfigDict = [NSDictionary dictionaryWithContentsOfFile:appConfigFilepath];
    NSLog(@"Load the system configration file %@ successful.", appConfigFilepath);
}

- (id)propertyForKey:(NSString *)key {
    return [appConfigDict objectForKey:key];
}

- (id)propertyForKey:(NSString *)key defaultValue:(id)value {
    id property = [self propertyForKey:key];
    return property != nil ? property : value;
}

+ (XYPropertiesLoader *)sharedPropertiesLoader {
    return instance;
}

@end
