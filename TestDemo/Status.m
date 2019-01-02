//
//  Status.m
//  TestDemo
//
//  Created by guangjianzhou on 15/12/14.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import "Status.h"
#import "MJExtension.h"

@implementation Status

- (void)setMissionList:(NSMutableArray *)missionList
{
    NSLog(@"setMissionList=======");
    NSMutableArray *datamissionListArray = [NSMutableArray array];
    for (NSArray *data in missionList) {
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dic in data) {
            
            MeetModel *meetModel = [MeetModel mj_objectWithKeyValues:dic];
            [dataArray addObject:meetModel];
        }
        
        [datamissionListArray addObject:dataArray];
    }
    
    _missionList = datamissionListArray;
}




@end
