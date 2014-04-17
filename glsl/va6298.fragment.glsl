// lightballs
// @author alex via germangb

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float rez = mod(gl_FragCoord.x + gl_FragCoord.y, 2.0);
	if (rez == 0.0)
	{
	vec3 color1 = vec3(1.9, 0.25, 0.5);
	vec2 point1 = resolution/2.0 + vec2(sin(time*0.4) * 30.0,cos(time*0.3)* cos(time*2.0) * 25.0);
	vec2 dist1 = gl_FragCoord.xy - point1;
	float intensity1 = sqrt (pow(52.0/(0.01+length(dist1)), 2.0));
	gl_FragColor = vec4((color1*intensity1),1.0);
	}
	else if (rez == 1.0)
	{
	vec3 color3 = vec3(0.25, 0.5, 0.7);
	vec2 point3 = resolution/2.0 + vec2(sin(time*0.45)*sin(time)*55.0, sin(time*0.79)*65.0)*2.0;
	vec2 dist3 = gl_FragCoord.xy - point3;
     	float intensity3 = (pow(112.0/(0.01+length(dist3)), 1.0));
	
	gl_FragColor = vec4((color3*intensity3),1.0);
	}
	else
	{
	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
	}
}