#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;


float check(vec2 p, float x, float y) {
	return texture2D(bb, vec2(p.x+x, p.y+y)/resolution).a;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy );
	
	float c = 0.0;
	
	
	if(mouse.x<0.02&&mouse.y<0.02) {
		if(mod(sin(position.x*cos(position.y)/tan(position.y*position.x+time)), 2.0) > 1.0) {
			c = 1.0;
		}
	} else {
		float i;
		i = check(position,   0.0,  1.0);
		i += check(position,  0.0, -1.0);
		i += check(position,  1.0, -1.0);
		i += check(position,  1.0,  1.0);
		i += check(position,  1.0,  0.0);
		i += check(position, -1.0,  1.0);
		i += check(position, -1.0, -1.0);
		i += check(position, -1.0,  0.0);
		
		if(int(i) == 3)
			c = 1.0;
		else if(int(i) == 2)
			c = check(position, 0.0, 0.0);
		
	}
	
  	
	gl_FragColor = vec4( vec3(0.0, texture2D(bb, position / resolution / 2.0 + mouse / 2.0).a, 0.0) , c );
}