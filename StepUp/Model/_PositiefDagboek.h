// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PositiefDagboek.h instead.

#import <CoreData/CoreData.h>
#import "AFLSerializationManagedObject.h"

extern const struct PositiefDagboekAttributes {
	__unsafe_unretained NSString *behandelingnummer;
	__unsafe_unretained NSString *dag;
	__unsafe_unretained NSString *item1;
	__unsafe_unretained NSString *item2;
	__unsafe_unretained NSString *item3;
} PositiefDagboekAttributes;

@interface PositiefDagboekID : NSManagedObjectID {}
@end

@interface _PositiefDagboek : AFLSerializationManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PositiefDagboekID* objectID;

@property (nonatomic, strong) NSNumber* behandelingnummer;

@property (atomic) int16_t behandelingnummerValue;
- (int16_t)behandelingnummerValue;
- (void)setBehandelingnummerValue:(int16_t)value_;

//- (BOOL)validateBehandelingnummer:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* dag;

//- (BOOL)validateDag:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* item1;

//- (BOOL)validateItem1:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* item2;

//- (BOOL)validateItem2:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* item3;

//- (BOOL)validateItem3:(id*)value_ error:(NSError**)error_;

@end

@interface _PositiefDagboek (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveBehandelingnummer;
- (void)setPrimitiveBehandelingnummer:(NSNumber*)value;

- (int16_t)primitiveBehandelingnummerValue;
- (void)setPrimitiveBehandelingnummerValue:(int16_t)value_;

- (NSString*)primitiveDag;
- (void)setPrimitiveDag:(NSString*)value;

- (NSString*)primitiveItem1;
- (void)setPrimitiveItem1:(NSString*)value;

- (NSString*)primitiveItem2;
- (void)setPrimitiveItem2:(NSString*)value;

- (NSString*)primitiveItem3;
- (void)setPrimitiveItem3:(NSString*)value;

@end
