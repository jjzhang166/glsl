//ic based on http://glsl.heroku.com/e#3174.0

#ifdef GL_ES
precision lowp float;
#endif
uniform vec2 resolution;
uniform float time;

float rand(vec2 p) {
	return fract(sin(dot(p.xy,vec2(12.9898,78.233)))*43758.5453);
}

vec3 noise(vec2 f) {
	return vec3(rand(f-1.), rand(f), rand(f+1.));
}

void main( void ) {
	vec2 u = ( gl_FragCoord.xy / resolution.xy );
	float w,x,y,z=0.0;
	vec2 n;
	u+=vec2(20.,11.0);
	y=fract(u.x*u.x*u.y*u.y*90.0);
	n=vec2(y, u.x);
	vec2 pos = gl_FragCoord.xy;
	vec3 color = vec3(0.3) * n.x;
	
	//brick size
	vec2 brick = vec2(150.0,50);
	
			
	//move horintally
	pos.x += fract(time*.1)*brick.x;
	
	//brick rows
	float row = floor(pos.y/brick.y);
	
	if (mod(row, 2.0) < 1.0)
		pos.x += brick.x/2. + x;
	
	//line width
	float border = 1.0;
	
	if (mod(pos.x+border/2.0, brick.x) <= border ||	//horiz lines
	    mod(pos.y+border/2.0, brick.y) <= border)	//vert lines
		color = vec3(0.5)+y;
		
	gl_FragColor = vec4(color, 1.0);
}