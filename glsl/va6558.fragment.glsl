#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

// I just like the clouds - kanatacrude

// http://stackoverflow.com/questions/4200224/random-noise-functions-for-glsl
float random(float a,float b) {
    return fract(sin(dot(vec2(a,b) ,vec2(12.9898,78.233))) * 43758.5453);
}
// http://www.iquilezles.org/www/articles/morenoise/morenoise.htm
vec3 dnoise2f(vec2 p) {
    float i = floor(p.x), j = floor(p.y);
    float u = p.x-i, v = p.y-j;
    
    float du = 30.*u*u*(u*(u-2.)+1.);
    float dv = 30.*v*v*(v*(v-2.)+1.);
    
    u=u*u*u*(u*(u*6.-15.)+10.);
    v=v*v*v*(v*(v*6.-15.)+10.);
    
    float a = random( i, j );
    float b = random( i+1., j);
    float c = random( i, j+1.);
    float d = random( i+1., j+1.);
    
    float k0 = a;
    float k1 = b-a;
    float k2 = c-a;
    float k3 = a-b-c+d;
    
    return vec3(
        k0 + k1*u + k2*v + k3*u*v,
        du * (k1 + k3*v),
        dv * (k2 + k3*u)
    );
}

// http://paris.cs.wayne.edu/~ay2703/research/publications/getPDF2INMIC2005.pdf
vec3 sky(vec2 p) {
  const float density = .4;
  const float sharpness = .4;
  const vec3 SkyColor = vec3( 0., 0., 1.);
  const vec3 CloudColor = vec3(1., 1., 1.);
    
  float intensity = clamp( (dnoise2f(p*8.)[0]*.5+dnoise2f(p*16.)[0]*.25+dnoise2f(p*32.)[0]*.125+dnoise2f(p*64.)[0]*.0625)*2. - density, 0., 1.);
  intensity = pow(sharpness, intensity);
  intensity = 1. - (intensity*1.);
    
  return mix(SkyColor, CloudColor, intensity);
}

void main( void ) {

    vec2 uv = ( gl_FragCoord.xy / resolution.xy ) + vec2(0.0,0.45) ;
    
    float y = (uv.y - .4)/.05;
    float z = 1./y;

    const float sky_scale = 10.;
    vec2 pos = uv * sky_scale;
    pos.y *= z;
    pos.x = (pos.x - sky_scale/2.) *z;
    
    pos.y += time/100.;
    
    gl_FragColor = vec4(sky(pos), 1.);
}