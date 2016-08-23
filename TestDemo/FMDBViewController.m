//
//  FMDBViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 16/1/11.
//  Copyright © 2016年 guangjianzhou. All rights reserved.
//

#import "FMDBViewController.h"
#import "FMDB.h"

typedef NS_ENUM(NSInteger,RoleType)
{
    RoleTypeManager = 0,//销售经理
    RoleRealtyConsultant = 1,//置业顾问
    RoleTypeCall = 2,//call客
};

@interface FMDBViewController ()

@property (nonatomic, strong) FMDatabase *db;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@end

@implementation FMDBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
    [self insertInto:RoleRealtyConsultant];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _titleLabel.text = @"撒大家深刻的风景卡萨丁及开发";
    });

}

//(枚举 和 NSInteger  不需要转换)

/**
 *  初始化数据
 */
- (void)setUp
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"DB"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager isExecutableFileAtPath:dbPath])
    {
        [fileManager createDirectoryAtPath:dbPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    _db = [FMDatabase databaseWithPath:[dbPath stringByAppendingPathComponent:@"callRecent.db"]] ;
    if (![_db open])
    {
        NSLog(@"Could not open db.");
        return ;
    }
    else
    {
        //创建表
        [self cerateCallTable];
    }

}

- (void)cerateCallTable
{
    if ([self isTableExsit:@"callRecent"])
    {
        NSLog(@"表已经存在");
        return;
    }
    
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS callRecent (TABLE_ID INTEGER PRIMARY KEY AUTOINCREMENT,RECORD_ID TEXT, CALLUUID TEXT, CALLUSERID TEXT,CALLINGPROJECTID TEXT, CALLING TEXT, CALLED TEXT, CALLEDNAME TEXT, ISVIDEO INTEGER,ROLRTYPE INTEGER ,RECORDURL TEXT, STARTTIME TEXT,ENDTIME TEXT,CALLTYPE INTEGER, CALLSTATUS INTEGER)"];
    
    BOOL createResult = [_db executeUpdate:createSql];
    if (createResult)
    {
        NSLog(@"-----表创建成功");
    }
    else
    {
        NSLog(@"-----表创建失败");
    }
}


- (BOOL)isTableExsit:(NSString *)tableName
{
    FMResultSet *rs = [_db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"isTableExsit %d", count);
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return NO;
}

- (void)insertInto:(RoleType)roleType
{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO callRecent (ROLRTYPE) VALUES('%i')",roleType];
    BOOL insertResult = [_db executeUpdate:insertSql];
    if (insertResult)
    {
        NSLog(@"-----%@--插入成功",insertSql);
    }
    else
    {
        NSLog(@"-------插入失败");
    }
}

- (RoleType)queryRecent
{
    NSString *sql = [NSString stringWithFormat:@"select * from callRecent"];
    FMResultSet *resultSet = [_db executeQuery:sql];
    while ([resultSet next])
    {
        RoleType type = [resultSet intForColumn:@"ROLRTYPE"];
        NSLog(@"-----%i---",type);
    }
    
    return -1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self queryRecent];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




@end
