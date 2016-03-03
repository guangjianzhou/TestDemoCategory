//
//  FDRecipe.m
//
//  Created by guangjianzhou  on 15/12/16
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "FDRecipe.h"
#import "FDMethod.h"


NSString *const kFDRecipeImg = @"img";
NSString *const kFDRecipeMethod = @"method";
NSString *const kFDRecipeTitle = @"title";
NSString *const kFDRecipeSumary = @"sumary";


@interface FDRecipe ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FDRecipe

@synthesize img = _img;
@synthesize method = _method;
@synthesize title = _title;
@synthesize sumary = _sumary;


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
            self.img = [self objectOrNilForKey:kFDRecipeImg fromDictionary:dict];
    NSString *receivedFDMethod = [dict objectForKey:kFDRecipeMethod];
        
    NSData *jsonData = [receivedFDMethod dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
    NSMutableArray *parsedFDMethod = [NSMutableArray array];
    if ([receivedFDMethod isKindOfClass:[NSString class]]) {
        for (NSDictionary *item in dataArray) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedFDMethod addObject:[FDMethod modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedFDMethod isKindOfClass:[NSDictionary class]]) {
       [parsedFDMethod addObject:[FDMethod modelObjectWithDictionary:(NSDictionary *)receivedFDMethod]];
    }

    self.method = [NSArray arrayWithArray:parsedFDMethod];
            self.title = [self objectOrNilForKey:kFDRecipeTitle fromDictionary:dict];
            self.sumary = [self objectOrNilForKey:kFDRecipeSumary fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.img forKey:kFDRecipeImg];
    NSMutableArray *tempArrayForMethod = [NSMutableArray array];
    for (NSObject *subArrayObject in self.method) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForMethod addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForMethod addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForMethod] forKey:kFDRecipeMethod];
    [mutableDict setValue:self.title forKey:kFDRecipeTitle];
    [mutableDict setValue:self.sumary forKey:kFDRecipeSumary];

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

    self.img = [aDecoder decodeObjectForKey:kFDRecipeImg];
    self.method = [aDecoder decodeObjectForKey:kFDRecipeMethod];
    self.title = [aDecoder decodeObjectForKey:kFDRecipeTitle];
    self.sumary = [aDecoder decodeObjectForKey:kFDRecipeSumary];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_img forKey:kFDRecipeImg];
    [aCoder encodeObject:_method forKey:kFDRecipeMethod];
    [aCoder encodeObject:_title forKey:kFDRecipeTitle];
    [aCoder encodeObject:_sumary forKey:kFDRecipeSumary];
}

- (id)copyWithZone:(NSZone *)zone
{
    FDRecipe *copy = [[FDRecipe alloc] init];
    
    if (copy) {

        copy.img = [self.img copyWithZone:zone];
        copy.method = [self.method copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.sumary = [self.sumary copyWithZone:zone];
    }
    
    return copy;
}


@end
