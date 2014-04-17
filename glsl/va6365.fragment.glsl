#ifdef GL_ES
precision mediump float;
#endif

// kaleidoscope effect stolen from @paulofalcao ( http://glsl.heroku.com/e#5170.0 )
// Posted by Trisomie21 : 2D noise experiment (pan/zoom)
// failed attempt at faking caustics

uniform float time;
uniform vec2 resolution;
varying vec2 surfacePosition;


#define PI 3.14159265

float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t){
   float xx=x+tan(t*fx)*sx;
   float yy=y-tan(t*fy)*sy;
   return 0.8/sqrt(abs(x*xx+yy*yy));
}

vec3 sim(vec3 p,float s){
   vec3 ret=p;
   ret=p+s/2.0;
   ret=fract(ret/s)*s-s/2.0;
   return ret;
}

vec2 rot(vec2 p,float r){
   vec2 ret;
   ret.x=p.x*cos(r)-p.y*sin(r);
   ret.y=p.x*sin(r)+p.y*cos(r);
   return ret;
}

vec2 rotsim(vec2 p,float s){
   vec2 ret=p;
   ret=rot(p,-PI/(s*2.0));
   ret=rot(p,floor(atan(ret.x,ret.y)/PI*s)*(PI/s));
   return ret;
}
vec2 makeSymmetry(vec2 p){ //nice stuff :)
   vec2 ret=p;
   ret=rotsim(ret,6.0);
   ret.x=abs(ret.x);
   return ret;
}



vec4 textureRND2D(vec2 uv){
	uv = floor(fract(uv)*1e3);
	float v = uv.x+uv.y*1e3;
	return fract(1e5*sin(vec4(v*1e-2, (v+1.)*1e-2, (v+1e3)*1e-2, (v+1e3+1.)*1e-2)));
}

float noise(vec2 p) {
	vec2 f = fract(p*1e3);
	vec4 r = textureRND2D(p);
	f = f*f*(3.0-2.0*f);
	return (mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y));	
}

float color(vec2 p) {
	float v = 0.0;
	v += 1.-abs(pow(abs(noise(p)-0.5),0.75))*1.1;
	return v;
}

void main( void )
{
	vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);
	p=0.03*makeSymmetry(p); 
	p.y += 0.0125*time;
	
	//vec2 p = surfacePosition*.05+.5;
	float c1 = color(p*.3+time*.000175);
	float c2 = color(p*.3-time*.000135);
	
	float c3 = color(p*.2-time*.000185);
	float c4 = color(p*.2+time*.000155);
	
	float cf = pow( c1*c2*c3*c4+0.6, 4.0 );
	
	vec3 c = vec3(cf);
	gl_FragColor = vec4((c+0.1)*vec3(0.1,0.2,0.5), 1.);
	gl_FragColor.rgb += textureRND2D( 0.001 * gl_FragCoord.xy +fract(time) ).rgb / 16.0;
}

