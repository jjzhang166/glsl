#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//some bad lens flare rendering
//by MrOMGWTF
//pls improve this ;_;
//yep, added some gamma correction :)
//Website background mod.

float point(vec2 p, vec2 p2)
{
	return pow(1.0 / (distance(p, p2)) * 0.12, 0.75);	
}

float bokeh(vec2 p, float r, float smoot)
{
	vec2 q = abs(p);
	float d = dot(q, vec2(0.866024,  0.5));
	float s = max(d, q.y) - 5.0*r;
	return smoothstep(smoot, -smoot, s);
}
vec3 adjust(vec3 color) {
	//added a vec3 
	return color*vec3(0.1+sin(time)*0.2,0.2,0.3);
}
void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution.xy - vec2(1.,1.)) * vec2(1.0, resolution.y/resolution.x);
	vec3 color;
	vec2 center = vec2(0.0);
	//put the mouse to work
	vec2 flare = vec2(-0.2 * sin(mouse.x-resolution.x/2.0), 0.1 * sin(mouse.y) +  0.1 * cos(mouse.y-resolution.y/2.0+0.6*sin(time)) * 0.5);//mouse * 2.0 - 1.0;
	vec2 flaredir = normalize(center - flare);
	color = vec3(0.0);
	//sun
	vec3 sun = vec3(0.0);
	sun += pow(vec3(1.0, 0.9, 0.8) * bokeh(p -flare ,0.05, 0.1) * 1.0, vec3(2.0));
	sun += vec3(1.0, 0.86, 0.8) * point(p, flare);
	
	//ghosts
	vec3 ghosts = vec3(0.0);
	ghosts += adjust(vec3(1.0, 0.9, 0.8) * bokeh(p + flare * 0.3,0.05, 0.004)) * 0.4;
	ghosts += adjust(vec3(1.0, 0.8, 0.7) * bokeh(p + flare * - 0.2,0.03, 0.003)) * 0.4;
	ghosts += adjust(vec3(1.0, 1.0, 0.9) * bokeh(p + flare * 0.6,0.06, 0.010)) * 0.2;
	ghosts += adjust(vec3(1.0, 1.0, 0.9) * bokeh(p + flare * 1.5,0.09, 0.015)) * 0.5;
	
	
	ghosts = pow(ghosts, vec3(2.0)) * 1.75;
	
	color = adjust(sun) + ghosts;
	
	gl_FragColor = vec4(sqrt(color), 1.0 );

}