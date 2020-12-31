//
//  IMSFormTypeManager.m
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import "IMSFormTypeManager.h"

@interface IMSFormTypeManager ()

@property (strong, nonatomic) NSMutableDictionary *cellClassDict; /**< <#property#> */

@end

@implementation IMSFormTypeManager

- (instancetype)init
{
    if (self = [super init]) {
        [self defaultRegist];
    }
    return self;
}

- (void)defaultRegist
{
    [self registCellClass:NSClassFromString(@"IMSFormTextFieldCell") forKey:IMSFormType_TextField];
}

#pragma mark - Public Methods

- (void)registCellClass:(Class)cls forKey:(IMSFormType)key
{
    if (cls && key) {
        [self.cellClassDict setObject:cls forKey:key];
    }
}

- (Class)getCellClassWithKey:(IMSFormType)key
{
    return [self.cellClassDict objectForKey:key];
}

#pragma mark - Private Methods

#pragma mark - Getters

- (NSMutableDictionary *)cellClassDict
{
    if (!_cellClassDict) {
        _cellClassDict = [NSMutableDictionary dictionary];
    }
    return _cellClassDict;
}

@end
