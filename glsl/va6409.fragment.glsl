#ifdef GL_ES
precision mediump float;
#endif
 
uniform vec2 mouse;
uniform vec2 resolution;
 
float point(vec2 p, vec2 p2)
{
	return pow(1.0 / (distance(p, p2)) * 0.02, 0.75);	
}

float bokeh(vec2 p, float r, float smoot)
{
	vec2 q = abs(p);
	float d = dot(q, vec2(0.866024,  0.5));
	float s = max(d, q.y) - r;
	return smoothstep(smoot, -smoot, s*0.1);
}
vec3 adjust(vec3 color) {
	return color*color;
}
void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution.xy - vec2(0.5,0.5)) * vec2(1.0, resolution.y/resolution.x);
	vec3 color;
	vec2 center = vec2(0.0);
	vec2 flare = mouse * 2.0 - 1.0;
	vec2 flaredir = normalize(center - flare);
	color = vec3(0.0); 
	vec3 sun = vec3(0.0);
	sun += pow(vec3(1.0, 0.9, 0.8) * bokeh(p -flare ,0.05, 0.1) * 1.0, vec3(3.0));
	sun += vec3(1.0, 0.86, 0.8) * point(p, flare);
	 
	vec3 ghosts = vec3(0.0);
	ghosts += adjust(vec3(1.0, 0.9, 0.7) * bokeh(p + flare * - 0.7,0.02, 0.003)) * 0.3;
	ghosts += adjust(vec3(1.0, 0.9, 0.7) * bokeh(p + flare * - 0.2,0.04, 0.004)) * 0.2; 
	ghosts += adjust(vec3(1.0, 0.9, 0.7) * bokeh(p + flare * 0.4,0.05, 0.005)) * 0.2;
	ghosts += adjust(vec3(1.0, 0.9, 0.7) * bokeh(p + flare * 1.0,0.08, 0.006)) * 0.2;
	ghosts += adjust(vec3(1.0, 0.9, 0.7) * bokeh(p + flare * 1.5,0.09, 0.007)) * 0.1;
	
	
	ghosts = pow(ghosts, vec3(2.0)) * 1.75;
	float horizont = distance(gl_FragCoord.y,resolution.y) * 0.003 ;
	color = adjust(sun) + ghosts;
	float down = pow(mouse.y,2.0);
	gl_FragColor = vec4(sqrt(color), 1.0 ) + vec4(0.6 - down,0.15,down,0) + vec4(0.9,pow(mouse.y,0.1),0.5,0) * pow(horizont,8.0);
}