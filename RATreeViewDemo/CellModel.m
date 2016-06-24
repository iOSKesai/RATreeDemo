//
//  CellModel.m
//  RATreeViewDemo
//
//  Created by liyang@l2cplat.com on 16/6/23.
//  Copyright © 2016年 yang_li828@163.com. All rights reserved.
//

#import "CellModel.h"

@implementation CellModel

- (id)initWithName:(NSString *)name children:(NSMutableArray *)children
{
    self = [super init];
    if (self) {
        self.children = children;
        self.name = name;
    }
    return self;
}



@end
