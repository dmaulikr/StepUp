//
//  STPTreatmentController.m
//  StepUp
//
//  Created by Eelco Koelewijn on 24/05/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import "STPTreatmentController.h"
#import "TBCoreDataStore.h"

@implementation STPTreatmentController

#pragma mark - save treament data

- (BOOL)saveTreatment:(NSDictionary *)treatment withActivityTreatmentData:(NSDictionary *)data
{
    if ([self validateAcitivityData:data]) {
        NSManagedObjectContext *context = [TBCoreDataStore mainQueueContext];
        BewegenDagboek *bewegenDagboekEntry = [BewegenDagboek createManagedObject:[BewegenDagboek entityName] inContext:context];
        bewegenDagboekEntry.behandelingnummer = [data objectForKey:@"weeknumber"];
        bewegenDagboekEntry.dag = [treatment objectForKey:@"day"];
        bewegenDagboekEntry.intensiteit = [data objectForKey:@"intensity"];
        bewegenDagboekEntry.training = [data objectForKey:@"training"];
        bewegenDagboekEntry.plezier = [data objectForKey:@"fun"];
        [bewegenDagboekEntry saveInManagedObjectContext:context error:nil];
        return YES;
    }
    return NO;
}

- (BOOL)saveTreatment:(NSDictionary *)treatment withMindfulnessTreatmentData:(NSDictionary *)data
{
    if ([self validateMindfulnessData:data]) {
        NSManagedObjectContext *context = [TBCoreDataStore mainQueueContext];
        MindfulnessDagboek *mindfulnessDagboek = [MindfulnessDagboek createManagedObject:[MindfulnessDagboek entityName] inContext:context];
        mindfulnessDagboek.bodyscan = [data objectForKey:@"bodyscan"];
        mindfulnessDagboek.ademruimte = [data objectForKey:@"breathing"];
        mindfulnessDagboek.behandelingnummer = [data objectForKey:@"weeknumber"];
        mindfulnessDagboek.dag = [treatment objectForKey:@"day"];
        [mindfulnessDagboek saveInManagedObjectContext:context error:nil];
        return YES;
    }
    return NO;
}

- (BOOL)saveTreatment:(NSDictionary *)treatment withPositiveTreatmentData:(NSDictionary *)data
{
    if ([self validatePositiveData:data]) {
        NSManagedObjectContext *context = [TBCoreDataStore mainQueueContext];
        PositiefDagboek *positiefDagboek = [PositiefDagboek createManagedObject:[PositiefDagboek entityName] inContext:context];
        positiefDagboek.item1 = [data objectForKey:@"positive1"];
        positiefDagboek.item2 = [data objectForKey:@"positive2"];
        positiefDagboek.item3 = [data objectForKey:@"positive3"];
        positiefDagboek.behandelingnummer = [data objectForKey:@"weeknumber"];
        positiefDagboek.dag = [treatment objectForKey:@"day"];
        [positiefDagboek saveInManagedObjectContext:context error:nil];
        return YES;
    }
    return NO;
}

#pragma mark - validation of data

- (BOOL)validateAcitivityData:(NSDictionary *)data
{
    if ([[data objectForKey:@"intensity"] integerValue] == UISegmentedControlNoSegment) {
        return NO;
    } else if ([[data objectForKey:@"training"] integerValue] == UISegmentedControlNoSegment) {
        return NO;
    } else if ([[data objectForKey:@"fun"] integerValue] == UISegmentedControlNoSegment) {
        return NO;
    }
    return YES;
}

- (BOOL)validateMindfulnessData:(NSDictionary *)data
{
    if ([[data objectForKey:@"bodyscan"] integerValue] == 0) {
        return NO;
    } else if ([[data objectForKey:@"breathing"] integerValue] == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)validatePositiveData:(NSDictionary *)data
{
    if ([[data objectForKey:@"positive1"] length] == 0) {
        return NO;
    } else if ([[data objectForKey:@"positive2"] length] == 0) {
        return NO;
    } else if ([[data objectForKey:@"positive3"] length] == 0) {
        return NO;
    }
    return YES;
}

#pragma mark - retrieve treatment

- (BewegenDagboek *)getActivityTreatmentForWeeknumber:(NSInteger)weeknumber andDay:(NSString *)day;
{
    return [BewegenDagboek getBewegenDagboekForWeeknumber:weeknumber andDay:day];
}

- (MindfulnessDagboek *)getMindfulnessTreatmentForWeeknumber:(NSInteger)weeknumber andDay:(NSString *)day
{
    return [MindfulnessDagboek getMindfulnessDagboekForWeeknumber:weeknumber andDay:day];
}

- (PositiefDagboek *)getPositiveTreatmentForWeeknumber:(NSInteger)weeknumber andDay:(NSString *)day
{
    return [PositiefDagboek getPositiefDagboekForWeeknumber:weeknumber andDay:day];
}

#pragma mark - return all treaments for entity

- (NSArray *)getAllTreatmentsForEntity:(NSString *)entityName inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortBehandelingNr = [[NSSortDescriptor alloc] initWithKey:@"behandelingnummer"
                                                                   ascending:YES];
    NSSortDescriptor *sortDag = [[NSSortDescriptor alloc] initWithKey:@"dag"
                                                                      ascending:YES];

    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortBehandelingNr,sortDag, nil]];
    
    return [context executeFetchRequest:fetchRequest error:nil];
}

#pragma mark - delete all treatments

- (void)deleteAllTreatmentsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *activityTreatments = [self getAllTreatmentsForEntity:[BewegenDagboek entityName] inManagedObjectContext:context];
    NSArray *positiveTreatments = [self getAllTreatmentsForEntity:[PositiefDagboek entityName] inManagedObjectContext:context];
    NSArray *mindfullnesTreatments = [self getAllTreatmentsForEntity:[MindfulnessDagboek entityName] inManagedObjectContext:context];

    [self deleteTreatments:activityTreatments inManagedObjectContext:context];
    [self deleteTreatments:positiveTreatments inManagedObjectContext:context];
    [self deleteTreatments:mindfullnesTreatments inManagedObjectContext:context];
    
    if ([context hasChanges]) {
        [context save:nil];
    }
}

- (void)deleteTreatments:(NSArray *)treatments inManagedObjectContext:(NSManagedObjectContext *)context
{
    for (NSManagedObject *entity in treatments) {
        [context deleteObject:entity];
    }
}


@end