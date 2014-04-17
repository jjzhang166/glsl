#ifdef GL_ES
precision mediump float;
#endif

// HLSL->GLSL syntax helpers
//
#define float2 vec2
#define float3 vec3
#define float4 vec4

// $ input
//
uniform float mouse;
uniform vec2 resolution;
uniform float time;

// $ constants
//
const vec3 COLOR_0 = vec3(1.21,1.10,0.95);
const vec3 COLOR_1 = vec3(1.17,0.98,0.88);
const float F_DENSITY = 0.65; 
const float S_DENSITY = 0.08;  
const float C_E = 2.7182818284;

// macros
#define WORLD_UNIT 0.1
#define toWorld(x) ((x)*WORLD_UNIT)

// $ function table
//
#define func0(x)	fract(x*x*x*x)
#define func1(x)   	exp(x*x*sqrt(x))
#define func2(x)   	cos(x)
#define func3(x,y)   	sin(x)/cos(y)
#define func4(x,y,z)  	max(x,y)
#define func5(x,y,z)    max(x,x*x)


// $ Remap table
//



float lerp(float a, float b, float i)
{
    return ((a*(1.0-i)) + (b*i));
}

vec3 lerp(vec3 a, vec3 b, float i)
{
    return ((a*(1.0-i)) + (b*i));
}

float pp(float e0, float e1, float x)
{
    return step(e0, x) - step(e1, x);
}

float ff(float dt)
{
    float f = 1.0 - 0.3 * func4(0.0, 0.4, func2(time * dt)) * func4(0.4, 0.5, func2(time * (dt*8.44))) +
		func4(0.1, 0.12, func2(time * (dt*0.4)));
    f = (0.94*(1.0-f)) + f;
    return (f);
}

float ss(float de, float rl, float d)
{
    return func0(((de * func1(1.0 - rl)) * (1.0 / d)) + 1.0) * d;
}

vec3 response(vec3 x)
{
    x=max(vec3(0.0),vec3(x-0.004));
    x=(x*(6.2*x+0.5))/(x*(6.2*x+1.7)+0.06);
    return pow(x,vec3(2.2)); // sRGB
}


float sdSphere(float2 p, float s)
{
    return length(p.xy) - (s);
}

void main( void ) 
{
    const float X_OFFSET = 60.0; // in pixels
    const float Y_OFFSET = 35.0; // in pixels
	
    float aspectRatio = resolution.y / resolution.x;
    
    float2 hC = gl_FragCoord.xy / resolution.xy;
    hC = (hC-vec2(0.5)) * aspectRatio * float2(2.0);
    float v = max(1.0-length(hC.xy),0.5);
	
    float m_Accum0 = 0.0;
    float m_Accum1 = 0.0;
	
    const int NUM = 9;
	
    for (int i = 0; i < NUM; i++)
    {
        float2 uv = resolution * float2(0.5);
        uv.x += -(resolution.x*0.35) + (float(i) * X_OFFSET);
        uv.y  =  (resolution.y*0.50) + (func3(float(i),2.0)*Y_OFFSET);
        float f = ff(uv.x*.0005*func3(float(i+5),15.5));
        
	float2 p0 = toWorld(gl_FragCoord.xy - uv.xy);
	    
        float d = sdSphere(p0,1.0);  
        m_Accum0 += ss(v,d,F_DENSITY);
        m_Accum1 += ss(v,pow(d,.5),S_DENSITY) * f;  
    }

    vec3 vSum0 = m_Accum0 * COLOR_0;
    vec3 vSum1 = m_Accum1 * COLOR_1;
    vec3 vOutC = (vSum0 + vSum1);
    vOutC = func5(vOutC.rgb,response(vOutC.rgb*2.0),0.3);	
    gl_FragColor = float4(vOutC,1.);
}
