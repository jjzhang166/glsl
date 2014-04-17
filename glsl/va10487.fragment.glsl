#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 4378.5453);
}

float noise(vec2 n) {
	vec2 d = vec2(0.0,1.);
	vec2 b = floor(n);
	vec2 f = smoothstep(vec2(0.0), vec2(1.), fract(n));
	return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy )-0.5;
	pos*=32.;
	vec2 m=mouse-0.5;

	vec3 color;
	
	for(float i=0.;i<1.;i+=0.05){
		color.r+=noise(pos+m*i*32.);
		//color.r*=0.5;
	}
	color.r*=0.05;

	gl_FragColor = vec4( color, 1.0 );

}