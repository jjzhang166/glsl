// rotwang: mod*, smoothing, half-circle-fill
// dist: angled-half-circle v3
// dist: glsl.heroku.com messed up the mouse position.. (compare this with http://glsl.heroku.com/e#3927.3 )
// dist: ^ ok nwm, it just fscks it up after reloading anyways.

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 pos = mod(gl_FragCoord.xy, vec2(50.0, 50.0)) - vec2(25.0, 25.0);
	vec2 center = floor(gl_FragCoord.xy/vec2(50.0,50.0))*vec2(50.0,50.0)+vec2(25.0,25.0);
	vec2 dir = (center.xy/resolution.xy-mouse.xy);
	float dist_squared = dot(pos, pos);
	float angle = atan(dir.y,dir.x)-3.1415*0.5;
	pos *= mat2(cos(angle),sin(angle),-sin(angle),cos(angle));
	float d = smoothstep(400.0, 500.0, dist_squared);
	float k = step(pos.y,.5);
	vec3 clr = mix( vec3(k), vec3(0.5), d);
	gl_FragColor =  vec4(clr, 1.0);

	vec2 p = gl_FragCoord.xy / resolution.xy;
	vec2 o = abs(p-mouse);
	vec3 color = clamp(vec3(1.0-min(o.x,o.y)*400.0),0.0,1.0);
	gl_FragColor += vec4(color , 1.0 );

}
