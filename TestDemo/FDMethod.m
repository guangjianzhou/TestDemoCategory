//
//  FDMethod.m
//
//  Created by guangjianzhou  on 15/12/16
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "FDMethod.h"


NSString *const kFDMethodImg = @"img";
NSString *const kFDMethodStep = @"step";


@interface FDMethod ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FDMethod

@synthesize img = _img;
@synthesize step = _step;


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
            self.img = [self objectOrNilForKey:kFDMethodImg fromDictionary:dict];
            self.step = [self objectOrNilForKey:kFDMethodStep fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.img forKey:kFDMethodImg];
    [mutableDict setValue:self.step forKey:kFDMethodStep];

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

    self.img = [aDecoder decodeObjectForKey:kFDMethodImg];
    self.step = [aDecoder decodeObjectForKey:kFDMethodStep];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_img forKey:kFDMethodImg];
    [aCoder encodeObject:_step forKey:kFDMethodStep];
}

- (id)copyWithZone:(NSZone *)zone
{
    FDMethod *copy = [[FDMethod alloc] init];
    
    if (copy) {

        copy.img = [self.img copyWithZone:zone];
        copy.step = [self.step copyWithZone:zone];
    }
    
    return copy;
}


@end
