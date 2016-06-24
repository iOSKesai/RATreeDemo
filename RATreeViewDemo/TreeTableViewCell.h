//
//  TreeTableViewCell.h
//  RATreeViewDemo
//
//  Created by liyang@l2cplat.com on 16/6/23.
//  Copyright © 2016年 yang_li828@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TreeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign,nonatomic) id delegate;

- (IBAction)clickBtn:(UIButton *)sender;

-(void)refreshCellWithItem:(id)item andLevel:(NSInteger)level andIsExpand:(BOOL)isExpand;

@end




@protocol TreeTableViewCellDelegate <NSObject>

-(void)clickTheBtn:(UIButton *)btn withTitle:(NSString *)name inTheCell:(TreeTableViewCell *)cell;

@end