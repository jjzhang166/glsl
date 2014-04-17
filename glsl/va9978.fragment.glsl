#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 vpos = (gl_FragCoord.xy / resolution.xy );
	vec2 apos = gl_FragCoord.xy;
	
	vec3 background = vec3(27.0/255.0, 165.0/255.0, 224.0/255.0) * .5;

	float col = floor(apos.x/10.0);
	float row = floor(apos.y/10.0);
	
	float gridv = clamp(mod(apos.x+7.0,10.0)-4.0, 0.0, 1.0)
		+ clamp(mod(apos.y+7.0,10.0)-4.0, 0.0, 1.0);
	float grid = gridv * mod(col+row,2.0);
	vec3 gridColor = vec3(.10*grid);
	
	vec2 center = resolution*0.5;
	float ang = atan(apos.y-center.y, apos.x-center.x) + time*.2;
	float cspines = 6.28/8.0;
	float cspec = abs(mod(ang, cspines)-cspines*.5);
	vec4 color = vec4(background, clamp(cspec*6.0, 0.0, 1.0));
		
	vec4 bgc = vec4(mix(gridColor, background, 1.0-(1.0-vpos.y)*.5), 1.0); //vec4(grid, grid, grid+b, grid);	
	
	vec4 bgc2 = vec4(mix(bgc.xyz, color.xyz, color.a*2.0), 1.0);
	
	gl_FragColor = bgc2;
}