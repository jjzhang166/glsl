//@ME
// rotwang: @mod* experiment with overlapping circles


#define PI 3.1415926535897932384626
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float aa_th = 1.01; //range for antialiasing
const float max_th = 0.99; //threshold
const float smoothMult = 1.0/(aa_th-max_th);

//@rotate from http://glsl.heroku.com/e#3036.0
// triangles with better AA
// by @neoneye

//patterns! :D
// @scratchisthebes
vec2 rotate(vec2 point, float rads) {
	float cs = cos(rads);
	float sn = sin(rads);
	return point * mat2(cs, -sn, sn, cs);
}

float smoothstepVar(float edge1, float edge2, float curve, float value)
{
	float width = edge2 - edge1;
	float phase = (value - edge1) / width;
	phase = clamp(phase,0.0,1.0);
	curve = (curve + 0.025) * 99.075;
	float outValue = pow(phase,curve);
	return outValue;
}

float box(float e0, float e1, float x)
{
    return step(e0, x) - step(e1, x);
}

// return 1.0 when p is within a given trapezium, otherwise return 0.0
float section(  float y0, float y1, float dxdy0, float dxdy1,
                float x0_ofs, float x1_ofs, vec2 p)
{
    float x0 = dxdy0 * p.y + x0_ofs, x1 = dxdy1 * p.y + x1_ofs;
    return box(y0, y1, p.y) * box(x0, x1, p.x);
}

float circle(float x, float y, float radius, float softness) {
	vec2 p = vec2(x, y);
	float r = length( p );
	float a = atan( y, x );
	r *= 1.0 + clamp(1.0-r,0.0,1.0);
	return 1.0-smoothstep( radius, radius + softness, r );
}

float rect(float x, float y, float sizeX, float sizeY, float softness) {
	//hmm, soft rect?
	vec2 p = vec2(x, y);
	float mask = section(-sizeY*.5, sizeY*.5, 0., 0., -sizeX*.5, sizeX*.5, p);
	float r = distance( p, vec2(mask) ) * 3.;
	return 1.0-smoothstep( 0.0, 1.0, r )+mask;
}

float calcMetaBalls(vec2 pos){
    //first metaball with radius 0.3
    float val =  0.3 / distance(pos, vec2(0.0, 0.0));
  
    //second metaball with radius 0.1 at mousePos
    val += 0.1 / distance(pos, mouse.xy/resolution.xy*2.0-1.0);

    return val;
}

//http://paulbourke.net/geometry/supershape3d/
//https://machinesdontcare.wordpress.com/2008/03/12/supershape-2d-glsl-rewrite/
vec2 super2D(float m, float n1, float n2, float n3, float val)
{
	float r;
	float t1, t2;
	float a = 1.0, b = 1.0;
	
	t1 = cos(m * val / 4.0) / a;
	t1 = abs(t1);
	t1 = pow(t1, n2);
	
	t2 = sin(m * val / 4.0) / b;
	t2 = abs(t2);
	t2 = pow(t2, n3);
	
	r = pow(t1 + t2, 1.0 / n1);
	
	r = 1.0 / r;
	vec2 xy = (abs(r) == 0.0) ?	vec2(0.0,0.0) : 
							vec2(r * cos(val),r * sin(val));
 	// Output
 	return xy;  
}

void main( void ) {
	vec2 q = gl_FragCoord.xy / resolution.xy;
	vec2 p = -1.0 + 2.0 * q;
	p.x *= resolution.x/resolution.y;
	float rads = radians(time*10.0);
	p = rotate(p, rads);
	vec3 col = vec3( 0.1, 0.1, 0.1 );
	
	//super2d test
	float phi = atan(p.y,p.x);
	// Distance from center (including offset)
	float r = distance(p, vec2(0.0,0.0) );
	
	/* Create value to send to superShape function */
	// Mix polar-coordinate values phi and r
	float polar = mix(phi,r,1.5);
	// Mix cartesian coordinate X and Y values
	float cartesian = mix(p.x,p.y,1.5);
	// Mix the mixed values
	float polarCartesian = mix(polar,cartesian,1.5);
	
	// Send value to superShape function
	vec2 point = super2D(10.5,0.1,1.5,0.55,polarCartesian);
	
	// Distance between current pixel and superShape result for this pixel
	float dist = distance(p,point);
	// Scale distance
	float distSmooth = smoothstep(1.0,0.0,dist);
	
	
	
	point = super2D(-4.5,100.,-0.5,-10.55,PI);
	dist = distance(p,point);
	distSmooth = smoothstep(1.0,0.0,dist);
	//col = mix( col, vec3(0.0,0.0,0.0), distSmooth );
	
	vec3 white = vec3(1.0);
	float t2 = time-sin(time);
	float ca = circle(p.x+sin(time)*0.75, p.y+cos(time)*0.75, 0.75, 0.05);
	float cb = circle(p.x+sin(t2)*0.75, p.y+cos(t2)*0.75, 0.5, 0.05);
	
	vec3 clr_a = mix( col, vec3(1.0, 0.7, 0.0), ca );
	vec3 clr_b = mix( col, vec3(0.0, 0.5, 1.0), cb );
	vec3 clr = mix(clr_a, clr_b, ca*1.5);
	gl_FragColor = vec4(clr,1.0);

}