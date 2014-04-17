#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159265
vec3 sim(vec3 p,float s); //.h
vec2 rot(vec2 p,float r);
vec2 rotsim(vec2 p,float s);

vec2 makeSymmetry(vec2 p, float n){ //nice stuff :)
   vec2 ret=p;
   ret = rotsim(ret, n/2.);
   ret.x=abs(ret.x);
   return ret;
}
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

float oscillator(float mag, float n, float exp) {
	return (sin(mag/n * (1.0)) + 1.0) / exp;
}

// modes
int mode = 7;

void main( void ) {
	float color = 0.0;
	float exp   = mouse.x * 10.;
	
	vec2 var = gl_FragCoord.xy;
	vec2 varC = gl_FragCoord.xy - resolution.xy / 2.0;

	
	// concentric circles
	if (mode == 0) {
		float mag = sqrt(varC.x * varC.x + varC.y * varC.y);		
		color = oscillator(mag, 5.0, exp);
	} 
	// vert lines
	else if(mode == 1) {
		float mag = sqrt(var.x * var.x);		
		color = oscillator(mag, 5.0, exp);
	}
	// horiz lines
	else if (mode == 2) {
		float mag = sqrt(var.y * var.y);
		color = oscillator(mag, 5.0, exp);
	}
	// symmetry
	else if (mode == 3) {
		var = makeSymmetry(varC, 7.);
		float mag = sqrt(var.y * var.y);
		color = oscillator(mag, 20.0, exp);
	}
	// symmetry2
	else if (mode == 4) {
		var = makeSymmetry(varC, 7.);
		float mag = sqrt(var.y*var.y);
		color = (sin(mag/5.0+time*(10.0))+1.0)/2.0;
	}
	// symmetry3
	else if (mode == 5) {
		float n = 7.;
		var = makeSymmetry(varC, n);
		float mag = sqrt(var.y * var.x);
		float size = 20.0;
		color = (sin(mag/size + time * (2.0)) + 1.0) / 2.0;
	}	
	// symmetry3 (isosceles triangle)
	else if (mode == 6) {
		float n = mouse.x * 5.;
		var = makeSymmetry(varC, n);
		float mag = sqrt(var.y * var.y);
		float size = 16.0;
		color = (sin(mag/size + time * (2.0)) + 1.0) / (mouse.y*10.);
	}	
	// symmetry4 
	else if (mode ==7) {
		
		vec2 ret = varC;
	   	ret = rot(ret, 7. * mouse.y);
	   	ret.x = abs(ret.x);

	        ret = rot(ret, 7. * mouse.x);
	   	ret.x = abs(ret.x);

		ret = rot(ret, 7. * mouse.y);
	   	ret.x = abs(ret.x);
	
		var = ret;
	   	float mag = sqrt(var.x * var.x);
	   	float size = 16.0;
	   	color = (sin(mag/size + time * (2.0)) + 1.0) / (mouse.y*10.);
	}
	
	gl_FragColor = vec4(color, color, color, 1);
}