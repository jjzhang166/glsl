#ifdef GL_ES
precision highp float;
#endif

// @danbri trying to transcribe from 
// http://imagine.cc/2011/07/18/a-formulanimation-class-with-inigo-quilez/
// but not there yet.

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3  paintPixel(vec2 p) {
   float r = length(p);
   float d = 0.5;
   float f = (r<d) ? 0.0:1.0;
   vec3 col =  vec3(f * cos(3. * time  / (p.y - p.x)) ,f*p.x,f-p.y) ;
   return col;
}


void main( void ) {
//	vec2 p = .8 * ( gl_FragCoord.xy / resolution.xy ) ;//+ mouse / 4.0;
	vec2 p = gl_FragCoord.xy / (resolution.xy/.7);
	gl_FragColor = vec4( vec3( paintPixel(p) ), 1.0 );
}

