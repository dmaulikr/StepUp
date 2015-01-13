//
//  EKArrayDataSource.h
//  FindIBeacons
//
//  Created by Eelco Koelewijn on 15/03/14.
//  Copyright (c) 2014 Eelco Koelewijn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EKArrayDataSource;

@protocol EKArrayDataSource <NSObject>

- (void)arrayDataSource:(EKArrayDataSource *)arrayDatasource configureCell:(id)cell withObject:(id)object;

@end

@interface EKArrayDataSource : NSObject <UITableViewDataSource>
@property (weak, nonatomic) id<EKArrayDataSource> delegate;
- (instancetype)initWithArrayDataSource:(NSArray *)arrayDataSource cellIdentifier:(NSString *)cellIdentifier;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
@end
