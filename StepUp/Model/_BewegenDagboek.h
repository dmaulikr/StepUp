// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BewegenDagboek.h instead.

#import <CoreData/CoreData.h>
#import "AFLSerializationManagedObject.h"

extern const struct BewegenDagboekAttributes {
	__unsafe_unretained NSString *behandelingnummer;
	__unsafe_unretained NSString *dag;
	__unsafe_unretained NSString *intensiteit;
	__unsafe_unretained NSString *plezier;
	__unsafe_unretained NSString *training;
} BewegenDagboekAttributes;

@interface BewegenDagboekID : NSManagedObjectID {}
@end

@interface _BewegenDagboek : AFLSerializationManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BewegenDagboekID* objectID;

@property (nonatomic, strong) NSNumber* behandelingnummer;

@property (atomic) int16_t behandelingnummerValue;
- (int16_t)behandelingnummerValue;
- (void)setBehandelingnummerValue:(int16_t)value_;

//- (BOOL)validateBehandelingnummer:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* dag;

//- (BOOL)validateDag:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* intensiteit;

@property (atomic) int16_t intensiteitValue;
- (int16_t)intensiteitValue;
- (void)setIntensiteitValue:(int16_t)value_;

//- (BOOL)validateIntensiteit:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* plezier;

@property (atomic) int16_t plezierValue;
- (int16_t)plezierValue;
- (void)setPlezierValue:(int16_t)value_;

//- (BOOL)validatePlezier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* training;

@property (atomic) int16_t trainingValue;
- (int16_t)trainingValue;
- (void)setTrainingValue:(int16_t)value_;

//- (BOOL)validateTraining:(id*)value_ error:(NSError**)error_;

@end

@interface _BewegenDagboek (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveBehandelingnummer;
- (void)setPrimitiveBehandelingnummer:(NSNumber*)value;

- (int16_t)primitiveBehandelingnummerValue;
- (void)setPrimitiveBehandelingnummerValue:(int16_t)value_;

- (NSString*)primitiveDag;
- (void)setPrimitiveDag:(NSString*)value;

- (NSNumber*)primitiveIntensiteit;
- (void)setPrimitiveIntensiteit:(NSNumber*)value;

- (int16_t)primitiveIntensiteitValue;
- (void)setPrimitiveIntensiteitValue:(int16_t)value_;

- (NSNumber*)primitivePlezier;
- (void)setPrimitivePlezier:(NSNumber*)value;

- (int16_t)primitivePlezierValue;
- (void)setPrimitivePlezierValue:(int16_t)value_;

- (NSNumber*)primitiveTraining;
- (void)setPrimitiveTraining:(NSNumber*)value;

- (int16_t)primitiveTrainingValue;
- (void)setPrimitiveTrainingValue:(int16_t)value_;

@end
