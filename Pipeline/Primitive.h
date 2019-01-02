//
//  Primitive.h
//  Pipeline
//
//  Created by Kira on 2018/12/17.
//  Copyright © 2018 Kira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Primitive : NSObject

+ (MDLMesh *)makeCubeWithDevice:(id<MTLDevice>)device andSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
