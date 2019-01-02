//
//  ViewController.m
//  Pipeline
//
//  Created by Kira on 2018/12/17.
//  Copyright © 2018 Kira. All rights reserved.
//

#import "ViewController.h"
#import <MetalKit/MetalKit.h>
#import "Renderer.h"

@interface ViewController()

@property (nonatomic, strong) Renderer *renderer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MTKView *metalView = (MTKView *)self.view;
    
    self.renderer = [[Renderer alloc] initWithMetalView:metalView];
    
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
