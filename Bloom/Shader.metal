//
//  Shader.metal
//  Bloom
//
//  Created by Eric Hodgins on 2017-10-14.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Constants {
    float animateBy;
    float time;
    float2 resolution;
};

struct VertexIn {
    float4 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
};

struct VertexOut {
    float4 position [[ position ]];
    float4 color;
};

// Input is triangle vertices and vertexId is the current vertex
vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]] ,constant Constants &constants [[ buffer(1) ]], uint vertexId [[ vertex_id ]]) {
    
    VertexOut vertexOut;
    vertexOut.position = vertexIn.position;
    vertexOut.color = vertexIn.color;
    
    //float4 position = float4(vertices[vertexId], 1);
    //vertexOut.position.x += constants.animateBy;
    
    return vertexOut;
}

fragment half4 fragment_shader(VertexOut vertexIn [[ stage_in ]], constant Constants &constants [[ buffer(1) ]]) {
    int MAX_ITER = 2;
    float2 v_texCoord = vertexIn.position.xy / constants.resolution;
    
    float2 p =  v_texCoord * 8.0 - float2(20.0);
    float2 i = p;
    float c = 1.0;
    float inten = 0.005;
    
    for (int n = 0; n < MAX_ITER; n++)
    {
        float t = constants.time/10.0 * (1.0 - (3.0 / float(n+1)));
        
        i = p + float2(cos(t - i.x) + sin(t + i.y),
                       sin(t - i.y) + cos(t + i.x));
        
        c += 1.0/length(float2(p.x / (sin(i.x+t)/inten),
                               p.y / (cos(i.y+t)/inten)));
    }
    
    c /= float(MAX_ITER);
    c = 1.5 - sqrt(c);
    
    half4 texColor = half4(0.1, 0.02, 0.3, 1.0);
    
    texColor.rgb *= (1.0 / (1.0 - (c + 0.0)));
    
    return texColor;
}
