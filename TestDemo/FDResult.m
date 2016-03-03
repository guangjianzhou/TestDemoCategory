//
//  FDResult.m
//
//  Created by guangjianzhou  on 15/12/16
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "FDResult.h"
#import "FDRecipe.h"


NSString *const kFDResultCtgIds = @"ctgIds";
NSString *const kFDResultCtgTitles = @"ctgTitles";
NSString *const kFDResultRecipe = @"recipe";
NSString *const kFDResultMenuId = @"menuId";
NSString *const kFDResultName = @"name";
NSString *const kFDResultThumbnail = @"thumbnail";


@interface FDResult ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FDResult

@synthesize ctgIds = _ctgIds;
@synthesize ctgTitles = _ctgTitles;
@synthesize recipe = _recipe;
@synthesize menuId = _menuId;
@synthesize name = _name;
@synthesize thumbnail = _thumbnail;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.ctgIds = [self objectOrNilForKey:kFDResultCtgIds fromDictionary:dict];
            self.ctgTitles = [self objectOrNilForKey:kFDResultCtgTitles fromDictionary:dict];
            self.recipe = [FDRecipe modelObjectWithDictionary:[dict objectForKey:kFDResultRecipe]];
            self.menuId = [self objectOrNilForKey:kFDResultMenuId fromDictionary:dict];
            self.name = [self objectOrNilForKey:kFDResultName fromDictionary:dict];
            self.thumbnail = [self objectOrNilForKey:kFDResultThumbnail fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForCtgIds = [NSMutableArray array];
    for (NSObject *subArrayObject in self.ctgIds) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCtgIds addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCtgIds addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCtgIds] forKey:kFDResultCtgIds];
    [mutableDict setValue:self.ctgTitles forKey:kFDResultCtgTitles];
    [mutableDict setValue:[self.recipe dictionaryRepresentation] forKey:kFDResultRecipe];
    [mutableDict setValue:self.menuId forKey:kFDResultMenuId];
    [mutableDict setValue:self.name forKey:kFDResultName];
    [mutableDict setValue:self.thumbnail forKey:kFDResultThumbnail];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.ctgIds = [aDecoder decodeObjectForKey:kFDResultCtgIds];
    self.ctgTitles = [aDecoder decodeObjectForKey:kFDResultCtgTitles];
    self.recipe = [aDecoder decodeObjectForKey:kFDResultRecipe];
    self.menuId = [aDecoder decodeObjectForKey:kFDResultMenuId];
    self.name = [aDecoder decodeObjectForKey:kFDResultName];
    self.thumbnail = [aDecoder decodeObjectForKey:kFDResultThumbnail];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_ctgIds forKey:kFDResultCtgIds];
    [aCoder encodeObject:_ctgTitles forKey:kFDResultCtgTitles];
    [aCoder encodeObject:_recipe forKey:kFDResultRecipe];
    [aCoder encodeObject:_menuId forKey:kFDResultMenuId];
    [aCoder encodeObject:_name forKey:kFDResultName];
    [aCoder encodeObject:_thumbnail forKey:kFDResultThumbnail];
}

- (id)copyWithZone:(NSZone *)zone
{
    FDResult *copy = [[FDResult alloc] init];
    
    if (copy) {

        copy.ctgIds = [self.ctgIds copyWithZone:zone];
        copy.ctgTitles = [self.ctgTitles copyWithZone:zone];
        copy.recipe = [self.recipe copyWithZone:zone];
        copy.menuId = [self.menuId copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.thumbnail = [self.thumbnail copyWithZone:zone];
    }
    
    return copy;
}


@end
