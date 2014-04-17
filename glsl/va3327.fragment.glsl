// look into my eyes...
// @simesgreen

// rotwang: @mod* angular blend
#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution.xy)*2.0-1.0;
	p.x *= resolution.x / resolution.y;

	float unatan = (atan(p.x, p.y) / 3.14329)  ;
	unatan = abs(unatan);
	float r = unatan;
	
	r += time;

	float r2 = length(p);
	r2 = r - r2*6.0;
	r2 = fract(r2);

	float c = r2;

	float range = 0.5* (sin(time)*0.5+0.5)*r2;
	float ma = smoothstep(1.0-range,1.0,1.0-unatan);
	c = mix(c, 0.0, -ma);
	
	
	float mb = smoothstep(0.0,range,unatan);
	c = mix(c, 0.0, mb);
	
	gl_FragColor = vec4( vec3(c, c*0.5, c*0.2), 1 );
}