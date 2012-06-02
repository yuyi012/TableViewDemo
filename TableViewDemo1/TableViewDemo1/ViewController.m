//
//  ViewController.m
//  TableViewDemo1
//
//  Created by 俞亿 on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GroupHeaderView.h"

#define kHeaderViewTag 100

@interface ViewController ()

@end

@implementation ViewController

-(void)loadView{
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.view = container;
    [container release];
    
    DataTable = [[UITableView alloc]initWithFrame:self.view.bounds
                                            style:UITableViewStylePlain];
    DataTable.delegate = self;
    DataTable.dataSource = self;
    [self.view addSubview:DataTable];
}

- (void)dealloc
{
    [DataTable release];
    [groupArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //取得群组列表
    NSString *groupPath = [[NSBundle mainBundle]pathForResource:@"GroupList" ofType:@"plist"];
    groupArray = [[NSMutableArray alloc]initWithContentsOfFile:groupPath];
    [DataTable reloadData];
}

#pragma mark header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //群组名称
    GroupHeaderView *groupHeaderView = (GroupHeaderView*)[DataTable viewWithTag:kHeaderViewTag+section];
    if (groupHeaderView==nil) {
        groupHeaderView = [[[GroupHeaderView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)]autorelease];
        groupHeaderView.tag = kHeaderViewTag+section;
        //响应点击操作
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(groupHeaderTap:)];
        [groupHeaderView addGestureRecognizer:tapGesture];
        [tapGesture release];
    }
    //取得群组对应的dic
    NSMutableDictionary *groupDic = [groupArray objectAtIndex:section];
    //设置群组名称
    groupHeaderView.groupName = [groupDic objectForKey:@"groupName"];
    return groupHeaderView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSMutableDictionary *groupDic = [groupArray objectAtIndex:section];
    return [groupDic objectForKey:@"groupName"];
}

-(void)groupHeaderTap:(UITapGestureRecognizer*)theTap{
    GroupHeaderView *headerView = (GroupHeaderView*)theTap.view;
    //切换展开和收起状态
    headerView.open = !headerView.open;
    //取得section
    NSInteger section = headerView.tag-kHeaderViewTag;
    NSMutableDictionary *groupDic = [groupArray objectAtIndex:section];
    //设置groupDic中的展开状态
    [groupDic setObject:[NSNumber numberWithBool:headerView.open] forKey:@"open"];
    [DataTable reloadSections:[NSIndexSet indexSetWithIndex:section]
             withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //群组的数量
    return groupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *groupDic = [groupArray objectAtIndex:section];
    BOOL open = [[groupDic objectForKey:@"open"]boolValue];
    NSInteger numberOfRows;
    //判断展开状态,如果展开则显示组员
    if (open) {
        NSArray *memberList = [groupDic objectForKey:@"memberList"];
        numberOfRows = memberList.count;
    }else {
        numberOfRows = 0;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *memberCell = [DataTable dequeueReusableCellWithIdentifier:@"memberCell"];
    if (memberCell==nil) {
        memberCell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                            reuseIdentifier:@"memberCell"]autorelease];
    }
    //先取得群组dic
    NSDictionary *groupDic = [groupArray objectAtIndex:indexPath.section];
    //取得组员列表
    NSArray *memberList = [groupDic objectForKey:@"memberList"];
    //取得组员dic
    NSDictionary *memberDic = [memberList objectAtIndex:indexPath.row];
    //设置组员名称
    memberCell.textLabel.text = [memberDic objectForKey:@"name"];
    //设置组员描述
    memberCell.detailTextLabel.text = [memberDic objectForKey:@"desc"];
    //设置组员头像
    memberCell.imageView.image = [UIImage imageNamed:[memberDic objectForKey:@"icon"]];
    return memberCell;
}


@end
