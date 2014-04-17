#ifdef GL_ES
precision mediump float;
#endif
// Spider legion
// by Luke H
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float PI = 3.14159265;
	vec2 p = -2.0 + 2.0 * ( gl_FragCoord.xy / resolution.xy );

	vec2 cst = vec2(cos(time/1.5), sin(time));
	mat2 rot = mat2(cst.x, -cst.y, cst.y, cst.x);
	p = rot*p;
	
	vec2 pol = vec2( sqrt(dot(p,p)), atan(p.y, p.x) );
	
	float j = (pol.x * 8.0 * p.x * 1.0 / pol.y*PI);
	float c = pol.y
		* sin(j)
		* sin(120.0*sin(pol.x*2.0+time)/abs(pol.y * PI));
		
	vec3 col = vec3(c/1.5, p.x/3.0, p.x);
	gl_FragColor = vec4(col,1.0);
}