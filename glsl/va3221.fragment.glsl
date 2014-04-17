// Some hills...
// rotwang: @mod* lowered cam for better flight feeling
// @mod+ mouse y controls flight height
// @mod* some color tests
// @mod+ Canyon
// @emackey: Simple sky blue (no clouds...)
// @rotwang: mod* sky gradient, different terrain front and backcolor
// @mod* stripes texture
// @mod* terrain variation
// @psonice flyover adjusted so height depends on terrain. WOuld be better with spline interpolation, if you have the time go do it :)
// rotwang: @mod+ UFO
// @mod* source cleanup
// @mod+ fog, vignette
// @CBS: +Stars
// @CBS: + Water

#ifdef GL_ES
precision highp float;
#endif


uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

vec3 viewDir;
const float ID_TERRAIN = 1.0;
const float ID_UFO = 2.0;
const float ID_WATER = 3.0;

//Simple raymarching sandbox with camera

//Raymarching Distance Fields
//About http://www.iquilezles.org/www/articles/raymarchingdf/raymarchingdf.htm
//Also known as Sphere Tracing
//Original seen here: http://twitter.com/#!/paulofalcao/statuses/134807547860353024

//Util Start

mat2 m = mat2( 0.80,  0.60, -0.60,  0.80 );

float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
    return res;
}

float fbm_5oct( vec2 p )
{
    float f = 0.0;
    f += 0.50000*noise( p ); p = m*p*2.02;
    f += 0.25000*noise( p ); p = m*p*2.03;
    f += 0.12500*noise( p ); p = m*p*2.01;
    f += 0.06250*noise( p ); p = m*p*2.04;
    f += 0.03125*noise( p );
    return f/0.984375;
}

float fbm_3oct( vec2 p )
{
    float f = 0.0;
    f += 0.50000*noise( p ); p = m*p*2.02;
    f += 0.25000*noise( p ); p = m*p*2.03;
    f += 0.12500*noise( p ); p = m*p*2.01;
    
    return f/0.875;
}

vec2 ObjUnion(in vec2 obj_floor,in vec2 obj_roundBox){
    if (obj_floor.x<obj_roundBox.x)
        return obj_floor;
    else
        return obj_roundBox;
}

float rand(float x) {
	float res = 0.0;
	
	for (int i = 0; i < 5; i++) {
		res += 0.244 * float(i) * sin(x * 0.68171 * float(i));
		
	}
	return res;
	
}
float waternoise( vec2 p )
{
    float f = 0.0;
    f += 0.50000*noise( p ); p = m*p*2.02;
    f += 0.25000*noise( p ); p = m*p*2.03;
    f += 0.12500*noise( p ); p = m*p*2.01;
    f += 0.06250*noise( p ); p = m*p*2.04;
    f += 0.03125*noise( p );
    return f/0.85;
}
//Util End
//IQs RoundBox (try other objects http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm)
vec2 obj_roundBox(in vec3 p){
    return vec2(length(max(abs(p)-vec3(1,1,1),0.0))-0.25,1);
}

vec2 obj_sphere(in vec3 p){
    return vec2(length(p)-2.0);
}

//RoundBox with simple solid color
vec3 obj_roundBox_c(in vec3 p){
	return vec3(1.0,0.5,0.2);
}

//Scene Start

float  sphere(in vec3 p, in float radius)
{
    return length(p)-radius;
}

vec2 ufo(in vec3 p)
{
	vec2 vd;
	vd.y = ID_UFO;
	
    // position
	p -=viewDir;
	p.z -= 10.0 + sin(time*0.25)*5.0;
	p.x += sin(time/4.0)*10.0;
    
    vec3 q = p;
    q.y *= 7.0; // squeezed

	vd.x = length(q)-3.0;
    
    vd.x = min(vd.x, sphere(p,1.0));
	return vd;
}


vec2 terrain(in vec3 p){
	
    
	float da = sin(0.9*p.y)*fbm_3oct(p.xz);
  	vec2 vd = vec2(p.y+fbm_3oct(p.xz / 9.0) * 9.33 ,0);
	vd.x += da;
 	vd.y = ID_TERRAIN;
	return vd;
}

vec2 water(in vec3 p){
	
    	float da = p.y;
  	vec2 vd = vec2(p.y+11.0)+waternoise(p.xz*0.2+(time*0.25));
	vd.x += da;
 	vd.y = ID_WATER;
	return vd;
}


vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

/**
 @rotwang:
 smoothes between 2 vectors a and b (eg colors)
 using a source value and a smooth amount
 about the base as center.
 */
vec3 smoothmix(vec3 a, vec3 b, float base, float smooth, float source)
{
	float f = smoothstep(base-smooth, base+smooth, source );
	vec3 vec = mix(a, b, f);
	return vec;
}


//Terrain Color
vec3 terrain_clr(in vec3 p){
	
	
	vec3 clr_a = vec3(0.4, 0.5, 0.2);
	vec3 clr_b = vec3(0.3, 0.3, 0.3);
	float m = fract(p.y*4.0);
	float g = fbm_3oct(p.xz * 28.0);
	clr_b += g;
	vec3 clr =  smoothmix(clr_a, clr_b,0.76, 0.3, m );
	clr = mix( clr, g*clr, 0.6);
    
	
 	return clr;
}


/**
 distance is coded in x
 objectcode in y
 */
vec2 mindist( const in vec2 a, const in vec2 b )
{
	if(a.x < b.x)
		return a;
	else
		return b;
}


vec2 scene(in vec3 p){
    
    vec2 hit = mindist( mindist(terrain(p),water(p)), ufo(p) );
   	//hit -= water(p);
	return hit;
}

//Scene End

void main(void){
    //Camera animation
    float aspect = resolution.x/resolution.y;
    vec3 U=vec3(0,1,0);//Camera Up Vector
    
	float speed = time*2.0;
	float my =  sin(time/8.0); // mouse.y*4.0;
	float camy = -1.0+my;
	float tary = -0.5+my;
    vec3 E=vec3(0., camy, speed);
	E.y += .2;
    viewDir=vec3(0.0,tary,E.z+1.0);
	
    //Camera setup
    vec3 C=normalize(viewDir-E);
    vec3 A=cross(C, U);
    vec3 B=cross(A, C);
    vec3 M=(E+C);
    
    vec2 vPos=2.0*gl_FragCoord.xy/resolution.xy - 1.0; // (2*Sx-1) where Sx = x in screen space (between 0 and 1)
    vec3 scrCoord=M + vPos.x*A*aspect + vPos.y*B; //normalize resolution in either x or y direction (ie resolution.x/resolution.y)
    vec3 scp=normalize(scrCoord-E);
    // scp.z += 1.;
    scp.y -=0.25;
    E.y -= (terrain(E).x + terrain(E + vec3(0., 0., 0.1)).x + terrain(E + vec3(0., 0., -0.1)).x) / 3.;
	E.y += 2.;
    //Raymarching
    const vec3 e=vec3(0.1,0,0);
    const float MAX_DEPTH=60.0; //Max depth0.
    
    vec2 s=vec2(0.1,0.0);
    vec3 p,n;
    vec3 clr;
    
    float f=1.0;
    for(int i=0;i<100;i++){
        if (abs(s.x)<.01||f>MAX_DEPTH) break;
        f+=s.x;
        p=E+scp*f;
        s=scene(p);
    }
    
    if (f<MAX_DEPTH){
        
        n=normalize(
                    vec3(s.x-scene(p-e.xyy).x,
                         s.x-scene(p-e.yxy).x,
                         s.x-scene(p-e.yyx).x));
        float b=dot(n,normalize(E-p));
        
        if (s.y==ID_TERRAIN)
        {
            clr=terrain_clr(p);
            vec3 cc = vec3(0.7, clr.g, clr.b);
            float m = smoothstep(3.0, 20.0, f);
            clr = mix(clr,cc, 1.0*p.y+5.0);
            clr=vec3(b*clr*(2.0-f*.01));//simple phong LightPosition=CameraPosition
         }
	else if(s.y == ID_WATER)
        {
            clr = vec3(0.1,0.4,0.8); 
            clr -= vec3(b*clr+pow(b,2.9));
        }
        else if(s.y == ID_UFO)
        {
            clr = vec3(0.5,0.4,0.6); 
            clr=vec3(b*clr+pow(b,8.0));
        }
        
    }
	else { //background color
		float invy = 1.0-vPos.y;
		float r = invy*0.8;
		float g = 0.2 + invy*0.7;
		clr = vec3(r,g,0.9);
		
		//Draw some stars
		//http://glsl.heroku.com/e#2927.2

		vec2 star = vec2(gl_FragCoord);
		if (rand(star.y * star.x) >= 2.1 && rand(star.y + star.x) >= .7 ) {
			float lm = length(clr);
		 	clr += lm/0.0;
		}
		 
	}
 
// fog
	
   float d = f*0.05;
   float ff = exp(-d*d);

    // ambient vignetting
	vec3 ambient = vec3(0.1, 0.3, 0.4);
float dp = dot(vPos, vPos);
	ambient *= 0.5+0.5*smoothstep(1.0, 0.0, dp);
	
    clr *= 0.5+0.5*smoothstep(0.5, 0.25, dp);


	
    gl_FragColor=vec4(mix(ambient, clr, ff), 1.0);
    
	//gl_FragColor = vec4(clr, 1.0);
}
