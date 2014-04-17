#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	vec2 c = mouse ;

	gl_FragColor = vec4(c.x,c.y,1.0-c.x,0);
        
}