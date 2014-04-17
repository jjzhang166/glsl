#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 pos= ( gl_FragCoord.xy / resolution.xy );
	float col=.2;
	float sum = floor(pos.x*10.0) + floor(pos.y*10.0);
	if(mod(sum,2.0)==ceil(sin(time*10.0))){
		col=1.0;
	}
	
	gl_FragColor = vec4( col,col,col,.0 );
}