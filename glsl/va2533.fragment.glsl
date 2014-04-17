#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define WATER 0.0
#define TERRAIN 1.0


float WATER_HEIGHT = 0.2 + sin(-time * 0.005) * 0.05;

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


float terrain(vec2 p) {
    float f = 0.0;
    float w = 0.25 + abs(sin(time * 0.05)) * 0.25;
    float dx = 0.0;
    float dz = 0.0;
    for( int i=0; i < 8; i++ )
    {
        vec3 n = dnoise2f(p);
        dx += n[1];
        dz += n[2];
        f += w * n[0] / (1.0 + dx*dx + dz*dz); // replace with "w * n[0]" for a classic fbm()
    w *= 0.5;
    p *= 2.;
    }
    return f;
}

vec2 march_step(vec3 p){
    float height = terrain(p.xz);

    if (height<WATER_HEIGHT) return vec2((p.y-WATER_HEIGHT)/3., WATER);
    
    return vec2((p.y-height)/5., TERRAIN);
}
// ray_march taken from http://glsl.heroku.com/e#1247.0
vec2 ray_march(vec3 eye, vec3 ray, float eps, float min_depth, float max_depth, out vec3 p, out float f, out int steps){
    vec2 o = vec2(eps+.1, -1);
    f = min_depth;
 
    steps =0 ;
	
    for(int i=0;i<128;i++){
        if(abs(o.x)<eps){
            break;
        }
        if(f > max_depth){
            o.y = -1.0;
            break;
        }
        f += o.x;
        p = eye + f*ray;
        o = march_step(p); 
	steps++;
    }
    return o;
}

vec3 texture(vec2 p, float density, float sharpness, float range, float chunkiness, int detail, vec3 col1, vec3 col2) {

    float intensity = 0.;
    float part = .5;
    for (int i=0;i<5;i++) {
        intensity += dnoise2f(p*chunkiness)[0]*part;
        chunkiness *= 2.;
        part /= 2.;
        if (i==detail) break;
    }
    intensity = clamp(intensity*range - density, 0., 1.);
    intensity = pow(sharpness, intensity);
    intensity = 1. - (intensity*1.);
    
    return mix(col1, col2, intensity);
}
// http://paris.cs.wayne.edu/~ay2703/research/publications/getPDF2INMIC2005.pdf
vec3 sky(vec2 p) {
  const float density = 0.5;
  const float sharpness = .3;
  const vec3 SkyColor = vec3( 0.6, 0.8, 1.0);
  const vec3 CloudColor = vec3(0.9);
    
  float intensity = clamp( (dnoise2f(p*8.)[0]*.5+dnoise2f(p*16.)[0]*.25+dnoise2f(p*32.)[0]*.125+dnoise2f(p*64.)[0]*.0625)*2. - density, 0., 1.);
  intensity = pow(sharpness, intensity);
  intensity = 1. - (intensity*1.);
    
  return mix(SkyColor, CloudColor, intensity);
}
vec3 rock(vec2 p) {
    //return texture(p, .0, .3, 1., 8., 5, vec3( .3, .3, .3), vec3(1., 1., 1.));
  const float density = .1;
  const float sharpness = .35;
  const vec3 SkyColor = vec3(0.08, 0.04, 0.01);
  const vec3 CloudColor = vec3(0.9);
    
  float intensity = clamp( (dnoise2f(p*8.)[0]*.5+dnoise2f(p*16.)[0]*.25+dnoise2f(p*32.)[0]*.125+dnoise2f(p*64.)[0]*.0625)*1. - density, 0., 1.);
  intensity = pow(sharpness, intensity);
  intensity = 1. - (intensity*1.);
    
  return mix(SkyColor, CloudColor, intensity);
}
vec3 grass(vec2 p) {
    //return texture(p, .4, .2, 2., 32., 2, vec3(.3,.7,.3), vec3(.6,.9,.5) );
  const float density = .6;
  const float sharpness = .3;
  const vec3 SkyColor = vec3( .1, .3, .3);
  const vec3 CloudColor = vec3(.4, .7, .3);
    
  float intensity = clamp( (dnoise2f(p*32.)[0]*.5+dnoise2f(p*64.)[0]*.25+dnoise2f(p*128.)[0]*.125)*2. - density, 0., 1.);
  intensity = pow(sharpness, intensity);
  intensity = 1. - (intensity*1.);
    
  return mix(SkyColor, CloudColor, intensity);
}
vec3 snow(vec2 p) {
    //return texture(p, .5, .2, 1., 16., 2, vec3( .8, .8, .8), vec3(1., 1., 1.));
  const float density = .1;
  const float sharpness = .2;
  const vec3 SkyColor = vec3( .4);
  const vec3 CloudColor = vec3(0.9, 1., 1.);
    
  float intensity = clamp( (dnoise2f(p*16.)[0]*.5+dnoise2f(p*32.)[0]*.25+dnoise2f(p*64.)[0]*.125)*1. - density, 0., 1.);
  intensity = pow(sharpness, intensity);
  intensity = 1. - (intensity*1.);
    
  return mix(SkyColor, CloudColor, intensity);
}
vec3 terrainColor( const vec3 ro, const vec3 rd, float t, float height, float mat )
{
     vec3 p = ro + rd * t;
 
    if (mat==TERRAIN) {
        if (height<.5) return mix(grass(p.xz), rock(p.xz), clamp((height-.2)*16.,0.,1.));
        return mix(rock(p.xz),snow(p.xz), (height-.5)*10.);
    }
    //if (mat==WATER) {
        // water. more or less.
        return mix(vec3(.1,.3,.5), sky(p.xz), 0.33 + sin(p.z) * cos(p.x) * cos(time * 0.25) * sin(time * 0.75) * 0.5);
    //}
/*
    const vec3 n = getNormal( p );
    const vec3 s = getShading( p, n );
    const vec3 m = getMaterial( p, n );
    return applyFog( m * s, t );
*/
}

void main( void ) {

    

    vec2 uv = ( gl_FragCoord.xy / resolution.xy ) + (mouse-.5)/2.9 ;
    vec3 ro = vec3( 0., 0.85 + sin(time * 0.5) * 0.15,  -time * clamp(0.01 * time, 0.0, 3.0));
    vec3 rd = normalize( vec3( -1.0 + 2.0*vec2(uv.x - .2, uv.y)* vec2(resolution.x/resolution.y, 1.0), -1.0 ) );


    //gl_FragColor =vec4( texture(uv, .0, .3, 1., 8., 4, vec3( .3, .3, .3), vec3(1., 1., 1.)), 1.);
    //gl_FragColor = vec4(snow(uv), 1.);
    //return; 
    
    float min_depth = 0.0;
    float max_depth = 10.;  
    int max_steps = 64;
    float eps = 0.005;
    float t = min_depth;
    
    vec3 p = vec3(0,0,0);

    int steps;
	
    vec2 o = ray_march(ro, rd, eps, min_depth, max_depth, p, t, steps);    
  		    
    if (o.y != -1. && t<max_depth) {
        gl_FragColor = vec4(terrainColor(ro, rd, t, p.y-o.x, o.y), 1.);
        return;
    }
    
    float y = (uv.y - .4)/.05;
    float z = 1./y;

    if (y<0.) {
        gl_FragColor = vec4(0.7,0.7,0.7,1);
        return;
    }

    const float sky_scale = 10.;
    vec2 pos = uv * sky_scale;
    pos.y *= z;
    pos.x = (pos.x - sky_scale/2.) *z;
    
    pos.x += time * 0.05;
    
    gl_FragColor = vec4(sky(pos), 1.);
}