// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MindfulnessDagboek.h instead.

#import <CoreData/CoreData.h>
#import "AFLSerializationManagedObject.h"

extern const struct MindfulnessDagboekAttributes {
	__unsafe_unretained NSString *ademruimte;
	__unsafe_unretained NSString *behandelingnummer;
	__unsafe_unretained NSString *bodyscan;
	__unsafe_unretained NSString *dag;
} MindfulnessDagboekAttributes;

@interface MindfulnessDagboekID : NSManagedObjectID {}
@end

@interface _MindfulnessDagboek : AFLSerializationManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MindfulnessDagboekID* objectID;

@property (nonatomic, strong) NSNumber* ademruimte;

@property (atomic) BOOL ademruimteValue;
- (BOOL)ademruimteValue;
- (void)setAdemruimteValue:(BOOL)value_;

//- (BOOL)validateAdemruimte:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* behandelingnummer;

@property (atomic) int16_t behandelingnummerValue;
- (int16_t)behandelingnummerValue;
- (void)setBehandelingnummerValue:(int16_t)value_;

//- (BOOL)validateBehandelingnummer:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* bodyscan;

@property (atomic) BOOL bodyscanValue;
- (BOOL)bodyscanValue;
- (void)setBodyscanValue:(BOOL)value_;

//- (BOOL)validateBodyscan:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* dag;

//- (BOOL)validateDag:(id*)value_ error:(NSError**)error_;

@end

@interface _MindfulnessDagboek (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveAdemruimte;
- (void)setPrimitiveAdemruimte:(NSNumber*)value;

- (BOOL)primitiveAdemruimteValue;
- (void)setPrimitiveAdemruimteValue:(BOOL)value_;

- (NSNumber*)primitiveBehandelingnummer;
- (void)setPrimitiveBehandelingnummer:(NSNumber*)value;

- (int16_t)primitiveBehandelingnummerValue;
- (void)setPrimitiveBehandelingnummerValue:(int16_t)value_;

- (NSNumber*)primitiveBodyscan;
- (void)setPrimitiveBodyscan:(NSNumber*)value;

- (BOOL)primitiveBodyscanValue;
- (void)setPrimitiveBodyscanValue:(BOOL)value_;

- (NSString*)primitiveDag;
- (void)setPrimitiveDag:(NSString*)value;

@end
