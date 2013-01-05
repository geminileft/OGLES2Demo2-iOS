//
//  DemoViewController.m
//  StencilDemo
//
//  Created by dev on 12/12/12.
//  Copyright (c) 2012 forest friendly services. All rights reserved.
//

#import "DemoViewController.h"
#import "GraphicsUtils.h"

@interface DemoViewController (private)

-(void) initGL;

@end

@implementation DemoViewController

- (id) init {
    self = [super init];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        [EAGLContext setCurrentContext:context];
        const CGRect frame = [[UIScreen mainScreen] bounds];
        mWidth = frame.size.width;
        mHeight = frame.size.height;
        GLKView* glView = [[GLKView alloc] initWithFrame:frame context:context];
        glView.delegate = self;
        self.view = glView;
        [context release];
        [glView release];
        [self initGL];
        self.preferredFramesPerSecond = 60;
    }
    return self;
}

-(void) initGL {
    NSString* vSource;
    NSString* fSource;
    vSource = [GraphicsUtils readShaderFile:@"basic.vsh"];
    fSource = [GraphicsUtils readShaderFile:@"basic.fsh"];
    const uint progId = [GraphicsUtils createProgramVertexSource:vSource fragmentSource:fSource];
    [GraphicsUtils activateProgram:progId];
    //set clear color
    glClearColor(.25f, .25f, .25f, 1);
    //read attribute locations and enable
    maColor = glGetAttribLocation(progId, "aColor");
    glEnableVertexAttribArray(maColor);
    maVertices = glGetAttribLocation(progId, "aVertices");
    glEnableVertexAttribArray(maVertices);
    
    const float halfWidth = mWidth / 2.0f;
    const float halfHeight = mHeight / 2.0f;
    
    glViewport(0, 0, mWidth, mHeight);
    
    //set matrices and pass to shader
    
    GLKMatrix4 projMatrix = GLKMatrix4MakeOrtho(-halfWidth, halfWidth, -halfHeight, halfHeight, -1, 1);
    int uProjectionMatrix = glGetUniformLocation(progId, "uProjectionMatrix");
    glUniformMatrix4fv(uProjectionMatrix, 1, false, &projMatrix.m[0]);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //clear screen
    glClear(GL_COLOR_BUFFER_BIT);
    
    //set color buffer and pass to shader
    float colors[] = {
        1.0f, 0.0f, 1.0f, 0.0f
        , 1.0f, 0.0f, 1.0f, 0.0f
        , 1.0f, 0.0f, 1.0f, 0.0f
        , 1.0f, 0.0f, 1.0f, 0.0f
    };
    glVertexAttribPointer(maColor, 4, GL_FLOAT, false, 0, &colors[0]);
    
    //measure out vertices and set for quad
    const float SIZE = 50;
    const float leftX = -SIZE;
    const float rightX = SIZE;
    const float topY = SIZE;
    const float bottomY = -SIZE;
    
    //triangles
    const float vertices[] = {
        leftX, bottomY
        , rightX, bottomY
        , leftX, topY
        , rightX, topY
    };
    
    glVertexAttribPointer(maVertices, 2, GL_FLOAT, false, 0, &vertices[0]);
    
    //indices
    const ushort indices[] = {
        0, 1, 2, 1, 2, 3
    };
    
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, &indices[0]);
}

@end
