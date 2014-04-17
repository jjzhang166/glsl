// mkC is trying to learn raytracers! Don't hate!

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 sphere = vec4(.5, .5, 1.5, .42);
float dist = .13;

float getDist(vec3 p1, vec3 p2) {
	return length(p2-p1) - sphere[3];//abs(sqrt( pow(p1[0]-p2[0], 2.) + pow(p1[1]-p2[1], 2.) + pow(p1[2]-p2[2], 2.)) ) ;
		}

vec3 trace(vec2 p) {
	for(int i = 0; i < 100; i++) {
		float dd = getDist(vec3(p, float(i)), vec3(sphere));
		float dd2 = getDist(vec3(p, float(i)), vec3(mouse.xy, float(i)));
		if (dd < dist) return vec3(1.- pow(dd*5.1, 1.3)- min(dd2, .1),1.-pow(dd*7.0, 0.5) - dd2,1.- pow(dd*7.0, 2.))- min(dd2, .2);
	  }
	return vec3(min(1.*pow(p.y, 2.), .2),min( .1,.05+.05*p.y),0.05);
}

vec3 getColor(vec2 pos) {
	float r = 0.;
	float g = 0.;
	float b = 0.;
	
	
	return vec3(r, g, b);
}



void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position.y /= resolution.x / resolution.y;
	position.y += 0.15;

	vec3 cc = vec3(0.,0.,0.);
	cc = trace(position);
	cc = cc-.2*(length(vec2(.5,.5)-mouse.xy))*(1.- smoothstep(length(vec2(.5,.5)-position),.8, .6));
	gl_FragColor = vec4( cc, 1.0 );

}