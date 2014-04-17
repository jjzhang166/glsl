#ifdef GL_ES
precision lowp float;
#endif
uniform vec2 resolution;

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
	
	//tile size in pixels
	float tile = 50.0;
	
	//brick
	float col = floor(pos.x/tile);
	if (mod(col, 2.0) < 1.0)
		pos.y += tile/2.0 + y;
	
	//line width
	float pixel = 1.0;
	
	//horiz lines
	if (mod(pos.x+pixel/2.0, 50.0) <= pixel)
		color = vec3(0.5)+y;
	
	//vert lines
	if (mod(pos.y+pixel/2.0, tile) <= pixel)
		color = vec3(0.5)+y;
	
	gl_FragColor = vec4(color, 1.0);
}