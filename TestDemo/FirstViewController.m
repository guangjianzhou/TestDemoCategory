//
//  FirstViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 15/12/2.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import "FirstViewController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

@interface FirstViewController ()<UISearchControllerDelegate,UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchVC;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@property (strong, nonatomic) NSIndexPath *selectIndexPath;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];

}

//不起作用
-(void)detectCall
{
    CTCallCenter *callCenter = [[CTCallCenter alloc] init];
    callCenter.callEventHandler=^(CTCall* call)
    {
        if (call.callState == CTCallStateDisconnected)
        {
            NSLog(@"Call has been disconnected");
        }
        else if (call.callState == CTCallStateConnected)
        {
            NSLog(@"Call has just been connected");
        }
        
        else if(call.callState == CTCallStateIncoming)
        {
            NSLog(@"Call is incoming");
        }
        
        else if (call.callState ==CTCallStateDialing)
        {
            NSLog(@"call is dialing");
        }
        else
        {
            NSLog(@"Nothing is done");
        }
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //这是修改整个系统的
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    [self navigationRightItem];
    _selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self tableView:_tableView didSelectRowAtIndexPath:_selectIndexPath];
    [self.tableView selectRowAtIndexPath:_selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)navigationRightItem
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    btn.backgroundColor = [UIColor yellowColor];
    [btn addTarget:self action:@selector(ClickAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)ClickAction:(UIButton *)btn
{
    [_tableView reloadData];
    NSArray *array = [_tableView visibleCells];
    for (UITableViewCell *cell in array)
    {
        NSLog(@"-%@--selected=-%d-----highted = %d---",cell,cell.selected,cell.highlighted);
    }
}

- (void)setUp
{
    
    _searchVC = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchVC.searchResultsUpdater = self;
    _searchVC.dimsBackgroundDuringPresentation = NO;
    _searchVC.hidesNavigationBarDuringPresentation = NO;
    _searchVC.searchBar.frame = CGRectMake(self.searchVC.searchBar.frame.origin.x, self.searchVC.searchBar.frame.origin.y, self.searchVC.searchBar.frame.size.width, 44.0);
//    self.tableView.tableHeaderView = self.searchVC.searchBar;
    
    
    _dataSourceArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14", nil];

    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString *name = [NSString stringWithFormat:@"-%ld-section--%ld-row-",(long)indexPath.section,(long)indexPath.row];
    cell.textLabel.text = name;
    
    if ([indexPath isEqual:_selectIndexPath])
    {
        cell.selected = YES;
    }
    else
    {
        cell.selected = NO;
    }
//    NSString *name = _dataSourceArray[indexPath.row];
//    cell.textLabel.text = name;
//    if (indexPath.row%2 == 0)
//    {
//        cell.backgroundColor = [UIColor lightGrayColor];
//    }
//    else
//    {
//        cell.backgroundColor = [UIColor yellowColor];
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndexPath = indexPath;
    [self performSegueWithIdentifier:@"FirstViewController1" sender:nil];
}

#pragma mark - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [self.searchVC.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    //过滤数据
    self.dataSourceArray= [NSMutableArray arrayWithArray:[_dataSourceArray filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];
}

#pragma mark - StatusBarStyle
//当vc在nav中时，上面方法没用 ，vc中的preferredStatusBarStyle方法根本不用被调用。 
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}



@end
