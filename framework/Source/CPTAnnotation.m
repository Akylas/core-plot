#import "CPTAnnotation.h"

#import "CPTAnnotationHostLayer.h"
#import "NSCoderExtensions.h"

/** @brief An annotation positions a content layer relative to some anchor point.
 *
 *  Annotations can be used to add text or images that are anchored to a feature
 *  of a graph. For example, the graph title is an annotation anchored to the graph.
 *  The annotation content layer can be any CPTLayer.
 **/
@implementation CPTAnnotation

/** @property CPTLayer *contentLayer
 *  @brief The annotation content.
 **/
@synthesize contentLayer;

/** @property cpt_weak CPTAnnotationHostLayer *annotationHostLayer
 *  @brief The host layer for the annotation content.
 **/
@synthesize annotationHostLayer;

/** @property CGPoint displacement
 *  @brief The displacement from the layer anchor point.
 **/
@synthesize displacement;

/** @property CGPoint contentAnchorPoint
 *  @brief The anchor point for the content layer.
 **/
@synthesize contentAnchorPoint;

/** @property CGFloat rotation
 *  @brief The rotation of the label in radians.
 **/
@synthesize rotation;

@synthesize visible;


#pragma mark -
#pragma mark Init/Dealloc

/// @name Initialization
/// @{

/** @brief Initializes a newly allocated CPTAnnotation object.
 *
 *  The initialized object will have the following properties:
 *  - @ref annotationHostLayer = @nil
 *  - @ref contentLayer = @nil
 *  - @ref displacement = (@num{0.0}, @num{0.0})
 *  - @ref contentAnchorPoint = (@num{0.5}, @num{0.5})
 *  - @ref rotation = @num{0.0}
 *
 *  @return The initialized object.
 **/
-(instancetype)init
{
    if ( (self = [super init]) ) {
        annotationHostLayer = nil;
        contentLayer        = nil;
        displacement        = CGPointZero;
        contentAnchorPoint  = CPTPointMake(0.5, 0.5);
        rotation            = CPTFloat(0.0);
        visible            = YES;
    }
    return self;
}

/// @}

#pragma mark -
#pragma mark NSCoding Methods

/// @cond

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeConditionalObject:self.annotationHostLayer forKey:@"CPTAnnotation.annotationHostLayer"];
    [coder encodeObject:self.contentLayer forKey:@"CPTAnnotation.contentLayer"];
    [coder encodeCPTPoint:self.contentAnchorPoint forKey:@"CPTAnnotation.contentAnchorPoint"];
    [coder encodeCPTPoint:self.displacement forKey:@"CPTAnnotation.displacement"];
    [coder encodeCGFloat:self.rotation forKey:@"CPTAnnotation.rotation"];
    [coder encodeCGFloat:self.visible forKey:@"CPTAnnotation.visible"];
}

-(instancetype)initWithCoder:(NSCoder *)coder
{
    if ( (self = [super init]) ) {
        annotationHostLayer = [coder decodeObjectForKey:@"CPTAnnotation.annotationHostLayer"];
        contentLayer        = [coder decodeObjectForKey:@"CPTAnnotation.contentLayer"];
        contentAnchorPoint  = [coder decodeCPTPointForKey:@"CPTAnnotation.contentAnchorPoint"];
        displacement        = [coder decodeCPTPointForKey:@"CPTAnnotation.displacement"];
        rotation            = [coder decodeCGFloatForKey:@"CPTAnnotation.rotation"];
        visible             = [coder decodeBoolForKey:@"CPTAnnotation.visible"];
    }
    return self;
}

/// @endcond

#pragma mark -
#pragma mark Description

/// @cond

-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@ {%@}>", [super description], self.contentLayer];
}

/// @endcond

#pragma mark -
#pragma mark Accessors

/// @cond

-(void)setContentLayer:(CPTLayer *)newLayer
{
    if ( newLayer != contentLayer ) {
        [contentLayer removeFromSuperlayer];
        contentLayer = newLayer;
        if ( newLayer ) {
            CPTAnnotationHostLayer *hostLayer = self.annotationHostLayer;
            [hostLayer addSublayer: newLayer];
            contentLayer.hidden = !self.visible;
        }
    }
}

-(void)setAnnotationHostLayer:(CPTAnnotationHostLayer *)newLayer
{
    if ( newLayer != annotationHostLayer ) {
        CPTLayer *myContent = self.contentLayer;

        [myContent removeFromSuperlayer];
        annotationHostLayer = newLayer;
        if ( myContent ) {
            [newLayer addSublayer:myContent];
        }
    }
}

-(void)setVisible:(BOOL)newValue
{
    visible = newValue;
    if (self.contentLayer) {
        self.contentLayer.hidden = !visible;
        [[self.contentLayer superlayer] setNeedsLayout];
    }
}

-(void)setDisplacement:(CGPoint)newDisplacement
{
    if ( !CGPointEqualToPoint(newDisplacement, displacement) ) {
        displacement = newDisplacement;
        [[self.contentLayer superlayer] setNeedsLayout];
    }
}

-(void)setContentAnchorPoint:(CGPoint)newAnchorPoint
{
    if ( !CGPointEqualToPoint(newAnchorPoint, contentAnchorPoint) ) {
        contentAnchorPoint = newAnchorPoint;
        [[self.contentLayer superlayer] setNeedsLayout];
    }
}

-(void)setRotation:(CGFloat)newRotation
{
    if ( newRotation != rotation ) {
        rotation = newRotation;
        [[self.contentLayer superlayer] setNeedsLayout];
    }
}

/// @endcond

@end

#pragma mark -
#pragma mark Layout

@implementation CPTAnnotation(AbstractMethods)

/** @brief Positions the content layer relative to its reference anchor.
 *
 *  This method must be overridden by subclasses. The default implementation
 *  does nothing.
 **/
-(void)positionContentLayer
{
    // Do nothing--implementation provided by subclasses
}

@end
