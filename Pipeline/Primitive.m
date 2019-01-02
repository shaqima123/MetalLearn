//
//  Primitive.m
//  Pipeline
//
//  Created by Kira on 2018/12/17.
//  Copyright © 2018 Kira. All rights reserved.
//

#import "Primitive.h"

@implementation Primitive

+ (MDLMesh *)makeCubeWithDevice:(id<MTLDevice>)device andSize:(CGFloat)size {
    MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
    
    vector_float3 extent = {size, size, size};
    vector_uint3 segment = {1,1,1};
    MDLMesh *mesh = [[MDLMesh alloc] initBoxWithExtent:extent
                                              segments:segment
                                         inwardNormals:NO
                                          geometryType:MDLGeometryTypeTriangles
                                             allocator:allocator];
    return mesh;
}

@end
