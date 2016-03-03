//
//  FDResult.h
//
//  Created by guangjianzhou  on 15/12/16
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FDRecipe;

@interface FDResult : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *ctgIds;
@property (nonatomic, strong) NSString *ctgTitles;
@property (nonatomic, strong) FDRecipe *recipe;
@property (nonatomic, strong) NSString *menuId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *thumbnail;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
