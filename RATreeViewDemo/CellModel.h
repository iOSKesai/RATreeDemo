//
//  CellModel.h
//  RATreeViewDemo
//
//  Created by liyang@l2cplat.com on 16/6/23.
//  Copyright © 2016年 yang_li828@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellModel : NSObject

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSMutableArray *children;

- (id)initWithName:(NSString *)name children:(NSMutableArray *)array;


@end
