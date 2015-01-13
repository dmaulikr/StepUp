//
//  NSManagedObjectID+TBString.m
//  TBCoreDataStore
//
//  Created by Theodore Calmes on 1/17/14.
//  Copyright (c) 2014 thoughtbot. All rights reserved.
//

#import "NSManagedObjectID+TBString.h"

@implementation NSManagedObjectID (TBString)

/**
 *  String representations of entity object id
 *
 *  @return String repesentation of entity object id
 */
- (NSString *)stringRepresentation
{
    return [[self URIRepresentation] absoluteString];
}

@end
