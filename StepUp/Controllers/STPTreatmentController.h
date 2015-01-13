//
//  STPTreatmentController.h
//  StepUp
//
//  Created by Eelco Koelewijn on 24/05/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BewegenDagboek.h"
#import "MindfulnessDagboek.h"
#import "PositiefDagboek.h"

typedef NS_ENUM(NSInteger, TreatmentType){
    TreatmentTypeActivity= 0,
    TreatmentTypeMindfulness= 1,
    TreatmentTypePositive=2
};

@interface STPTreatmentController : NSObject
- (BOOL)saveTreatment:(NSDictionary *)treatment withActivityTreatmentData:(NSDictionary *)data;
- (BOOL)saveTreatment:(NSDictionary *)treatment withMindfulnessTreatmentData:(NSDictionary *)data;
- (BOOL)saveTreatment:(NSDictionary *)treatment withPositiveTreatmentData:(NSDictionary *)data;

- (BewegenDagboek *)getActivityTreatmentForWeeknumber:(NSInteger)weeknumber andDay:(NSString *)day;
- (MindfulnessDagboek *)getMindfulnessTreatmentForWeeknumber:(NSInteger)weeknumber andDay:(NSString *)day;
- (PositiefDagboek *)getPositiveTreatmentForWeeknumber:(NSInteger)weeknumber andDay:(NSString *)day;

- (NSArray *)getAllTreatmentsForEntity:(NSString *)entityName inManagedObjectContext:(NSManagedObjectContext *)context;
- (void)deleteAllTreatmentsInManagedObjectContext:(NSManagedObjectContext *)context;
@end
