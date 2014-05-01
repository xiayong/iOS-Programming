//
//  XYFlosersShopModel.m
//  Flowers Shop
//
//  Created by Xia Yong on 13-12-19.
//  Copyright (c) 2013年 Xia Yong. All rights reserved.
//

#import "XYFlosersShopModel.h"
#import "FMDatabase.h"
#import "SKPSMTPMessage.h"

@interface XYFlosersShopModel () <SKPSMTPMessageDelegate>
+ (void)initDB;
+ (void)syncData;
- (BOOL)addItem:(XYItem *)item;
- (BOOL)updateItem:(XYItem *)item;
- (BOOL)deleteItem:(XYItem *)item;

-(void)messageSent:(SKPSMTPMessage *)message;
-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error;
@end

@implementation XYFlosersShopModel

static XYFlosersShopModel *instance;
static XYPropertiesLoader *propertiesLoader;
static FMDatabase *db;

static NSMutableArray *products;
static NSMutableArray *orders;
static NSMutableArray *items;


+ (void)initialize {
    if (self == [XYFlosersShopModel class]) {
        [XYFlosersShopModel initDB];
        instance = [[XYFlosersShopModel alloc] init];
    }
}

+ (XYFlosersShopModel *)sharedModel {
    return instance;
}

+ (void)initDB {
    NSString *dbFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    propertiesLoader = [XYPropertiesLoader sharedPropertiesLoader];
    dbFilePath = [dbFilePath stringByAppendingPathComponent:[propertiesLoader propertyForKey:@kConfigDBFiledirectoryKey defaultValue:@"Data"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbFilePath]) {
        [fileManager createDirectoryAtPath:dbFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"%@ not exists, create it.", dbFilePath);
    }
    
    dbFilePath = [dbFilePath stringByAppendingPathComponent:[propertiesLoader propertyForKey:@kConfigDBFilenameKey defaultValue:@"mainDB.sqllite3"]];
    db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS Products(prodid INTEGER PRIMARY KEY AUTOINCREMENT, prodname VARCHAR(40) NOT NULL UNIQUE, prodprice DECIMAL(7, 2) NOT NULL)"];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS Orders(oid INTEGER PRIMARY KEY AUTOINCREMENT, firstname VARCHAR(40) NOT NULL, lastname VARCHAR(40) NOT NULL, email VARCHAR(30) NOT NULL, phone VARCHAR(20) NOT NULL, purchaseDate DATE NOT NULL)"];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS Items(oid INTEGER, pid INTEGER NOT NULL, count INTEGER NOT NULL, FOREIGN KEY(oid) REFERENCES Orders(oid), FOREIGN KEY(pid) REFERENCES Products(prodid))"];
    [db close];
    NSLog(@"Load the %@ db file successful.", dbFilePath);
    [XYFlosersShopModel syncData];
}

- (NSArray *)products {
    return [products deepCopy];
}

- (NSArray *)cart {
    return [items deepCopy];
}

- (XYProduct *)productIFExists:(XYProduct *)product {
    NSString *sql = @"SELECT prodid, prodname, prodprice FROM Products WHERE ";
    XYProduct *oldProduct = nil;
    NSArray *argumentArray = nil;
    
    if (product.prodid != 0) {
        sql = [sql stringByAppendingString:@"prodid = ?"];
        argumentArray = [NSArray arrayWithObject:[NSNumber numberWithInteger:product.prodid]];
    }
    else if (product.prodname != nil && product.prodname.length != 0) {
        sql = [sql stringByAppendingString:@"prodname = ?"];
        argumentArray = [NSArray arrayWithObject:product.prodname];
    }
    if (argumentArray) {
        [db open];
        FMResultSet *result = [db executeQuery:sql withArgumentsInArray:argumentArray];
        if (result != nil && [result next]) {
            oldProduct = [[XYProduct alloc] init];
            oldProduct.prodid = [result intForColumn:@"prodid"];
            oldProduct.prodname = [result stringForColumn:@"prodname"];
            oldProduct.prodprice = [result objectForColumnName:@"prodprice"];
            [result close];
        }
        [db close];
    }
    
    return oldProduct;
}

- (BOOL)addProduct:(XYProduct *)product {
    [db open];
    BOOL b = [db executeUpdate:@"INSERT OR REPLACE INTO Products(prodname, prodprice) VALUES(?, ?)", product.prodname, product.prodprice];
    [db close];
    [XYFlosersShopModel syncData];
    return b;
}

- (BOOL)deleteProductWithProductid:(NSUInteger)pid {
    for (int i = 0; i < products.count; i++) {
        XYProduct *p = [products objectAtIndex:i];
        if (p.prodid == pid) {
            [products removeObjectAtIndex:i];
            break;
        }
    }
    [db open];
    NSString *sql = @"DELETE FROM Products WHERE prodid = ?";
    BOOL b = [db executeUpdate:sql, [NSNumber numberWithInteger:pid]];
    [db close];
    return b;
}

+ (void)syncData {
    [db open];
    FMResultSet *resultSet;
    NSString *sql;
    
    sql = @"SELECT prodid, prodname, prodprice FROM Products";
    resultSet = [db executeQuery:sql];
    products = [[NSMutableArray alloc] init];
    while ([resultSet next]) {
        XYProduct *product = [[XYProduct alloc] init];
        product.prodid = [resultSet intForColumn:@"prodid"];
        product.prodname = [resultSet stringForColumn:@"prodname"];
        product.prodprice = [resultSet objectForColumnName:@"prodprice"];
        [products addObject:product];
    }
    [resultSet close];
    
    sql = @"SELECT oid, firstname, lastname, email, phone, purchaseDate FROM Orders";
    resultSet = [db executeQuery:sql];
    orders = [[NSMutableArray alloc] init];
    while ([resultSet next]) {
        XYOrder *order = [[XYOrder alloc] init];
        order.oid = [resultSet intForColumn:@"oid"];
        order.firstname = [resultSet stringForColumn:@"firstname"];
        order.lastname = [resultSet stringForColumn:@"lastname"];
        order.email = [resultSet stringForColumn:@"email"];
        order.phone = [resultSet stringForColumn:@"phone"];
        order.purchaseDate = [resultSet dateForColumn:@"purchaseDate"];
        [orders addObject:order];
    }
    [resultSet close];
    
    // 加载未完成的订单
    sql = @"SELECT oid, pid, count FROM Items WHERE oid is NULL";
    resultSet = [db executeQuery:sql];
    items = [[NSMutableArray alloc] init];
    while ([resultSet next]) {
        XYItem *item = [[XYItem alloc] init];
        item.oid = [resultSet columnIsNull:@"oid"] ? NSNotFound : [resultSet intForColumn:@"oid"];
        item.pid = [resultSet intForColumn:@"pid"];
        item.count = [resultSet intForColumn:@"count"];
        [items addObject:item];
    }
    [resultSet close];
    
    [db close];
    
    NSLog(@"Sysn all data successful.");
}



- (void)addProductToCartWithProductid:(NSUInteger)pid {
    XYItem *item = nil;
    for (XYItem *i in items)
        if (i.pid == pid) {
            item = i;
            break;
        }
    if (item) {
        ++ item.count;
        [self updateItem:item];
    }
    else {
        item = [[XYItem alloc]initWithOrderid:NSNotFound productid:pid count:1];
        [items addObject:item];
        [self addItem:item];
    }
}

- (BOOL)addItem:(XYItem *)item {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO Items(oid, pid, count) VALUES(%@, ?, ?)", item.oid != NSNotFound ? @"?" : @"NULL"];
    BOOL b = NO;
    [db open];
    if (item.oid != NSNotFound)
        b = [db executeUpdate:sql, [NSNumber numberWithInteger:item.oid], [NSNumber numberWithInteger:item.pid], [NSNumber numberWithInteger:item.count]];
    else
        b = [db executeUpdate:sql, [NSNumber numberWithInteger:item.pid], [NSNumber numberWithInteger:item.count]];
    [db close];
    return b;
}

- (BOOL)updateItem:(XYItem *)item {
    NSString *sql = [NSString stringWithFormat:@"UPDATE Items SET oid = %@, count = ? WHERE pid = ? AND oid IS NULL", item.oid != NSNotFound ? @"?" : @"NULL"];
    BOOL b = NO;
    [db open];
    if (item.oid != NSNotFound)
        b = [db executeUpdate:sql, [NSNumber numberWithInteger:item.oid], [NSNumber numberWithInteger:item.count], [NSNumber numberWithInteger:item.pid]];
    else
        b = [db executeUpdate:sql, [NSNumber numberWithInteger:item.count], [NSNumber numberWithInteger:item.pid]];
    [db close];
    return b;
}

- (BOOL)deleteItem:(XYItem *)item {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM Items WHERE pid = ? AND oid %@", item.oid != NSNotFound ? @"= ?" : @"IS NULL"];
    BOOL b = NO;
    [db open];
    if (item.oid != NSNotFound)
        b = [db executeUpdate:sql, [NSNumber numberWithInteger:item.pid], [NSNumber numberWithInteger:item.oid]];
    else
        b = [db executeUpdate:sql, [NSNumber numberWithInteger:item.pid]];
    [db close];
    return NO;
}

- (XYProduct *)findProductById:(NSUInteger)pid {
    XYProduct *product = nil;
    [db open];
    FMResultSet *resultSet = [db executeQuery:@"SELECT prodid, prodname, prodprice FROM Products WHERE prodid = ?", [NSNumber numberWithInteger:pid]];
    if ([resultSet next]) {
        product = [[XYProduct alloc] init];
        product.prodid = [resultSet intForColumn:@"prodid"];
        product.prodname = [resultSet stringForColumn:@"prodname"];
        product.prodprice = [resultSet objectForColumnName:@"prodprice"];
    }
    [db close];
    return product;
}

- (void)modifyItem:(XYItem *)newItem {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pid = %lu", (unsigned long)newItem.pid];
    XYItem *item = [[items filteredArrayUsingPredicate:predicate] objectAtIndex:0];
    if (item) {
        if (newItem.count == 0) {
            [items removeObject:item];
            [self deleteItem:item];
            return;
        }
        if (newItem.oid != NSNotFound)
            item.oid = newItem.oid;
        item.count = newItem.count;
        [self updateItem:item];
    }
}

- (BOOL)settlement:(XYOrder *)order {
    NSString *order_sql = @"INSERT INTO Orders(firstname, lastname, email, phone, purchaseDate) VALUES(?,?,?,?,?)";
    NSString *item_sql = @"UPDATE Items SET oid = ? WHERE pid = ? AND oid IS NULL";
    BOOL success = NO;
    @try {
        [db open];
        [db beginTransaction];
        [db executeUpdate:order_sql, order.firstname, order.lastname, order.email, order.phone, order.purchaseDate];
        order.oid = (NSUInteger)[db lastInsertRowId];
        for (XYItem *item in items)
            [db executeUpdate:item_sql, [NSNumber numberWithInteger:order.oid], [NSNumber numberWithInteger:item.pid]];
        [db commit];
        [items removeAllObjects];
        success = YES;
    }
    @catch (NSException *exception) {
        success = NO;
        NSLog(@"%@:%@", exception.name, exception.description);
        [db rollback];
    }
    @finally {
        [db close];
    }
    
    if (success) {
        SKPSMTPMessage *message = [[SKPSMTPMessage alloc] init];
        message.requiresAuth = [@"YES" isEqualToString:[propertiesLoader propertyForKey:@kEmailRequiresAuth]];
        message.relayHost = [propertiesLoader propertyForKey:@kEmailSMTPHost];
        message.relayPorts = @[[propertiesLoader propertyForKey:@kEmailPort]];
        if (message.requiresAuth) {
            message.login = [propertiesLoader propertyForKey:@kEmalFromAccount];
            message.pass = [propertiesLoader propertyForKey:@kEmailPassword];
        }
        message.toEmail = order.email;
        message.fromEmail = [propertiesLoader propertyForKey:@kEmalFromAccount];
        message.subject = @"Hi Your shopping list";
        message.parts = @[@{kSKPSMTPPartMessageKey: @"Here is your list of goods"}];
        message.validateSSLChain = [@"YES" isEqualToString:[propertiesLoader propertyForKey:@kEmailValidateSSLChain]];
        message.delegate = self;
        [message send];
    }
    
    return success;
}

-(void)messageSent:(SKPSMTPMessage *)message {
    NSLog(@"%@", message.description);
}
-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error {
    NSLog(@"Send mail to custom failed: %@", error.description);
}

@end
