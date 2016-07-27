//
//  QQViewController.m
//  QQ列表
//
//  Created by yangqinglong on 16/2/25.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import "QQViewController.h"
#import "Helper.h"
#import "QQCell.h"
#import "SectionHeaderView.h"

@interface QQViewController ()
@property (nonatomic,strong) NSMutableArray *dataSourceArray;
@end

@implementation QQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
    self.tableView.showsHorizontalScrollIndicator = YES;
}
-(void)loadData{
    self.dataSourceArray = [NSMutableArray arrayWithArray:[Helper loadDataFromPlistWithName:@"Data"]];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [[_dataSourceArray objectAtIndex:section]objectForKey:@"friend"];
    
    if (sectionStatusArray[section]==0) {
        return 0;
    }else{
        return array.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SectionHeaderView *sectionHeaderView = [[[NSBundle mainBundle]loadNibNamed:@"SectionHeaderView" owner:nil options:nil]lastObject];
    NSDictionary *dic = [_dataSourceArray objectAtIndex:section];
    NSString  *group = [dic objectForKey:@"groupName"];
    sectionHeaderView.groupNameLabel.text = group;
    sectionHeaderView.section = section;
    sectionHeaderView.block = ^(NSInteger section){
        sectionStatusArray[section] = !sectionStatusArray[section];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    sectionHeaderView.direction = sectionStatusArray[section];
    return sectionHeaderView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(QQCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QQCell *cell =[QQCell cellWithTabView:tableView indexPath:indexPath];
    NSDictionary *dic = [_dataSourceArray objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:@"friend"];
    Person *model = [array objectAtIndex:indexPath.row];
    cell.model = model;
    
    return cell;
}



@end
