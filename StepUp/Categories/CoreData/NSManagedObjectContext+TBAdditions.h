//
//  NSManagedObjectContext+TBAdditions.h
//  TBCoreDataStore
//
//  Created by Theodore Calmes on 1/17/14.
//  Copyright (c) 2014 thoughtbot. All rights reserved.
//

@import CoreData;

@interface NSManagedObjectContext (TBAdditions)

/**
 *  Retrieve full entities based on array of object ids
 *
 *  @param objectIDs List of entity object ids
 *
 *  @return List of full entities
 */
- (NSArray *)objectsWithObjectIDs:(NSArray *)objectIDs;

@end
