//
//  Renderer.m
//  Pipeline
//
//  Created by Kira on 2018/12/17.
//  Copyright © 2018 Kira. All rights reserved.
//

#import <Metal/Metal.h>

#import "Renderer.h"
#import "Primitive.h"

static id<MTLDevice> device;
static id<MTLCommandQueue> commandQueue;

@interface Renderer()

@property (nonatomic, strong) MTKMesh *mesh;
@property (nonatomic, strong) id<MTLBuffer> vertexBuffer;
@property (nonatomic, strong) id<MTLRenderPipelineState> pipilineState;
@property (nonatomic, assign) float timer;

@end

@implementation Renderer 

- (instancetype)initWithMetalView:(MTKView *)metalView
{
    device = MTLCreateSystemDefaultDevice();
    NSAssert(device, @"GPU not available");
    if (!metalView) {
        return nil;
    }
    metalView.device = device;
    commandQueue = [device newCommandQueue];
    
    //从obj文件读取mdlmesh
    //****
    NSURL *assetUrl = [[NSBundle mainBundle] URLForResource:@"train" withExtension:@"obj"];
    if (!assetUrl) {
        return nil;
    }
    
    MTLVertexDescriptor *descriptor = [[MTLVertexDescriptor alloc] init];
    descriptor.attributes[0].format = MTLVertexFormatFloat3;
    descriptor.attributes[0].offset = 0;
    descriptor.attributes[0].bufferIndex = 0;
    
    descriptor.layouts[0].stride = sizeof(simd_float3);
    
    MDLVertexDescriptor* meshDescriptor = MTKModelIOVertexDescriptorFromMetal(descriptor);
    ((MDLVertexAttribute *)(meshDescriptor.attributes[0])).name = MDLVertexAttributePosition;
    
    MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
    MDLAsset *asset = [[MDLAsset alloc] initWithURL:assetUrl vertexDescriptor:meshDescriptor bufferAllocator:allocator];
    MDLMesh *mdlMesh = (MDLMesh *)[asset objectAtIndex:0];
    
    //****
    
    NSError *error = NULL;
    self.mesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:device error:&error];
    if (error) {
        NSAssert(NO, error.description);
    }
    
    self.vertexBuffer = self.mesh.vertexBuffers[0].buffer;
    
    id<MTLLibrary> library = [device newDefaultLibrary];
    id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertex_main"];
    id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragment_main"];
    
    MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineDescriptor.vertexFunction = vertexFunction;
    pipelineDescriptor.fragmentFunction = fragmentFunction;
    pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mdlMesh.vertexDescriptor);
    pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat;
    
    self.pipilineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
    if (error) {
        NSAssert(NO, error.description);
    }
    
    
    self = [super init];
    if (self) {
        metalView.clearColor = MTLClearColorMake(1, 1, 0.8, 1);
        NSLog(@"%lul, %lul",sizeof(CGFloat), sizeof(float));
        metalView.delegate = self;
        _timer = 0;
    }
    return self;
}



//Gets called every frame.
- (void)drawInMTKView:(MTKView *)view {
    MTLRenderPassDescriptor *descriptor = view.currentRenderPassDescriptor;
    id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    
    self.timer += 0.05;
    float currentTimer = sin(self.timer);
    [renderEncoder setVertexBytes:&currentTimer length:sizeof(float) atIndex:1];
    [renderEncoder setRenderPipelineState:self.pipilineState];
    [renderEncoder setVertexBuffer:self.vertexBuffer offset:0 atIndex:0];
    
    for (MTKSubmesh *submesh in self.mesh.submeshes) {
        [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                                  indexCount:submesh.indexCount
                                   indexType:submesh.indexType
                                 indexBuffer:submesh.indexBuffer.buffer
                           indexBufferOffset:submesh.indexBuffer.offset];
    }
    
    
    [renderEncoder endEncoding];
    
    id<CAMetalDrawable> drawable = [view currentDrawable];
    if (!drawable || !renderEncoder) {
        return;
    }
    
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

//Gets called every time the size of the window changes. This allows you to update the render coordinate system.
- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}

@end
