//
//  TreeTableViewCell.m
//  RATreeViewDemo
//
//  Created by liyang@l2cplat.com on 16/6/23.
//  Copyright © 2016年 yang_li828@163.com. All rights reserved.
//

#import "TreeTableViewCell.h"
#import "CellModel.h"

#define SCREEN_W     [UIScreen mainScreen].bounds.size.width

#define SCREEN_H     [UIScreen mainScreen].bounds.size.height
@implementation TreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.addBtn.frame = CGRectMake(SCREEN_W-30-10, 10, 30, 30);
    
    self.addBtn.layer.cornerRadius = 15;
    
    
    self.deleteBtn.frame = CGRectMake(SCREEN_W-60-10-10, 10, 30, 30);
    
    self.deleteBtn.layer.cornerRadius = 15;

    
    self.editBtn.frame = CGRectMake(SCREEN_W-90-10-20, 10, 30, 30);
    
    self.editBtn.layer.cornerRadius = 15;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshCellWithItem:(id)item andLevel:(NSInteger)level andIsExpand:(BOOL)isExpand
{
    
    CellModel *model = (CellModel *)item;
    
    self.imgView.frame = CGRectMake(level*15+10, 17, 15, 15);
    
    if (isExpand) {
        
        self.imgView.image = [UIImage imageNamed:@"header_arrow_down"];
    }
    else
    {
        self.imgView.image = [UIImage imageNamed:@"header_arrow_right"];

    }
    
    
    self.titleLabel.frame = CGRectMake(level*15+10+20, 10, SCREEN_W-150, 30);
    
    self.titleLabel.text = model.name;
    
    
    
    

}


- (IBAction)clickBtn:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"E"]) {
        
        [self.delegate clickTheBtn:sender withTitle:@"编辑" inTheCell:self] ;
    }
    else if ([sender.titleLabel.text isEqualToString:@"-"])
    {
        [self.delegate clickTheBtn:sender withTitle:@"删除" inTheCell:self];

    }
    else
    {
        [self.delegate clickTheBtn:sender withTitle:@"增加" inTheCell:self];

    }
    
}
@end
