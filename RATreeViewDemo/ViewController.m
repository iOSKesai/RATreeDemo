//
//  ViewController.m
//  RATreeViewDemo
//
//  Created by liyang@l2cplat.com on 16/6/23.
//  Copyright © 2016年 yang_li828@163.com. All rights reserved.
//

#import "ViewController.h"
#import "RATreeView.h"
#import "CellModel.h"
#import "TreeTableViewCell.h"

#define SCREEN_W     [UIScreen mainScreen].bounds.size.width

#define SCREEN_H     [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<RATreeViewDataSource,RATreeViewDelegate>

@property (strong,nonatomic) RATreeView *treeView;

@property (strong,nonatomic) NSMutableArray *dataSource;

@property (strong,nonatomic) NSString *TextFieldName; //全局保存用户输入的Node名称


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setData];
    
    

    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

}


-(void) setData
{
    
    self.dataSource = [NSMutableArray array];
    
    self.treeView = [[RATreeView alloc]initWithFrame:CGRectMake(0, 64,SCREEN_W , SCREEN_H) style:RATreeViewStylePlain];
    
    self.treeView.dataSource = self;
    
    self.treeView.delegate = self;
    
    [self.treeView registerNib:[UINib nibWithNibName:@"TreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"TreeTableViewCell"];
    
    [self.view addSubview:self.treeView];
    
    CellModel *treeNode = [[CellModel alloc]initWithName:@"RATree公司" children:[NSMutableArray array]];
    
    
    [self.dataSource addObject:treeNode];
    
}


#pragma mark- RATree的dataSouce
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(nullable id)item
{
        if (item == nil)
        {
            return self.dataSource.count;
        }
        CellModel *model = (CellModel *)item;
    
        return model.children.count;
    
    
}



- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(nullable id)item
{
    TreeTableViewCell *cell = [treeView dequeueReusableCellWithIdentifier:@"TreeTableViewCell"];
    
    cell.delegate = self;
    
    NSUInteger level = [treeView levelForCellForItem:item];
    
    BOOL isExpand = [treeView isCellForItemExpanded:item];
    
    [cell refreshCellWithItem:item andLevel:level andIsExpand:isExpand];
    
    return cell;
}


- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(nullable id)item
{
    if (item == nil) {
        
        return self.dataSource[index];
    }
    
    CellModel *model = (CellModel *)item;
    
    return model.children[index];
}


- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{

    return 50;
}


//将要展开
- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    
    

        TreeTableViewCell *cell = (TreeTableViewCell *)[treeView cellForItem:item];
        
        cell.imgView.image = [UIImage imageNamed:@"header_arrow_down"];
    
}
//将要收缩
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    
    
    TreeTableViewCell *cell = (TreeTableViewCell *)[treeView cellForItem:item];
    
    cell.imgView.image = [UIImage imageNamed:@"header_arrow_right"];
}


- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item
{

    [treeView deselectRowForItem:item animated:NO];
}


#pragma mark - TreeTableViewCell的delegate

-(void)clickTheBtn:(UIButton *)btn withTitle:(NSString *)name inTheCell:(TreeTableViewCell *)cell
{
    if ([name isEqualToString:@"增加"]) {
        
        [self addNodeToCell:cell];
        
    }
    else if([name isEqualToString:@"删除"])
    {
        [self deleteNoteFromCell:cell];
    }
    else
    {
        [self editNoteToCell:cell];
    }

}

#pragma mark-内部方法
#pragma mark 增加子节点
-(void)addNodeToCell:(TreeTableViewCell *)cell
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒"message:@"您确定要增加一个子节点？"preferredStyle:UIAlertControllerStyleAlert];
    

    UIAlertAction *okAction = [UIAlertAction  actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"确认");
        
        //增加一个节点
        NSLog(@"%@",self.TextFieldName);
        CellModel *sonModel = [[CellModel alloc]initWithName:self.TextFieldName children:[NSMutableArray array]];
        
        
        CellModel *fatherModel = [self.treeView itemForCell:cell];
        
        [fatherModel.children addObject:sonModel];
        
        NSInteger index = [fatherModel.children indexOfObject:sonModel];


        __weak typeof(self) weakSelf = self;

        dispatch_async(dispatch_get_main_queue(), ^{
           
            [weakSelf.treeView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:fatherModel withAnimation:RATreeViewRowAnimationFade];        });

        }];
    
    UIAlertAction *cancelAction = [UIAlertAction  actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"取消");
        
        
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField*textField) {
        
        
        textField.textColor= [UIColor grayColor];
        
        [textField addTarget:self action:@selector(usernameDidChange:)forControlEvents:UIControlEventEditingChanged];
        
    }];
    
    
    
    [alert addAction:okAction];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}

-(void) deleteNoteFromCell:(TreeTableViewCell *)cell
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒"message:@"您确定要当前节点？"preferredStyle:UIAlertControllerStyleAlert];
    

    UIAlertAction *okAction = [UIAlertAction  actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"确认");
        
        CellModel *item = [self.treeView itemForCell:cell];
        
         CellModel *parentItem  = [self.treeView parentForItem:item];
        
        NSInteger index = [parentItem.children indexOfObject:item];

        if(parentItem == nil)
        {
            [self.dataSource removeAllObjects];
        }
        else
        {
            [parentItem.children removeObject:item];
        }
        
        __weak typeof(self) weakSelf = self;

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.treeView deleteItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parentItem withAnimation:RATreeViewRowAnimationFade];
        });
        
        
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction  actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"取消");
        
        
    }];
    
    
    [alert addAction:okAction];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)editNoteToCell:(TreeTableViewCell *)cell

{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒"message:@"您确定要当前节点名字？"preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *okAction = [UIAlertAction  actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"确认");
        
        CellModel *fatherModel = [self.treeView itemForCell:cell];
        
        fatherModel.name = self.TextFieldName;
        
        __weak typeof(self) weakSelf = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.treeView reloadRowsForItems:@[fatherModel]withRowAnimation:RATreeViewRowAnimationFade];
        });
        
        
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction  actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"取消");
        
        
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField*textField) {
        
        
        textField.textColor= [UIColor grayColor];
        
        [textField addTarget:self action:@selector(usernameDidChange:)forControlEvents:UIControlEventEditingChanged];
        
    }];
    
    
    
    [alert addAction:okAction];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];

    
}




-(void)usernameDidChange:(UITextField *)textField
{
    
    self.TextFieldName = textField.text;
    
}



@end
