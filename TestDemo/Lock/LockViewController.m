//
//  LockViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/2/1.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "LockViewController.h"
#import "LockManager.h"

@interface LockViewController ()<UISearchResultsUpdating>


@property (nonatomic, strong) UISearchController *mySearchController;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *visableArray;
@property (nonatomic, strong) NSMutableArray *filterArray;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation LockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //两个线程同时操作了单利的一个共享资源 crash
    dispatch_async(dispatch_queue_create("printQueue", DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
       [[LockManager sharedSingleton] printContent];
    });
    
    dispatch_queue_t queue = dispatch_queue_create("LockQueue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(queue, ^{
           [[LockManager sharedSingleton] addContent];
    });
    
}

- (void)setUp
{
    self.dataSourceArray = [NSMutableArray array];
    self.filterArray = [NSMutableArray array];
    for (int i = 0; i < 26; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            NSString *str = [NSString stringWithFormat:@"%c%d", 'A'+i, j];
            [self.dataSourceArray addObject:str];
        }
    }
    
    self.visableArray = self.dataSourceArray;
    
    _mySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _mySearchController.searchResultsUpdater = self;
    //设置开始搜索背景显示与否
    _mySearchController.dimsBackgroundDuringPresentation = YES;
    [_mySearchController.searchBar sizeToFit];
    self.myTableView.tableHeaderView = _mySearchController.searchBar;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_visableArray || _visableArray.count == 0)
    {
        _visableArray = _dataSourceArray;
    }
    return _visableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
    }
    cell.textLabel.text = [_visableArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark  -
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *filterString = searchController.searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", filterString];
    self.visableArray = [NSMutableArray arrayWithArray:[self.dataSourceArray filteredArrayUsingPredicate:predicate]];
    [self.myTableView reloadData];
}

/**
 *  方法1  @Synchronized 会自动对参数加锁，保证临界区内的代码线程安全
 */

/**
 *  方法2  NSLock
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
