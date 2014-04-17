#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 uv = (gl_FragCoord.xy / resolution.xy);
	vec2 pos = vec2( uv.x - mouse.x, uv.y - mouse.y );
	
	float intensity = 1.0 - ((1.0 / abs(sin( 5.0))) * sqrt(pos.x * pos.x + pos.y * pos.y)) / 1.5;
	
	vec2 p = gl_FragCoord.xy / resolution.x * 30.0;

	p = vec2( mod(p.x, 2.0), 1 );
	if(p.x < 1.0){
	  gl_FragColor = vec4(225.0/255.0 , 230.0/255.0 , 234.0/255.0 , 1.0)*intensity;
	}else{
	  gl_FragColor = vec4(167.0/255.0 , 190.0/255.0 , 206.0/255.0 , 1.0)*intensity;
	}

}