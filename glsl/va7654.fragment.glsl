#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform float glow;
uniform float glowClamp;

uniform float fgRC;
uniform float fgGC;
uniform float fgBC;

uniform float bgRC;
uniform float bgGC;
uniform float bgBC;
uniform float bulge;
uniform float patternRes;
uniform float accel;

uniform float pattern1Speed;
uniform float pattern2Speed;

#define PI 3.14159265358979323846264

//mattdesl - devmatt.wordpress.com - textured sphere by Matt DesLauriers

void main( void ) {
	
	float glow = 0.55;
	float glowClamp = 0.0;
	
	float fgRC = 1.0;
	float fgGC = .0;
	float fgBC = 0.9;
	
	float bgRC = 0.0;
	float bgGC = 0.5;
	float bgBC = 1.9;
	
	float bulge = 1.0;
	float patternRes = 0.43;
	
	float pattern1Speed = 1.9;
	float pattern2Speed = 2.9;
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
	position.x *= resolution.x / resolution.y;
	
	vec2 norm = 2.0 * gl_FragCoord.xy / resolution.xy - 1.0;
	norm.x *= resolution.x / resolution.y;
	
	float r = length(norm);
	float phi = atan(norm.y, norm.x);
	
	//spherize
	r = 2.0 * asin(r) / PI;
	
	//bulge a bit
	r = pow(r, bulge);
	
	//zoom in a bit
	r /= 1.25;
	
	vec2 coord = vec2(r * cos(phi), r * sin(phi));
	coord = coord/patternRes + 5.;

	
	//color += sin(coord.y) + cos(coord.y * 30.0);
	//color *= cos(coord.y*80.0);

	//color -= sin(coord.x*sin(coord.y*5.0)*9.0)*20.0;
	//	float	time = sin(time*1.0)*2.0-1.;
	
//	color.rgb += 0.25*sin(coord.y*sin(coord.x*0.0)*9.0)*2.5;
//	color.rgb += 0.45*sin(coord.x*30.0*sin(coord.y*1.0));
	
	float rings = 1.0;
	
	coord.x += time*0.07;
	
	float block = 100.0;
	rings += cos(coord.y*block)* 10.0;
	rings *= sin(coord.x*block)* 1.35;
	rings *= cos(coord.x*block) * 0.05;
	rings *= sin(coord.y*block);
	
	//assymetry
	rings -= sin(coord.y*block)*.1;
	//rings += sin(position.x*0.025)*100.0;
	
	rings += 0.05*sin(coord.x*25.0)* 25.0 * sin(time* pattern1Speed);	// pattern1 speed
	rings += 0.05*sin(coord.y*25.0)* 25.0 * sin(time* pattern2Speed);	// pattern2 speed
	

	
	rings = clamp(rings, .00, 1.05);
	
	float len = length(position);
	
	vec3 color = mix(vec3(fgRC, fgGC, fgBC), vec3(bgRC, bgGC, bgBC), rings);
	

	color *= smoothstep(0.54, 0.45, len);
	
	
	gl_FragColor = vec4( color, 1.0 );

}