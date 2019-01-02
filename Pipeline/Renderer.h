//
//  Renderer.h
//  Pipeline
//
//  Created by Kira on 2018/12/17.
//  Copyright © 2018 Kira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Renderer : NSObject<MTKViewDelegate>

- (instancetype)initWithMetalView:(MTKView *)metalView;

@end

NS_ASSUME_NONNULL_END
