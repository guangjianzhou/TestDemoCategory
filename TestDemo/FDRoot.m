//
//  FDRoot.m
//
//  Created by guangjianzhou  on 15/12/16
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "FDRoot.h"
#import "FDResult.h"


NSString *const kFDRootMsg = @"msg";
NSString *const kFDRootResult = @"result";
NSString *const kFDRootRetCode = @"retCode";


@interface FDRoot ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FDRoot

@synthesize msg = _msg;
@synthesize result = _result;
@synthesize retCode = _retCode;


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
            self.msg = [self objectOrNilForKey:kFDRootMsg fromDictionary:dict];
            self.result = [FDResult modelObjectWithDictionary:[dict objectForKey:kFDRootResult]];
            self.retCode = [self objectOrNilForKey:kFDRootRetCode fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.msg forKey:kFDRootMsg];
    [mutableDict setValue:[self.result dictionaryRepresentation] forKey:kFDRootResult];
    [mutableDict setValue:self.retCode forKey:kFDRootRetCode];

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

    self.msg = [aDecoder decodeObjectForKey:kFDRootMsg];
    self.result = [aDecoder decodeObjectForKey:kFDRootResult];
    self.retCode = [aDecoder decodeObjectForKey:kFDRootRetCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_msg forKey:kFDRootMsg];
    [aCoder encodeObject:_result forKey:kFDRootResult];
    [aCoder encodeObject:_retCode forKey:kFDRootRetCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    FDRoot *copy = [[FDRoot alloc] init];
    
    if (copy) {

        copy.msg = [self.msg copyWithZone:zone];
        copy.result = [self.result copyWithZone:zone];
        copy.retCode = [self.retCode copyWithZone:zone];
    }
    
    return copy;
}


@end
