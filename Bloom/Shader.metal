//
//  Shader.metal
//  Bloom
//
//  Created by Eric Hodgins on 2017-10-14.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

#include <metal_stdlib>
#include <metal_math>
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
    
    return vertexOut;
}

/*
float CausticPatternFn(float2 pos, float time)
{
    float ActualTime = time/1.;
    return (sin(pos.x*40.+time)
            +pow(sin(-pos.x*130.+time),1.)
            +pow(sin(pos.x*30.+ActualTime),2.)
            +pow(sin(pos.x*50.+ActualTime),2.)
            +pow(sin(pos.x*80.+ActualTime),2.)
            +pow(sin(pos.x*90.+ActualTime),2.)
            +pow(sin(pos.x*12.+ActualTime),2.)
            +pow(sin(pos.x*6.+ActualTime),2.))/5.;
    
}

float2 CausticDistortDomainFn(float2 pos, float time)
{
    float ActualTime = time/100.;
    pos.x*=(pos.y*.20+.5);
    pos.x*=1.+sin(ActualTime/1.)/5.;
    return pos;
}

fragment half4 fragment_shader(VertexOut vertexIn [[ stage_in ]], constant Constants &constants [[ buffer(1) ]]) {
    float2 pos = vertexIn.position.xy / constants.resolution;
    float t = constants.time;
    pos -=.5;
    
    float2  CausticDistortedDomain = CausticDistortDomainFn(pos, t);
    float CausticPattern = CausticPatternFn(CausticDistortedDomain, t);
    float CausticShape = clamp(7.0 - length(CausticDistortedDomain*20.),0.,1.);
    float Caustic = CausticShape * CausticPattern;
    Caustic *= (pos.y+.5)/4.;
    float f = length(pos+float2(-.5,.5))*length(pos+float2(.5,.5))*(1.+Caustic)/1.;
    
    return half4(.1,.5,.65,1)*(f);
}
 */

//ATTEMPT AT SUN FLARE

float3 lensflare(float2 uv,float2 pos)
{
    float2 main = uv-pos;
    float2 uvd = uv*(length(uv));
    
    //float ang = atan2(main.x,main.y);
    float dist=length(main);
    dist = pow(dist,.1);
    
    float f0 = 1.0/(length(uv-pos)*16.0+1.0);
    
    f0 = f0; //+ f0*(sin(noise(sin(ang*2.+pos.x)*4.0 - cos(ang*3.+pos.y))*16.)*.1 + dist*.1 + .8);
    
    //float f1 = max(0.01-pow(length(uv+1.2*pos),1.9),.0)*7.0;
    
    float f2 = max(1.0/(1.0+32.0*pow(length(uvd+0.8*pos),2.0)),.0)*00.25;
    float f22 = max(1.0/(1.0+32.0*pow(length(uvd+0.85*pos),2.0)),.0)*00.23;
    float f23 = max(1.0/(1.0+32.0*pow(length(uvd+0.9*pos),2.0)),.0)*00.21;
    
    float2 uvx = mix(uv,uvd,-0.5);
    
    float f4 = max(0.01-pow(length(uvx+0.4*pos),2.4),.0)*6.0;
    float f42 = max(0.01-pow(length(uvx+0.45*pos),2.4),.0)*5.0;
    float f43 = max(0.01-pow(length(uvx+0.5*pos),2.4),.0)*3.0;
    
    uvx = mix(uv,uvd,-.4);
    
    float f5 = max(0.01-pow(length(uvx+0.2*pos),5.5),.0)*2.0;
    float f52 = max(0.01-pow(length(uvx+0.4*pos),5.5),.0)*2.0;
    float f53 = max(0.01-pow(length(uvx+0.6*pos),5.5),.0)*2.0;
    
    uvx = mix(uv,uvd,-0.5);
    
    float f6 = max(0.01-pow(length(uvx-0.3*pos),1.6),.0)*6.0;
    float f62 = max(0.01-pow(length(uvx-0.325*pos),1.6),.0)*3.0;
    float f63 = max(0.01-pow(length(uvx-0.35*pos),1.6),.0)*5.0;
    
    float3 c = float3(.0);
    
    c.r+=f2+f4+f5+f6; c.g+=f22+f42+f52+f62; c.b+=f23+f43+f53+f63;
    c = c*1.3 - float3(length(uvd)*.05);
    c+=float3(f0);
    
    return c;
}

float3 cc(float3 color, float factor, float factor2) // color modifier
{
    float w = color.x+color.y+color.z;
    return mix(color,float3(w)*factor,w*factor2);
}

fragment half4 fragment_shader(VertexOut vertexIn [[ stage_in ]], constant Constants &constants [[ buffer(1) ]]) {
    float2 uv = vertexIn.position.xy / constants.resolution - 0.5;
    uv.x *= constants.resolution.x /constants.resolution.y;
    float t = constants.time;
    
    float3 mouse = float3(0.5, cos(t/20.0)*.5, 0.0);//float3(cos(t/1.0)*.5, cos(t/2.0)*.5, 0.0);
    mouse.x *= constants.resolution.x/constants.resolution.y; //fix aspect ratio
    
    float3 color = float3(0.4,1.2,1.8)*lensflare(uv,mouse.xy);
    color = cc(color,2.5,.01);
    
    return half4(color.r, color.g, color.b, 1.0);
    
}
//*/
 
/*
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
*/

/* A SIMPLE SUN
 
 vec2 p = gl_FragCoord.xy-mouse*resolution;
 float l = 10.0/length(p);
 vec3 sky = vec3(0.1, 0.4, 1.0);
 vec3 sun = vec3(1.9, 1.0, 1.9);
 gl_FragColor = vec4(mix(sky,sun,l), 1.0);
 
*/

/* A COOL BLUE SKY WITH CLOUDS
 #ifdef GL_ES
 precision mediump float;
 #endif
 ///  Compack code for a 1K demo // Harley
 uniform float time;
 uniform vec2 resolution;
 
 mat2 m = mat2( 0.90,  0.110, -0.70,  1.00 );
 
 float ha( float n ) {return fract(sin(n)*758.5453);}
 
 float no( in vec3 x )
 {    vec3 p = floor(x);    vec3 f = fract(x);
 float n = p.x + p.y*57.0 + p.z*800.0;float res = mix(mix(mix( ha(n+  0.0), ha(n+  1.0),f.x), mix( ha(n+ 57.0), ha(n+ 58.0),f.x),f.y),
 mix(mix( ha(n+800.0), ha(n+801.0),f.x), mix( ha(n+857.0), ha(n+858.0),f.x),f.y),f.z);
 return res;}
 
 float fbm( vec3 p )
 {    float f = 0.3*cos(time*0.03);
 f += 0.50000*no( p ); p = p*2.02;    f -= 0.25000*no( p ); p = p*2.03;
 f += 0.12500*no( p ); p = p*2.01;    f += 0.06250*no( p ); p = p*2.04;
 f -= 0.03125*no( p );    return f/0.984375;}
 
 float cloud(vec3 p)
 {    p-=fbm(vec3(p.x,p.y,0.0)*0.27)*2.27;float a =0.0;    a-=fbm(p*3.0)*2.2-1.1;
 if (a<0.0) a=0.0;a=a*a;    return a;}
 
 vec3 f2(vec3 c)
 {    c+=ha(gl_FragCoord.x+gl_FragCoord.y*.9)*0.01;
 c*=0.7-length(gl_FragCoord.xy / resolution.xy -0.5)*0.7;
 float w=length(c);
 c=mix(c*vec3(1.0,1.0,1.6),vec3(w,w,w)*vec3(1.4,1.2,1.0),w*1.1-0.2);
 return c;}
 void main( void ) {
 vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;
 position.y+=0.2;    vec2 coord= vec2((position.x-0.5)/position.y,1.0/(position.y+0.2));
 coord+=time*0.027+1000.;    float q = cloud(vec3(coord*1.0,0.222));
 vec3     col =vec3(0.2,0.4,0.5) + vec3(q*vec3(0.2,0.4,0.1));
 gl_FragColor = vec4( f2(col), 1.0 );}
 
 */

/* WATER COLUMN FROM TOP
 #ifdef GL_ES
 precision mediump float;
 #endif
 //Sergio Sanchón
 uniform float time;
 uniform vec2 resolution;
 
 float CausticPatternFn(vec2 pos)
 {
 float ActualTime = time/1.;
 return (sin(pos.x*40.+time)
 +pow(sin(-pos.x*130.+time),1.)
 +pow(sin(pos.x*30.+ActualTime),2.)
 +pow(sin(pos.x*50.+ActualTime),2.)
 +pow(sin(pos.x*80.+ActualTime),2.)
 +pow(sin(pos.x*90.+ActualTime),2.)
 +pow(sin(pos.x*12.+ActualTime),2.)
 +pow(sin(pos.x*6.+ActualTime),2.))/5.;
 
 }
 
 vec2 CausticDistortDomainFn(vec2 pos)
 {
 float ActualTime = time/100.;
 pos.x*=(pos.y*.20+.5);
 pos.x*=1.+sin(ActualTime/1.)/5.;
 return pos;
 }
 
 void main( void )
 {
 vec2 pos = gl_FragCoord.xy/resolution;
 pos-=.5;
 vec2  CausticDistortedDomain = CausticDistortDomainFn(pos);
 float CausticPattern = CausticPatternFn(CausticDistortedDomain);
 float CausticShape = clamp(7.-length(CausticDistortedDomain.x*20.),0.,1.);
 float Caustic;
 Caustic += CausticShape*CausticPattern;
 Caustic *= (pos.y+.5)/4.;
 float f = length(pos+vec2(-.5,.5))*length(pos+vec2(.5,.5))*(1.+Caustic)/1.;
 
 gl_FragColor = vec4(.1,.5,.65,1)*(f);
 
 }
 */











































